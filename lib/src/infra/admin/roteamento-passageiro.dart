import 'package:flutter/material.dart';
import 'package:gocar/src/pages/passageiro-page/pages.dart';

final routesPassageiroConfig = <String, WidgetBuilder>{
  "/intro": (BuildContext context) => IntroPage(),
  "/account": (BuildContext context) => AccountPage(),
  "/recoverypass": (BuildContext context) => RecuperarSenhaPage(),
  "/hometab": (BuildContext context) => HomeTabPage(),

};

class NavigationPagesPassageiro {
  static void goToIntroReplacementNamed(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/intro");
  }

  static void goToAccount(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/account");
  }

  static void goToRecoveryPass(BuildContext context) {
    Navigator.pushNamed(context, "/recoverypass");
  }

  static void goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/hometab");
  }

  static void goToStartViagem(BuildContext context) {
    Navigator.pushNamed(context, "/startviagem");
  }
}
