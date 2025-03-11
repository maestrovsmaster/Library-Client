import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:leeds_library/data/models/app_user.dart';
import 'package:leeds_library/data/net/result.dart';

class SignInRepository {
  final Dio _dio;

  SignInRepository(this._dio);


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




  Future<Result<AppUser?, String>> verifyTokenWithServer() async {

    try {

      final response = await _dio.post(
        '/auth-verifyToken',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("verifyTokenWithServer response = $response");

      if (response.statusCode == 200 && response.data != null) {
        return Result.success(AppUser.fromJson(response.data));
      }else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error verifying token: $e');
      return Result.failure("Network error: $e");
    }

  }

  Future<Result<AppUser, String>> updateUser(AppUser user) async {
    try {
      final response = await _dio.post(
        '/auth-updateUser',
        data: user.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Result.success(AppUser.fromJson(response.data));
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      return Result.failure("Network error: $e");
    }
  }
}

