import 'dart:convert';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PesanPage extends StatefulWidget {
  const PesanPage({super.key});

  @override
  State<PesanPage> createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  @override
  void initState() {
    super.initState();
    obrolan.connectWS('obrolan-${obrolan.karyawanId.value}');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        toolbarHeight: 65,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              obrolan.namaKaryawan.value,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryColor,
              child: Text(
                obrolan.namaKaryawan.value.substring(0, 2),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            final list = obrolan.dataObrolan;
            if (list.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada pesan',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 90),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final msg = list[index];
                final isOwner = msg['owner'] == true;
                return ChatMessage(
                    messages: list, index: index, isOwner: isOwner);
              },
            );
          }),

          // input area
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: obrolan.messageC,
                      decoration: InputDecoration(
                        hintText: "Ketikkan pesanmu...",
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(129, 70, 191, 26),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width / 20,
                        ),
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      final message = obrolan.messageC.text.trim();
                      if (message.isEmpty) return;

                      obrolan.sendData(
                        'obrolan-${obrolan.karyawanId.value}',
                        'message',
                        message,
                        DateFormat('HH:mm').format(DateTime.now()),
                        obrolan.namaKaryawan.value,
                      );
                      obrolan.messageC.clear();
                    },
                    child: const CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 25,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.messages,
    required this.index,
    required this.isOwner,
  });

  final List messages;
  final int index;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final msg = messages[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment:
            isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: isOwner ? Alignment.topRight : Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isOwner ? AppColors.primaryColor : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Text(
                msg['message'],
                style: TextStyle(
                  fontSize: 16,
                  color: isOwner ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: isOwner
                ? const EdgeInsets.only(right: 5)
                : const EdgeInsets.only(left: 5),
            child: Text(
              msg['time'],
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}
