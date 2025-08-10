import 'package:dio/dio.dart' as dio_service;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioService {
  Dio dio = Dio();

  Future<dynamic> getMetode(String url, {Options? options}) async {
    debugPrint(url);
    return await dio
        .get(
          url,
          options:
              options ??
              Options(responseType: ResponseType.json, method: 'GET'),
        )
        .then((response) {
          // log(response.toString());
          return response;
        })
        .catchError((err) {
          if (err is DioError) {
            return err.response!;
          }
        });
  }

  Future<dynamic> postMetode(
    Map<String, dynamic> map,
    String url, {
    Options? options,
  }) async {
    return await dio
        .post(
          url,
          options:
              options ??
              Options(
                responseType: ResponseType.json,
                method: "POST",
                // headers: {'Content-Type': 'application/json'},
              ),
          data: dio_service.FormData.fromMap(map),
        )
        .then((value) {
          debugPrint(value.toString());
          return value;
        })
        .catchError((err) {
          if (err is DioError) {
            return err.response!;
          }
        });
  }

  /// ارسال به صورت JSON
  Future<dynamic> postJson(
    Map<String, dynamic> map,
    String url, {
    Options? options,
  }) async {
    return await dio
        .post(
          url,
          options:
              options ??
              Options(
                responseType: ResponseType.json,
                method: "POST",
                // headers: {'Content-Type': 'application/json'},
              ),
          data: map,
        )
        .then((value) {
          debugPrint(value.toString());
          return value;
        })
        .catchError((err) {
          if (err is DioError) {
            return err.response!;
          }
        });
  }
}
