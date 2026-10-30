// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../routes/state_global.dart';

class ObrolanController extends GetxController {
  late TextEditingController messageC = TextEditingController();

  final dataObrolan = <Map<String, dynamic>>[].obs;
  final dataObrolanMember = <Map<String, dynamic>>[].obs;
  final karyawanId = ''.obs;
  final namaKaryawan = ''.obs;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  bool get isConnected => _channel != null;

  /// 🔌 Koneksi WebSocket (mencegah duplikasi koneksi)
  Future<void> connectWS(String channelName) async {
    // Jika sudah ada koneksi lama, tutup dulu agar tidak dobel
    await disconnectWS();

    try {
      final tokenValue = token.read('token');
      final uri = Uri.parse('$baseUrlWS/$channelName');
      print('🔌 Connecting to $uri');

      _channel = IOWebSocketChannel.connect(
        uri,
        headers: {
          'Authorization': 'Bearer $tokenValue',
        },
      );

      // Pastikan tidak ada listener lama
      _subscription = _channel!.stream.listen(
        (event) {
          print('📩 Message received: $event');
          try {
            final data = jsonDecode(event);
            dataObrolan.add({
              'ownerId': data['ownerId'],
              'owner': data['owner'],
              'event': data['event'],
              'channel': data['channel'],
              'message': data['message'],
              'time': data['time'],
            });
          } catch (e) {
            print('⚠️ JSON decode error: $e');
          }
        },
        onDone: () {
          print('🔌 WebSocket closed');
          _channel = null;
          _subscription?.cancel();
          _subscription = null;
        },
        onError: (error) {
          print('⚠️ WebSocket error: $error');
          snackbarNotif.unsuccess('WebSocket Error', error.toString());
        },
      );
    } catch (e) {
      print('❌ Connection failed: $e');
      snackbarNotif.unsuccess('Connection Failed', e.toString());
    }
  }

  /// 🚀 Kirim pesan ke server WebSocket
  Future<void> sendData(
    String channel,
    String event,
    String message,
    String time,
    String member,
  ) async {
    final payload = {
      'owner': token.read('owner'),
      'ownerId': token.read('_id'),
      'channel': channel,
      'event': event,
      'message': message,
      'time': time,
    };

    try {
      if (!isConnected) {
        print('⚠️ WS not connected — reconnecting...');
        await connectWS(channel);
      }

      _channel?.sink.add(jsonEncode(payload));

      // Simpan juga ke database
      await insertAPIObrolan(
        token.read('owner'),
        token.read('_id'),
        channel,
        event,
        message,
        time,
      );

      messageC.clear();
    } catch (e) {
      print('❌ Send failed: $e');
    }
  }

  /// 🚪 Tutup koneksi WebSocket
  Future<void> disconnectWS() async {
    try {
      await _subscription?.cancel();
      _subscription = null;
      await _channel?.sink.close();
      _channel = null;
      print('🔒 WebSocket disconnected');
    } catch (e) {
      print('⚠️ Disconnect error: $e');
    }
  }

  // ==============================
  // API Calls
  // ==============================

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
      var response = await http.post(
        Uri.parse('$baseUrl/obrolan/$ownerId/get-by-owner/insert'),
        body: json.encode({
          'ownerId': ownerId,
          'owner': owner,
          'channel': channel,
          'event': event,
          'message': message,
          'time': time,
        }),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        snackbarNotif.unsuccess('Unsuccess', data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> getAPIObrolanByChannel(String channel) async {
    try {
      var idOwner = token.read('_id');
      var response = await http.get(
        Uri.parse('$baseUrl/obrolan/$idOwner/get-by-owner/$channel/channel'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        Get.snackbar(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
        );
        return dataObrolan;
      }

      dataObrolan.clear();
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
      return dataObrolan;
    }
  }

  Future<List> getAPIObrolanMember() async {
    var idOwner = token.read('_id');
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/obrolan/$idOwner/get-by-owner'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        Get.snackbar(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
        );
        return dataObrolanMember;
      }

      dataObrolanMember.clear();
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
      return dataObrolanMember;
    }
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
        Uri.parse('$baseUrl/obrolan/$ownerId/get-by-owner/insert'),
        body: json.encode({
          'ownerId': ownerId,
          'channel': channel,
          'member': member,
          'lastMessage': message,
          'lastTime': time,
        }),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['lastMessage']).toString().capitalizeFirst}',
        );
      }

      print('✅ Obrolan member berhasil diperbarui');
    } catch (e) {
      print(e);
    }
  }
}
