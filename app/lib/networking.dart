import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';

class DioClient {
  final dio.Dio _dio = dio.Dio();
  final box = GetStorage();

  // final _baseUrl = 'http://192.168.2.100:3000';
  final _baseUrl = 'http://3.14.86.171:3000';

  Future<dynamic> uploadImages(files) async {
    // Perform GET request to the endpoint "/users/<id>"

    var formData = dio.FormData.fromMap({
      "files": files
          .map((file) =>
              dio.MultipartFile.fromFileSync(file.path, filename: file.path))
          .toList()
    });
    _dio.options.headers['token'] = box.read("accessToken");

    dynamic userData =
        await _dio.post("$_baseUrl/tickets/upload", data: formData);

    return userData.data;
  }

  Future<dynamic> createTickets(data) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['token'] = box.read("accessToken");
    dynamic userData = await _dio.post("$_baseUrl/tickets", data: data);
    return userData;
  }

  Future<dynamic> login(data) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    dynamic userData = await _dio.post("$_baseUrl/users/login", data: data);
    return userData.data;
  }

  Future<dynamic> signup(data) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    dynamic userData = await _dio.post("$_baseUrl/users/signup", data: data);
    return userData.data;
  }

  Future<dynamic> getScannedTicketCount({event}) async {
    _dio.options.headers['token'] = box.read("accessToken");
    dynamic resp = await _dio.get("$_baseUrl/tickets/scanned-ticket-count");
    return resp.data;
  }

  Future<dynamic> getScannedTicketPercentage({event}) async {
    _dio.options.headers['token'] = box.read("accessToken");
    dynamic resp =
        await _dio.get("$_baseUrl/tickets/scanned-ticket-percentage");
    return resp.data;
  }

  Future<dynamic> getTicket({event}) async {
    _dio.options.headers['token'] = box.read("accessToken");
    dynamic userData = await _dio.get("$_baseUrl/tickets?event=$event");
    return userData.data;
  }

  Future<dynamic> updateScannedStatus(uuid) async {
    _dio.options.headers['token'] = box.read("accessToken");
    try {
      dynamic userData = await _dio.put("$_baseUrl/tickets/scan/$uuid");
      log("userData $userData");
      return userData.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createEvent(data) async {
    _dio.options.headers['token'] = box.read("accessToken");
    dynamic events = await _dio.post("$_baseUrl/events", data: data);
    return events.data;
  }

  Future<dynamic> getEvent() async {
    _dio.options.headers['token'] = box.read("accessToken");
    dynamic events = await _dio.get("$_baseUrl/events");
    log("events $events");
    return events.data;
  }
}
