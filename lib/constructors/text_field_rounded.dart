import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../style/styles.dart';

Padding textFieldRounded(
    dataLabel, controller, obsctureText, keyboardType, readOnly, size) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width / 250),
        child: TextField(
            readOnly: readOnly,
            keyboardType: keyboardType,
            obscureText: obsctureText,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
              filled: true,
              enabled: true,
              border: const OutlineInputBorder(),
              labelText: dataLabel,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(color: Colors.black),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
              hintText: "Masukkan $dataLabel disini...",
            ))),
  );
}

Padding textFieldRoundedwithHint(dataLabel, controller, obsctureText,
    keyboardType, hint, align, size, limitInput) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width / 250),
        child: TextField(
            textAlign: align,
            inputFormatters: [LengthLimitingTextInputFormatter(limitInput)],
            keyboardType: keyboardType,
            obscureText: obsctureText,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
              filled: true,
              enabled: true,
              border: const OutlineInputBorder(),
              labelText: dataLabel,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(color: Colors.black),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
              hintText: hint,
            ))),
  );
}

Padding textFieldRoundedCurrentwithHint(
    dataLabel, controller, obsctureText, keyboardType, hint, align, size) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width / 250),
        child: TextField(
            textAlign: align,
            keyboardType: keyboardType,
            obscureText: obsctureText,
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              CurrentFormat()
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
              filled: true,
              enabled: true,
              border: const OutlineInputBorder(),
              labelText: dataLabel,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(color: Colors.black),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
              hintText: hint,
            ))),
  );
}

class CurrentFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    num value = num.parse(newValue.text);
    final current =
        NumberFormat.currency(locale: "en", symbol: "Rp. ", decimalDigits: 0);

    String newText = current.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
