import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/local_user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheVisitorDetails({required LocalUserModel visitorModel});
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheVisitorDetails({required LocalUserModel visitorModel}) async {
    try {
      await sharedPreferences.setString('village', visitorModel.village ?? "");
      await sharedPreferences.setStringList(
          'talukas', visitorModel.talukas ?? []);
      await sharedPreferences.setStringList(
          'districts', visitorModel.districts ?? []);
      await sharedPreferences.setString('state', visitorModel.state ?? "");
      await sharedPreferences.setString('formID', visitorModel.formID ?? "");
      await sharedPreferences.setString(
          'createdOn', visitorModel.createdOn ?? "");
      // if (!success) {
      //   throw const CacheException(
      //       statusCode: "501",
      //       message: "Failed to store household questions in cache");
      // }
    } on TypeError {
      throw const CacheException(
          statusCode: "501", message: "Failed to store visitor data in cache");
    } on ArgumentError {
      throw const CacheException(
          statusCode: "501", message: "Failed to store visitor data in cache");
    } on FileSystemException {
      throw const CacheException(
          statusCode: "502",
          message:
              "Failed to store visitor data in cache. Please check file permissions");
    } on CacheException {
      rethrow;
    }
  }
}
