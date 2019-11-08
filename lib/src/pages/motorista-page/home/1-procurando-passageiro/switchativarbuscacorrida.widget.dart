import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:gocar/src/provider/provider.dart';

import '../../../pages.dart';

class SwitchAtivarBuscaCorrida extends StatefulWidget {
  bool _value;
  GlobalKey<ScaffoldState> scaffoldKey;

  SwitchAtivarBuscaCorrida(this._value, this.scaffoldKey);

  @override
  _SwitchAtivarBuscaCorridaState createState() =>
      _SwitchAtivarBuscaCorridaState();
}

class _SwitchAtivarBuscaCorridaState extends State<SwitchAtivarBuscaCorrida> {
  bool _value = false;
  BaseMotoristaBloc _baseBloc;
  HomeMotoristaBloc _homeBloc;
  AuthMotoristaBloc _authMotoristaBlocBloc;
  HomeTabBloc _homeTabBloc;
  @override
  void initState() {
    _baseBloc = BlocProvider.getBloc<BaseMotoristaBloc>();
    _homeBloc = BlocProvider.getBloc<HomeMotoristaBloc>();
    _homeTabBloc = BlocProvider.getBloc<HomeTabBloc>();
    _authMotoristaBlocBloc = BlocProvider.getBloc<AuthMotoristaBloc>();
    _value = widget._value;
    super.initState();
  }


  validaInicioCorrida(bool value) async {
    Motorista motorista = await _authMotoristaBlocBloc.userInfoFlux.first;

    if (motorista == null) {
      await _authMotoristaBlocBloc.refreshAuth();
      motorista = await _authMotoristaBlocBloc.userInfoFlux.first;
    }

    if (motorista.Automovel == null || motorista.Automovel.Placa == null ||
        motorista.Automovel.Placa == '') {
      ShowSnackBar.build(
          widget.scaffoldKey,
          'Necessário completar o cadastrado para iniciar uma corrida. Por favor preencha informações relacionada ao veiculo!',
          context);

      Future.delayed(const Duration(milliseconds: 4000), () {
        _homeTabBloc.tabPageControllerEvent.add(1);
      });
      return;
    }

    _onChanged1(value);
  }

  void _onChanged1(bool value) =>
      setState(() {
    if (value) {
      _homeBloc.stepMotoristaEvent.add(StepMotoristaHome.Procurandoviagem);

        } else {
      _homeBloc.stepMotoristaEvent.add(StepMotoristaHome.Inicio);
        }

    Future.delayed(const Duration(milliseconds: 2000), () {
      _baseBloc.orchestration();
    });
        _value = value;
      });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: new Container(
          margin: EdgeInsets.only(top: 30, right: 25),
          child: Switch(
              activeColor: Colors.blueAccent,
              value: _value,
              onChanged: validaInicioCorrida),
        ),
      ),
    );
  }
}
