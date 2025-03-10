import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:leeds_library/data/models/app_user.dart';
import 'package:leeds_library/data/net/result.dart';

class SignInRepository {
  final Dio _dio;

  SignInRepository(this._dio);

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

