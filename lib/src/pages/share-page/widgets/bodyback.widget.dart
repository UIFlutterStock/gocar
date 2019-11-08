import 'package:flutter/cupertino.dart';
import 'package:gocar/src/infra/infra.dart';

class BodyBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: ColorsStyle.getColorBackGround()));
  }
}
