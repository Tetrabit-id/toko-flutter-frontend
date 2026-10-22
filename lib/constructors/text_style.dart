import 'package:flutter/material.dart';

String capitalizeEachWord(String text) {
  return text.split(' ').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

Text paragraf(String label, TextAlign align) {
  return Text(
    label,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Lato',
    ),
    textAlign: align,
  );
}

Text paragrafSecond(String label, TextAlign align) {
  return Text(
    label,
    style: const TextStyle(
      fontSize: 15,
      fontFamily: 'Lato',
    ),
    textAlign: align,
  );
}

Text headerOne(String label) {
  return Text(
    textAlign: TextAlign.center,
    label,
    style: const TextStyle(
        fontSize: 32, fontWeight: FontWeight.w600, fontFamily: 'Lato'),
  );
}

Text headerOneWhite(String label) {
  return Text(
    textAlign: TextAlign.center,
    label,
    style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Lato'),
  );
}

Text headerNotFound(String label) {
  return Text(
    label,
    style: const TextStyle(
        fontSize: 18, fontFamily: 'Lato', color: Colors.black38),
  );
}
