import 'dart:developer';

import 'package:dio/dio.dart' as dio;

class DioClient {
  final dio.Dio _dio = dio.Dio();

  final _baseUrl = 'http://192.168.2.107:3000';

  // TODO: Add methods

  Future<dynamic> uploadImages(files) async {
    // Perform GET request to the endpoint "/users/<id>"

    var formData = dio.FormData.fromMap({
      "files": files
          .map((file) =>
              dio.MultipartFile.fromFileSync(file.path, filename: file.path))
          .toList()
    });

    dynamic userData =
        await _dio.post("$_baseUrl/tickets/upload", data: formData);

    return userData.data;
  }

  Future<dynamic> create(data) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    dynamic userData = await _dio.post("$_baseUrl/tickets", data: data);
    return userData;
  }

  Future<dynamic> get() async {
    dynamic userData = await _dio.get("$_baseUrl/tickets");
    return userData.data;
  }

  Future<dynamic> updateScannedStatus(uuid) async {
    dynamic userData = await _dio.put("$_baseUrl/tickets/$uuid");
    log("userData $userData");
    return userData.data;
  }
}
