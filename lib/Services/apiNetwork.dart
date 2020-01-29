import 'dart:async';
import 'package:path/path.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:promise/Library/model/model.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
   static NetworkUtil _instance = new NetworkUtil.internal();
   NetworkUtil.internal();
  factory NetworkUtil() => _instance;
  Dio connect = Dio();
  var baseUrl = "http://promise.kanwilsumbagut.com/mobile/";

  Future<dynamic> getHeaders() async {
    return {
      // "UID": auth.uid,
      // "ACCESS_TOKEN": auth.accessToken,
      // "DEVICE_TOKEN": auth.deviceToken,
      // "CLIENT": auth.clientId
      //"Key": apiKey ? apiKey : null,
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
  }

   Future postData(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((response) {
      return response;
    });
  }

  Future sendData(String ctrl, data,{user_id,id_role,nama_bidang}) async{
  var url = baseUrl + ctrl;
  FormData formData = new FormData();
  formData.fields
    ..add(MapEntry("user_id", user_id))
    ..add(MapEntry("id_role", id_role));
    
  data.forEach((value)=>{
    formData.fields
    ..add(MapEntry(value['key'], value['value']))
  });
  var response = await connect.post(url,data:formData);// or ResponseType.JSON);
    var body =jsonDecode(response.toString());
    return body;
}

Future getReport(String lk,{bidang, user, role}) async{
   var url = baseUrl + lk;
    FormData formData = new FormData();
    formData.fields
    ..add(MapEntry("nama_bidang", bidang))
    ..add(MapEntry("user_id", user))
    ..add(MapEntry("id_role", role));

    var response = await connect.post(url,data:formData);// or ResponseType.JSON);
    var body =jsonDecode(response.toString());
    return body;
}
  Future getAuth(String lk,{UserLogin user}) async{
    var url = baseUrl + lk;
    FormData formData = new FormData();
    formData.fields
    ..add(MapEntry("user_id", user.username))
    ..add(MapEntry("password", user.password));

    var response = await connect.post(url,data:formData);// or ResponseType.JSON);
    var body =jsonDecode(response.toString());
    return body;
  }

  Future getReportVip(String lk,{UserData user,dataform}) async{
    var url = baseUrl + lk;
    FormData formData = new FormData();
    if(dataform!=null){
      dataform.forEach((value)=>{
          formData.fields
          ..add(MapEntry(value['key'], value['value']))
        });
    }
    formData.fields
    ..add(MapEntry("user_id", user.uid));

    var response = await connect.post(url,data:formData);// or ResponseType.JSON);
    var body =jsonDecode(response.toString());
    return body;
  }

  Future kirimEmail(String lk,{email}) async{
    var url = baseUrl + lk;
    FormData formData = new FormData();
    formData.fields
    ..add(MapEntry("email", email));

    var response = await connect.post(url,data:formData);// or ResponseType.JSON);
    var body =jsonDecode(response.toString());
    return body;
  }
  Future tukarPassword(String lk,{ChangePassword password,userid}) async{
    var url = baseUrl + lk;
    FormData formData = new FormData();
    formData.fields
    ..add(MapEntry("user_id", userid))
    ..add(MapEntry("password_lama", password.password))
    ..add(MapEntry("password_baru", password.newpassword))
    ..add(MapEntry("password_konfirmasi", password.repeatpassword));

    var response = await connect.post(url,data:formData);// or ResponseType.JSON);
    var body =jsonDecode(response.toString());
    return body;
  }

  //  Future<http.Response> post(String url, {Map headers, body, encoding}) {
  //   return http
  //       .post(url, body: body, headers: headers, encoding: encoding)
  //       .then((http.Response response) {
  //     return handleResponse(response);
  //   });
  // }
  
  // http.Response handleResponse(http.Response response) {
  //   final int statusCode = response.statusCode;
  //   if (statusCode == 401) {
  //     throw new Exception("Unauthorized");
  //   } else if (statusCode != 200) {
  //     throw new Exception("Error while fetching data");
  //   }
  
  //   return response;
  // }
}