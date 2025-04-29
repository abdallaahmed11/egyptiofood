import 'package:egyption_foods/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// To sign up with email, and password.
  Future<dynamic> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        return user;
      }
      return AppStrings.unknownErrorToast;
    } on FirebaseAuthException catch (error) {
      if (error.code == AppStrings.emailAlreadyInUseErrorCode) {
        return AppStrings.emailAlreadyInUseToast;
      } else if (error.code == AppStrings.networkRequestFailedErrorCode) {
        return AppStrings.pleaseCheckYourInternetConnectionToast;
      }
      return AppStrings.unknownErrorToast;
    } catch (error) {
      return error.toString();
    }
  }

  /// To login with email, and password.
  Future<dynamic> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        return AppStrings.pleaseVerifyYourEmailFirstToast;
      }
      return user;
    } on FirebaseAuthException catch (error) {
      if (error.code == AppStrings.userNotFoundErrorCode) {
        return AppStrings.userNotFoundPleaseCheckYourEmailAddressToast;
      } else if (error.code == AppStrings.wrongPasswordErrorCode) {
        return AppStrings.wrongPasswordProvidedForThatUserToast;
      } else if (error.code == AppStrings.invalidEmailErrorCode) {
        return AppStrings.invalidEmailValidation;
      } else if (error.code == AppStrings.invalidCredentialErrorCode) {
        return AppStrings.pleaseMakeSureThatYouHaveSignedUpWithThatEmailAndPasswordToast;
      } else if (error.code == AppStrings.networkRequestFailedErrorCode) {
        return AppStrings.pleaseCheckYourInternetConnectionToast;
      }
      return AppStrings.unknownErrorToast;
    } catch (error) {
      return error.toString();
    }
  }

  /// To send reset password email.
  Future<String?> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return AppStrings.passwordResetEmailSentPleaseCheckYourInboxToast;
    } on FirebaseAuthException catch (error) {
      if (error.code == AppStrings.userNotFoundErrorCode) {
        return AppStrings.userNotFoundPleaseCheckYourEmailAddressToast;
      } else {
        return null;
      }
    } catch (error) {
      return error.toString();
    }
  }

  /// To sign out from the current account.
  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().disconnect();

      return AppStrings.signedOutText;
    } on FirebaseAuthException catch (error) {
      if (error.code == AppStrings.networkRequestFailedErrorCode) {
        return AppStrings.pleaseCheckYourInternetConnectionToast;
      }
      return AppStrings.unknownErrorToast;
    } catch (error) {
      return error.toString();
    }
  }
}
