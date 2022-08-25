import 'dart:convert';

import 'package:http/http.dart' as http;

class BlockChain  {

  static String apiURL = 'http://Warr10r.pythonanywhere.com/api/';
  static var headers = {
    'Content-Type': 'application/json'
  };

  static Future<List<Map<String, dynamic>>> getDetails(String id, String type) async {
    List<Map<String, dynamic>> transactionDetails = [];
    http.Response response;

    try{
      var endPoint = Uri.parse('${apiURL}details/');
      var body = jsonEncode({"id": id, "type":type});
      response = await http.post(endPoint, body: body, headers: headers);

      print(response.body.runtimeType);
      for(Map<String, dynamic> x in jsonDecode(response.body) ) {
        print(x);
        transactionDetails.add(x);
      }
    }
    catch(e){
      transactionDetails = null;
      print(e);
    }
    return transactionDetails;
  }

  static Future<Map<int, String>> addDetails(String id, String sender, String receiver, String type) async {
    Map<int, String> toReturn = {-1: "Failure"};
    http.Response response;

    try{
      var url = Uri.parse('${apiURL}transaction/new');
      var body = jsonEncode({"id": id, "sender": sender, "reciever": receiver, "type":type});

      response = await http.post(url, body: body, headers: headers);

      if(response.statusCode == 200 || response.statusCode == 201)  {
        toReturn = {1 : response.body};
      } else  {
        toReturn = {response.statusCode : response.reasonPhrase};
      }
    } catch(e){
      print(e);
    }

    return toReturn;
  }


}