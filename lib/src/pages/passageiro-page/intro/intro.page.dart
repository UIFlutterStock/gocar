import 'package:flutter/material.dart';
import 'package:gocar/src/infra/infra.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

import 'widgets/pageview.widget.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final pages = [
    PageviewWidget.buildViewModel(
        'assets/images/intro/pick.png',
        'assets/images/intro/1.png',
        'Sua plataforma de viagens, simples e segura.'),
    PageviewWidget.buildViewModel(
        'assets/images/intro/pick.png',
        'assets/images/intro/2.png',
        'Faça suas viagens.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntroViewsFlutter(pages,
          doneText: const Text(
              'OK', style: TextStyle(fontWeight: FontWeight.bold)
          ),
          showNextButton: true,
          pageButtonsColor: Colors.black,
          pageButtonTextSize: 18,
          showBackButton: true,
          nextText: const Text(
            "PRÓXIMO", style: TextStyle(fontWeight: FontWeight.bold),),
          skipText: const Text(
              "PULAR", style: TextStyle(fontWeight: FontWeight.bold)),
          backText: const Text(
              "VOLTAR", style: TextStyle(fontWeight: FontWeight.bold)),
          onTapSkipButton: () => NavigationPagesMotorista.goToAccount(context),
          onTapDoneButton: () => NavigationPagesMotorista.goToAccount(context),
          pageButtonTextStyles: const TextStyle(color: Colors.black)),
    ); //Material App
  }
}
