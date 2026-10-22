// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diatera_pos/routes/base_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:http/http.dart' as http;

import '../routes/state_global.dart';

class ObrolanOldController extends GetxController {
  late TextEditingController messageC = TextEditingController();

  final dataObrolan = List.empty().obs;
  final dataObrolanMember = List.empty().obs;
  final karyawanId = ''.obs;
  final namaKaryawan = ''.obs;

  PusherClient pusher = PusherClient(
      '4a1a93d50f392c43add0', PusherOptions(cluster: 'ap1'),
      autoConnect: false);

  Future<void> connectWS() async {
    try {
      pusher.connect();
      getAPIObrolanMember();
    } catch (e) {
      pusher.disconnect();
      snackbarNotif.unsuccess(
        'Unsuccess',
        'Websocket Error',
      );
    }
  }

  void createChannel(String channelName) {
    pusher.subscribe(channelName);
    connectWS();
    return;
  }

  Stream<List> getDataWS(String channelName, String eventName) {
    final channel = pusher.subscribe(channelName);

    channel.bind('message', (event) {
      final data = jsonDecode(event!.data!);

      dataObrolan.add({
        'ownerId': data['ownerId'],
        'owner': data['owner'],
        'event': data['event'],
        'channel': data['channel'],
        'message': data['message'],
        'time': data['time'],
      });
    });

    return dataObrolan.stream;
  }

  Future<void> sendData(
    String channel,
    String event,
    String message,
    String time,
    String member,
  ) async {
    late String ownerId = '';
    token.read('owner') == true
        ? ownerId = token.read('_id')
        : ownerId = await getOwnerId();

    // obrolan.connectWS();

    try {
      var response = await http.post(Uri.parse('$baseUrl/ws/send'),
          body: json.encode({
            'owner': token.read('owner'),
            'channel': channel,
            'event': event,
            'message': message,
            'time': time,
          }),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Send data Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
      }

      await insertAPIObrolan(
        token.read('owner'),
        ownerId,
        channel,
        event,
        message,
        time,
      );

      // await insertOrUpdateAPIObrolanMember(
      //   member,
      //   ownerId,
      //   channel,
      //   message,
      //   time,
      // );

      messageC.clear();
      return print('Berhasil terkirim');
    } catch (e) {
      print(e);
    }
  }

  Future<String> getOwnerId() async {
    await getApiUsersK.getApi();
    print(getApiUsersK.dataUKaryawan[0]['_id']);
    return getApiUsersK.dataUKaryawan[0]['_id'];
  }

  Future<void> insertAPIObrolan(
    bool owner,
    String ownerId,
    String channel,
    String event,
    String message,
    String time,
  ) async {
    try {
      var response = await http
          .post(Uri.parse('$baseUrl/obrolan/$ownerId/get-by-owner/insert'),
              body: json.encode({
                'ownerId': ownerId,
                'owner': owner,
                'channel': channel,
                'event': event,
                'message': message,
                'time': time,
              }),
              headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Send data Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
      }

      print('Berhasil terkirim');
    } catch (e) {
      print(e);
    }
  }

  Future<List> getAPIObrolanByChannel(String channel) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/obrolan/$channel/channel'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data cabang
      if (response.statusCode != 200) {
        Get.snackbar(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );
        return dataObrolan;
      }
      //

      if (dataObrolan.isNotEmpty) {
        dataObrolan.clear();
        dataObrolan.refresh();
      }

      List obrolanData = (data as Map<String, dynamic>)['data'];

      for (var e in obrolanData) {
        dataObrolan.add({
          'ownerId': e['ownerId'],
          'owner': e['owner'],
          'event': e['event'],
          'channel': e['channel'],
          'message': e['message'],
          'time': e['time'],
        });
      }
      return dataObrolan;
    } catch (e) {
      print(e);
    }

    return dataObrolan;
  }

  Future<List> getAPIObrolanMember() async {
    var idOwner = token.read('_id');
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/obrolan-member/$idOwner/get-by-owner'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data cabang
      if (response.statusCode != 200) {
        Get.snackbar(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );
        return dataObrolanMember;
      }
      //

      if (dataObrolanMember.isNotEmpty) {
        dataObrolanMember.clear();
        dataObrolanMember.refresh();
      }

      List obrolanData = (data as Map<String, dynamic>)['data'];

      for (var e in obrolanData) {
        dataObrolanMember.add({
          '_id': e['_id'],
          'ownerId': e['ownerId'],
          'channel': e['channel'],
          'member': e['member'],
          'lastMessage': e['lastMessage'],
          'lastTime': e['lastTime'],
        });
      }
      return dataObrolanMember;
    } catch (e) {
      print(e);
    }

    return dataObrolanMember;
  }

  Future<void> insertOrUpdateAPIObrolanMember(
    String member,
    String ownerId,
    String channel,
    String message,
    String time,
  ) async {
    try {
      var response = await http.post(
          Uri.parse('$baseUrl/obrolan-member/$ownerId/get-by-owner/insert'),
          body: json.encode({
            'ownerId': ownerId,
            'channel': channel,
            'member': member,
            'lastMessage': message,
            'lastTime': time,
          }),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Send data Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['lastMessage']).toString().capitalizeFirst}',
        );
      }

      print('Berhasil terkirim');
    } catch (e) {
      print(e);
    }
  }
}
