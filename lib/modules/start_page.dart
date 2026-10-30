import 'package:tetrabit_toko_pos/modules/FirstPage/mobile_ui/welcomepage.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:flutter/cupertino.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      auth.autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomePageMobile();
  }
}
