import 'package:flutter/material.dart';

ElevatedButton buttonPrimary(
  String label,
  Color colorButton,
  Color colorText,
  Color colorBorder,
  Size size,
  void Function() tombol,
) {
  return ElevatedButton(
    onPressed: tombol,
    style: ElevatedButton.styleFrom(
        foregroundColor: colorText,
        backgroundColor: colorButton,
        side: BorderSide(color: colorBorder),
        shadowColor: Colors.transparent,
        fixedSize: size),
    child: Text(
      label,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Lato'),
    ),
  );
}

ElevatedButton buttonPrimaryWithLoading(
  String label,
  Color colorButton,
  Color colorText,
  Color colorBorder,
  Size size,
  bool loading,
  void Function() tombol,
) {
  return ElevatedButton(
    onPressed: tombol,
    style: ElevatedButton.styleFrom(
        foregroundColor: colorText,
        backgroundColor: colorButton,
        side: BorderSide(color: colorBorder),
        shadowColor: Colors.transparent,
        fixedSize: size),
    child: !loading
        ? Text(
            label,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Lato'),
          )
        : const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            )),
  );
}

ElevatedButton buttonPrimaryImg(
  String label,
  Color colorButton,
  Color colorText,
  Color colorBorder,
  Size size,
  Widget img,
  void Function() tombol,
) {
  return ElevatedButton(
    onPressed: tombol,
    style: ElevatedButton.styleFrom(
        foregroundColor: colorText,
        backgroundColor: colorButton,
        side: BorderSide(color: colorBorder),
        shadowColor: Colors.transparent,
        fixedSize: size),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        img,
        Text(
          label,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Lato'),
        ),
      ],
    ),
  );
}
