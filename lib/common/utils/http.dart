import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flowchat/common/store/store.dart';
import 'package:flowchat/common/utils/utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;

import '../values/values.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: SERVER_API_URL,
      connectTimeout: 10000,
      receiveTimeout: 5000,
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before request is sent
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
      },
      onError: (DioError e, handler) {
        // Do something with response error
        Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e); //continue
      },
    ));
  }

  void onError(ErrorEntity eInfo) {
    print('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
    switch (eInfo.code) {
      case 401:
        UserStore.to.onLogOut();
        EasyLoading.showError(eInfo.message);
        break;
      default:
        EasyLoading.showError('未知错误');
        break;
    }
  }

  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return ErrorEntity(code: -1, message: 'cancel');
      case DioErrorType.connectTimeout:
        return ErrorEntity(code: -1, message: 'connectTimeout');
      case DioErrorType.sendTimeout:
        return ErrorEntity(code: -1, message: 'sendTimeout');
      case DioErrorType.receiveTimeout:
        return ErrorEntity(code: -1, message: 'receiveTimeout');
      case DioErrorType.response:
        {
          try {
            int errCode = error.response != null ? error.response!.statusCode! : -1;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                return ErrorEntity(code: errCode, message: '请求语法错误');
              case 401:
                return ErrorEntity(code: errCode, message: '没有权限');
              case 403:
                return ErrorEntity(code: errCode, message: '服务器拒绝执行');
              case 404:
                return ErrorEntity(code: errCode, message: '无法连接服务器');
              case 405:
                return ErrorEntity(code: errCode, message: '请求方法被禁止');
              case 500:
                return ErrorEntity(code: errCode, message: '服务器内部错误');
              case 502:
                return ErrorEntity(code: errCode, message: '无效的请求');
              case 503:
                return ErrorEntity(code: errCode, message: '服务器挂了');
              case 505:
                return ErrorEntity(code: errCode, message: '不支持HTTP协议请求');
              default:
                {
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  return ErrorEntity(
                    code: errCode,
                    message: error.response != null ? error.response!.statusMessage! : '',
                  );
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: '未知错误');
          }
        }
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }

  void cancelRequests(CancelToken token) {
    token.cancel('cancelled');
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }

  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = !CACHE_ENABLE,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    //requestOptions.extra ??= <String, >{};
    requestOptions.extra!.addAll({
      'refresh': refresh,
      'noCache': noCache,
      'list': list,
      'cacheKey': cacheKey,
      'cacheDisk': cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post 操作
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful put 操作
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful patch 操作
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful delete 操作
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post form 表单提交操作
  Future postForm(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post Stream 流数据
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}

// 异常处理
class ErrorEntity implements Exception {
  int code = -1;
  String message = '';
  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == '') return 'Exception';
    return 'Exception: code $code, $message';
  }
}
