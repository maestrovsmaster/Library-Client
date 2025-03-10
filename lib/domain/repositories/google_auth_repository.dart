import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leeds_library/data/models/app_user.dart';

class GoogleAuthRepository {
  final Dio _dio;
  GoogleAuthRepository(this._dio);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    print('Sign in with Google');
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print('Google user: $googleUser');
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print('Google auth: $googleAuth');
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('Credential: $credential');
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    print('User credential: $userCredential');
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }




  Future<AppUser?> verifyTokenWithServer(String idToken) async {

    print("verifyTokenWithServer idtoken = $idToken");

    try {
      /*final response = await dio.post(
        '$baseUrl/auth-verifyToken',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
        ),
      );*/
      final response = await _dio.post(
        '/auth-verifyToken',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("verifyTokenWithServer response = $response");

      if (response.statusCode == 200 && response.data != null) {
        return AppUser.fromJson(response.data);
      }
    } catch (e) {
      print('Error verifying token: $e');
    }

    return null;
  }


}