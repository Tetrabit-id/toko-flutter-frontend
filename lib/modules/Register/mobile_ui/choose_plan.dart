import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constructors/text_style.dart';
import '../../../routes/route.dart';
import '../../../routes/state_global.dart';
import '../../../services/plan_service.dart';
import '../../../style/styles.dart';

class ChoosePlanPage extends StatelessWidget {
  const ChoosePlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.black)),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: AppImages.logoFull,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerOne('Pilih Paket'),
              const SizedBox(height: 10),
              paragraf(
                'Pilih paket yang sesuai dengan kebutuhan tokomu.',
                TextAlign.start,
              ),
              const SizedBox(height: 25),
              const PlanCard(info: planSubscription),
              const SizedBox(height: 15),
              const PlanCard(info: planOffline),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.info});
  final PlanInfo info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        postApiRegisterO.plan = info.value;
        Get.toNamed(RouteName.signUpMobile);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: info.plan == AppPlan.subscription
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 64, 223, 7),
                    Color.fromARGB(255, 5, 135, 29)
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              : null,
          color: info.plan == AppPlan.offline ? Colors.white : null,
          border: Border.all(color: AppColors.primaryColor, width: 1.5),
        ),
        child: Builder(builder: (context) {
          final textColor = info.plan == AppPlan.subscription
              ? Colors.white
              : AppColors.colorFontPrimary;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(info.nama,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 10),
              ...info.fitur.map((fitur) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('$fitur ✓', style: TextStyle(color: textColor)),
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(info.harga,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Lato',
                      )),
                  Icon(Icons.arrow_forward_rounded, color: textColor),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
