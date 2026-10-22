import 'package:flutter/material.dart';
import '../style/styles.dart';

class LoadingCilcular extends StatelessWidget {
  const LoadingCilcular({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
