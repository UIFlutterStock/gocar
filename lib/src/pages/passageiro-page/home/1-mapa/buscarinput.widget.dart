import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:gocar/src/provider/blocs/blocs.dart';

import '../../../pages.dart';

class BuscarInputWidget extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  BuscarInputWidget(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 100,
      child: Align(
        alignment: Alignment.topCenter,
        child: InkWell(
          onTap: () {
            _functionValidadeBuscarOrigemDestino(context);
          },
          child: new Container(
            margin: EdgeInsets.only(right: 5, left: 5),
            width: MediaQuery.of(context).size.width * 0.98,
            child: Text(
              "Para onde vamos?",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                color: Colors.white),
            padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          ),
        ),
      ),
    );
  }

  _functionValidadeBuscarOrigemDestino(BuildContext context) async {
    AuthPassageiroBloc authBloc = BlocProvider.getBloc<AuthPassageiroBloc>();
    HomePassageiroBloc homeBloc = BlocProvider.getBloc<HomePassageiroBloc>();
    HomeTabBloc homeTabBloc = BlocProvider.getBloc<HomeTabBloc>();

    Passageiro passageiro = await authBloc.userInfoFlux.first;

    if (passageiro == null) {
      await authBloc.refreshAuth();
      passageiro = await authBloc.userInfoFlux.first;
    }

    if (passageiro.Idade < 10) {
      ShowSnackBar.build(
          scaffoldKey,
          'Necessário completar o cadastrado para iniciar uma corrida. Por favor preencha a idade!',
          context);

      Future.delayed(const Duration(milliseconds: 4000), () {
        homeTabBloc.tabPageControllerEvent.add(1);
      });
    } else {
      homeBloc.stepProcessoEvent
          .add(StepPassageiroHome.SelecionarOrigemDestino);
    }
  }
}
