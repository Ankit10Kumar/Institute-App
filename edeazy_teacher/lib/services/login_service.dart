import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:edeazy_teacher/modals/aothorised_modal.dart';

class LoginServices {
  static var client = http.Client();
  static var baseURL = 'https://pure-crag-69424.herokuapp.com/api';

  static Future<UserData> login({
    required String userName,
    required String password,
  }) async {
    try {
      var response = await client
          .post(
            Uri.parse('$baseURL/auth/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              // "Access-Control-Allow-Origin": "*",
            },
            body: jsonEncode({
              "userName": userName,
              "password": password,
              "appRole": "Teacher"
            }),
          )
          .timeout(const Duration(seconds: 60));
      var data = jsonDecode(response.body);
      // if(data['isAccountVerified'] ?? true){
      //   throw "Account is not Verified";
      // }
      if (data['success']) {
        return UserData.fromJson(data['data']);
      }
      throw data['error']['message'] ?? 'No data';
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }

//APi Call for Change PAssword
  static Future<void> changePass(String pass, String token) async {
    try {
      var response = await client
          .post(
            Uri.parse("$baseURL/users/change-password"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'newPassword': pass}),
          )
          .timeout(const Duration(seconds: 30));
      var data = jsonDecode(response.body);
      if (data['success']) {
        return;
      }
      throw data['error']['message'] ?? 'No data';
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }

//Api Call for Upload/Update User Profile
  static Future<String> upload({
    required String imageFile,
    required String token,
    required String type,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('$baseURL/file/upload-profile-image'),
    );
    Map<String, String> headers = {"Authorization": 'Bearer $token'};
    request.headers.addAll(headers);

    try {
      var pic = await http.MultipartFile.fromPath("file", imageFile,
          contentType: MediaType('image', type));
      request.files.add(pic);
      var response = await request.send();
      request.fields['name'] = 'Gaand MAra MC';
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      final data = jsonDecode(responseString);
      if (data['success'] ?? false) {
        return data['imageUrl'];
      }
      throw data['error']['message'] ?? 'No data';
      // try {
      //   FormData formData = FormData.fromMap({
      //     'name': 'sabka baap',
      //     'file': http.MultipartFile.fromPath(
      //       'image',
      //       File.fromRawPath(imagebytes).path,
      //       filename: 'file',
      //       contentType: MediaType('image', type),
      //     )
      //   });
      //   var response = await Dio().post(
      //     "$baseURL/file/upload-profile-image",
      //     data: formData,
      //     options: Options(
      //       headers: headers,
      //     ),
      //   );
      //   return 'Hogya';
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }

//API call for User to update User Info
  static Future<UserData> updateProfileData(
      {required String token, required Object obj, required String id}) async {
    try {
      var response = await client.put(
        Uri.parse("$baseURL/users/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(obj),
      );
      var data = jsonDecode(response.body);
      if (data['success']) {
        return UserData.fromJson(data['data']);
      }
      throw data['error']['message'] ?? 'No data';
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }

//API Call for refreshing User Data
  static Future<UserData> fetchProfile(String token) async {
    try {
      var response =
          await client.get(Uri.parse("$baseURL/users/profile"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var data = jsonDecode(response.body);
      bool s = !data['success'];
      if (s) {
        throw data['error'] ?? 'No data';
      }
      return UserData.fromJson(data['data']);
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }
}
