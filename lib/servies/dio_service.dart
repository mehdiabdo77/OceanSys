import 'package:dio/dio.dart' as dio_service;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class DioService {
  Dio dio = Dio(
    BaseOptions(connectTimeout: 5000, receiveTimeout: 5000, sendTimeout: 5000),
  );

  Response _handleError(DioError err) {
    // وقتی اینترنتم قطع است
    if (err.type == DioErrorType.other && err.error is SocketException) {
      return Response(
        requestOptions: err.requestOptions,
        statusCode: 0,
        statusMessage: 'No Internet Connection',
      );
    }

    // مشکلات ارور سرور
    return Response(
      requestOptions: err.requestOptions,
      statusCode: err.response?.statusCode ?? -1,
      statusMessage: err.response == null
          ? "سرور در دسترس نیست"
          : _getErrorMessage(err.response?.statusCode),
    );
  }

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
          return response;
        })
        .catchError((err) {
          if (err is DioError) {
            return _handleError(err);
          }
          // خطای که ناشناخته است و تو لیستم نیست
          return Response(
            requestOptions: RequestOptions(path: url),
            statusCode: -1,
            statusMessage: 'خطای غیرمنتظره: ${err.toString()}',
          );
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
              Options(responseType: ResponseType.json, method: "POST"),
          data: dio_service.FormData.fromMap(map),
        )
        .then((value) {
          debugPrint(value.toString());
          return value;
        })
        .catchError((err) {
          if (err is DioError) {
            return _handleError(err);
          }
          // خطای که ناشناخته است و تو لیستم نیست
          return Response(
            requestOptions: RequestOptions(path: url),
            statusCode: -1,
            statusMessage: 'خطای غیرمنتظره: ${err.toString()}',
          );
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
              Options(responseType: ResponseType.json, method: "POST"),
          data: map,
        )
        .then((value) {
          debugPrint(value.toString());
          return value;
        })
        .catchError((err) {
          if (err is DioError) {
            return _handleError(err);
          }
          // خطای که ناشناخته است و تو لیستم نیست
          return Response(
            requestOptions: RequestOptions(path: url),
            statusCode: -1,
            statusMessage: 'خطای غیرمنتظره: ${err.toString()}',
          );
        });
  }
}

String _getErrorMessage(int? statusCode) {
  switch (statusCode) {
    case 400:
      return 'درخواست نامعتبر';
    case 401:
      return 'یوزر پسورد اشتباه';
    case 403:
      return 'ممنوع';
    case 404:
      return 'منبع یافت نشد';
    case 500:
      return 'خطای سرور داخلی';
    case 502:
      return 'درگاه نامعتبر';
    case 503:
      return 'سرویس در دسترس نیست';
    default:
      return 'خطای ناشناخته (کد: $statusCode)';
  }
}
