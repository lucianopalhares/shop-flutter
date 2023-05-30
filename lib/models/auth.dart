import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  
  static const _url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyArg0mLTGXg19gr7UQppO8VsUPVv7SIGFw';

  Future<void> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        'email': email, 
        'password': password, 
        'returnSecureToken': true
      })
    );

    print(jsonDecode(response.body));
  }
}