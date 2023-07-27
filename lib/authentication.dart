import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'http_exception.dart';


class Authentication with ChangeNotifier
{

  Future<void> signUp(String email, String password ) async
  {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBMOrlobPD1CPsMTQay7IoKf2grjDNQCi8';

    try{
      final response = await http.post(Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBMOrlobPD1CPsMTQay7IoKf2grjDNQCi8'),
          body: json.encode(
              {
                'email': email,
                'password': password,
                'returnSecureToken': true,
              }
          ));
      final responseData = json.decode(response.body);
      //print(responseData);
      if(responseData['error']!= null)
      {
        throw HttpException(responseData['error']['message']);
      }

    }catch(error)
    {
      throw error;
    }
    final response = await http.post(Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBMOrlobPD1CPsMTQay7IoKf2grjDNQCi8'),
        body: json.encode(
      {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }
    ));
    final responseData = json.decode(response.body);
    //print(responseData);

  }

  Future<void> logIn(String email, String password ) async
  {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyBMOrlobPD1CPsMTQay7IoKf2grjDNQCi8';

    try{
      final response = await http.post(Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyBMOrlobPD1CPsMTQay7IoKf2grjDNQCi8'),
          body: json.encode(
              {
                'email': email,
                'password': password,
                'returnSecureToken': true,
              }
          ));
      final responseData = json.decode(response.body);
      if(responseData['error']!= null)
        {
          throw HttpException(responseData['error']['message']);
        }
      //print(responseData);

    }catch(error)
    {
      throw error;
    }
      final response = await http.post(Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyBMOrlobPD1CPsMTQay7IoKf2grjDNQCi8'),
          body: json.encode(
              {
                'email': email,
                'password': password,
                'returnSecureToken': true,
              }
        ));
    final responseData = json.decode(response.body);
    print(responseData);
  }
}