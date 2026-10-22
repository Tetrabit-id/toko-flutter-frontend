// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:diatera_pos/models/user_owner.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:diatera_pos/routes/base_url.dart';

class DataLoginOwnerAPI extends GetxController {
  // Tombol Fungsi Login
  Future<Owner?> connectAPI(String email, String password) async {
    var token = base64Url.encode(utf8.encode('$email:$password'));
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: json.encode({}),
        headers: {'Authorization': 'Basic $token'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal connect api
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess('Unsuccess ${response.statusCode}',
            '${(data['message']).toString().capitalizeFirst}');

        return Owner();
      }
      //

      // Jika Success connect api
      var userData = (data as Map<String, dynamic>)['data'];

      return Owner.fromJson(userData);
      //
    } catch (e) {
      print(e);
    }
    return null;
  }

  //
  Future<Owner?> connectAPIbyGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount =
          await auth.googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      var dataGoogle = await auth.googleAuth
          .signInWithCredential(credential)
          .then((value) async {
        var tokenGoogle = await value.user!.getIdToken();

        // Register google Sign in New User
        if (value.additionalUserInfo!.isNewUser) {
          var response = await http.post(
            Uri.parse('$baseUrl/register/google'),
            body: json.encode({
              'email': value.additionalUserInfo!.profile!['email'],
              'name': value.additionalUserInfo!.profile!['name'],
              'store': '',
              'password': '',
              'googleTokenUserId': tokenGoogle,
            }),
          );

          var data = jsonDecode(response.body);

          // Jika gagal connect api
          if (response.statusCode != 200) {
            snackbarNotif.unsuccess('Unsuccess ${response.statusCode}',
                '${(data['message']).toString().capitalizeFirst}');

            return [];
          }
          //

          // Login Google ketika sudah register
          if (!value.additionalUserInfo!.isNewUser) {
            var response = await http.post(
              Uri.parse('$baseUrl/login/google'),
              body: json.encode({
                'googleTokenUserId': tokenGoogle,
              }),
            );

            var dataLogin = jsonDecode(response.body);

            // Jika gagal connect api
            if (response.statusCode != 200) {
              snackbarNotif.unsuccess('Unsuccess ${response.statusCode}',
                  '${(dataLogin['message']).toString().capitalizeFirst}');

              return [];
            }
            //

            // Jika Success connect api
            var userData = (await data as Map<String, dynamic>)['data'];

            return userData;
            //
          } // end
        } // end register

        // Login Google jika bukan user baru
        if (!value.additionalUserInfo!.isNewUser) {
          var response = await http.post(
            Uri.parse('$baseUrl/login/google'),
            body: json.encode({
              'googleTokenUserId': tokenGoogle,
            }),
          );

          var data = jsonDecode(response.body);

          // Jika gagal connect api
          if (response.statusCode != 200) {
            snackbarNotif.unsuccess('Unsuccess ${response.statusCode}',
                '${(data['message']).toString().capitalizeFirst}');

            return [];
          }
          //

          // Jika Success connect api
          var userData = (await data as Map<String, dynamic>)['data'];

          return userData;
          //
        } // end login
      });

      if (dataGoogle == null) {
        snackbarNotif.unsuccess('Unsuccess', 'Mohon coba login kembali');
        update();
        return dataGoogle;
      }

      return Owner.fromJson(dataGoogle);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
