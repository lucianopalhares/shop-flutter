import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

import '../data/store.dart';

class Auth extends ChangeNotifier {

  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expireDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expireDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }
  
  Future<void> _authenticate ( 
    String email, 
    String password, 
    String urlFragment
  ) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:${urlFragment}?key=AIzaSyArg0mLTGXg19gr7UQppO8VsUPVv7SIGFw';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email, 
        'password': password, 
        'returnSecureToken': true
      })
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn'])
        )
      );

      Store.saveMap('userData',{
        'token': _token, 
        'email': _email, 
        'userId': _userId, 
        'expireDate': _expireDate!.toIso8601String()
      });

      final userData = await Store.getMap('userData');

      if (userData.isEmpty) {
        print('userData.isEmpty = ${userData.values}');
      }

      _autoLogout();
      notifyListeners();
    }

  }

  Future<void> signup(String email, String password) async {    
    return _authenticate(email, password, 'signUp');    
  }

  Future<void> login(String email, String password) async {    
    return _authenticate(email, password, 'signInWithPassword');    
  }

  Future<void> tryAutoLogin() async {

    if (isAuth) return;

    try {
      final userData = await Store.getMap('userData');

      if (userData.isEmpty) {
        return;
      }

      final String expireDateString = userData['expireDate'].toString();

      final expireDate = DateTime.parse(expireDateString);

      if (expireDate.isBefore(DateTime.now())) return;

      _token = userData['token'].toString();
      _email = userData['email'].toString();
      _userId = userData['userId'].toString();
      _expireDate = expireDate;

      _autoLogout();
      notifyListeners();
    } catch (e) {
      print('tryAutoLogin error = $e');
    }
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expireDate = null;
    _clearAutoLogoutTimer();
    Store.remove('userData').then((_){
      notifyListeners();
    });    
  }

  void _clearAutoLogoutTimer() {
    _logoutTimer?.cancel(); 
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearAutoLogoutTimer();

    final timeToLogout = _expireDate?.difference(DateTime.now()).inSeconds;

    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0), 
      logout
    );
  }
}