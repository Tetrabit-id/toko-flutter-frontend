import 'package:flutter/material.dart';

class NFCReader extends StatefulWidget {
  const NFCReader({Key? key}) : super(key: key);

  @override
  State<NFCReader> createState() {
    return _NFCReaderState();
  }
}

class _NFCReaderState extends State<NFCReader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(child: Text("Letakan NFC Card")),
    );
  }
}
