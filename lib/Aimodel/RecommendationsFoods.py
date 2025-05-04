from flask import Flask, jsonify, request
from firebase_admin import credentials, firestore, initialize_app
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import MinMaxScaler
from sklearn.cluster import KMeans
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import pickle

app = Flask(__name__)

# Firebase setup
cred = credentials.Certificate("F:/egyption-foods-firebase-adminsdk-fbsvc-2aa4d1b9e6.json")
initialize_app(cred)
db = firestore.client()

# Try load existing KMeans model
try:
    with open('kmeans_model.pkl', 'rb') as f:
        kmeans = pickle.load(f)
except:
    kmeans = None

@app.route('/recommend', methods=['GET'])
def recommend():
    try:
        category_filter = request.args.get('category', None)
        min_price = request.args.get('min_price', None, type=float)
        max_price = request.args.get('max_price', None, type=float)
        user_id = request.args.get('user_id', None)  # New

        foods = []
        food_ids = []
        descriptions = []
        categories = []
        prices = []
        selled = []
        rates = []
        fav_count = {}

        # Build fav count
        users_docs = db.collection('users').stream()
        for user_doc in users_docs:
            user_data = user_doc.to_dict()
            if 'fav' in user_data:
                for item in user_data['fav']:
                    fav_count[item] = fav_count.get(item, 0) + 1

        # Fetch foods
        docs = db.collection('foods').stream()
        for doc in docs:
            data = doc.to_dict()
            if 'description' in data and 'category' in data and 'price' in data:
                if category_filter and data['category'] != category_filter:
                    continue
                if min_price and data['price'] < min_price:
                    continue
                if max_price and data['price'] > max_price:
                    continue

                food_ids.append(data.get('id'))
                descriptions.append(data.get('description', ''))
                categories.append(data.get('category', ''))
                prices.append(float(data.get('price', 0)))
                selled.append(int(data.get('selled', 0)))
                rates.append(float(data.get('rate', 0)))
                data['fav_count'] = fav_count.get(data.get('id'), 0)
                foods.append(data)

        # Feature engineering
        text_data = [desc + ' ' + cat for desc, cat in zip(descriptions, categories)]
        tfidf = TfidfVectorizer(stop_words='english')
        text_features = tfidf.fit_transform(text_data)

        numeric_features = np.array([
            prices,
            selled,
            rates,
            [fav_count.get(fid, 0) for fid in food_ids]
        ]).T
        scaler = MinMaxScaler()
        numeric_features_scaled = scaler.fit_transform(numeric_features)

        full_features = np.hstack((text_features.toarray(), numeric_features_scaled))

        global kmeans
        if kmeans is None:
            kmeans = KMeans(n_clusters=5, random_state=0)
            kmeans.fit(full_features)
            with open('kmeans_model.pkl', 'wb') as f:
                pickle.dump(kmeans, f)

        labels = kmeans.predict(full_features)

        clustered_foods = {}
        for idx, label in enumerate(labels):
            clustered_foods.setdefault(label, []).append(foods[idx])

        # If user_id provided, personalize cluster
        anchor_cluster = 0
        if user_id:
            user_doc = db.collection('users').document(user_id).get()
            if user_doc.exists:
                user_data = user_doc.to_dict()
                fav_items = user_data.get('fav', [])
                cluster_votes = {}
                for fav in fav_items:
                    if fav in food_ids:
                        idx = food_ids.index(fav)
                        cluster_label = labels[idx]
                        cluster_votes[cluster_label] = cluster_votes.get(cluster_label, 0) + 1
                if cluster_votes:
                    anchor_cluster = max(cluster_votes, key=cluster_votes.get)

        recommended = clustered_foods.get(anchor_cluster, [])

        recommended_with_scores = []
        for item in recommended:
            item['similarity_score'] = float(cosine_similarity([full_features[0]], [full_features[foods.index(item)]])[0][0])
            item['final_score'] = item['similarity_score'] + (item.get('rate', 0) * 0.2) + (item.get('selled', 0) / 1000) + (item.get('fav_count', 0) * 0.3)
            recommended_with_scores.append(item)

        recommended_with_scores = sorted(recommended_with_scores, key=lambda x: x['final_score'], reverse=True)[:5]

        return jsonify({"recommended_foods": recommended_with_scores})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
