import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStatechanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(displayName);

    return credential;
  }

  Future<void> initGoogleSignIn() async {
    await _googleSignIn.initialize();
  }

  Future<UserCredential> signInWithGoogle() async {
    // 1️⃣ Trigger Google sign-in
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    // 2️⃣ Obtain auth details
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'ERROR_MISSING_ID_TOKEN',
        message: 'Google ID Token not found',
      );
    }

    // 🔹 Create Firebase credential (NO accessToken)
    final credential = GoogleAuthProvider.credential(idToken: idToken);

    // 4️⃣ Sign in to Firebase
    return await firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential?> silentGoogleSignIn() async {
    final future = _googleSignIn.attemptLightweightAuthentication();
    if (future == null) return null;

    final user = await future;
    if (user == null) return null;

    final idToken = user.authentication.idToken;
    if (idToken == null) return null;

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserName({required String userName}) async {
    await currentUser!.updateDisplayName(userName);
    await currentUser!.reload();
  }
}
