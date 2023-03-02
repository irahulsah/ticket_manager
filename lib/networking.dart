import 'package:dio/dio.dart' as dio;

class DioClient {
  final dio.Dio _dio = dio.Dio();

  final _baseUrl = 'https://reqres.in/api';

  // TODO: Add methods

  Future<dynamic> getUser(files) async {
    // Perform GET request to the endpoint "/users/<id>"

    var formData = dio.FormData.fromMap({
      "files": files
          .map((file) =>
              dio.MultipartFile.fromFileSync(file.path, filename: file.path))
          .toList()
    });

    dynamic userData = await _dio
        .post("http://192.168.2.107:3000/tickets/upload", data: formData);

    // Prints the raw data returned by the server
    print('User Info: ${userData}');

    // Parsing the raw JSON data to the User class

    return userData;
  }
}
