import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:gocar/src/provider/provider.dart';

import '../../../pages.dart';
import '../../pages.dart';

class EncerrarCorridaWidget extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  EncerrarCorridaWidget(this.scaffoldKey);

  BaseMotoristaBloc _authBase = BlocProvider.getBloc<BaseMotoristaBloc>();
  ViagemService _viagemService = new ViagemService();
  BaseMotoristaBloc _baseBloc = BlocProvider.getBloc<BaseMotoristaBloc>();
  HomeMotoristaBloc _homeBloc = BlocProvider.getBloc<HomeMotoristaBloc>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SwipeButton(
            thumb: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                    widthFactor: 0.90,
                    child: Icon(
                      Icons.chevron_right,
                      size: 30.0,
                      color: Colors.black,
                    )),
              ],
            ),
            content: Center(
              child: Text(
                'Finalizar Corrida !',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onChanged: (result) {
              if (result == SwipePosition.SwipeRight) {
                _finalizarViagem().then((r) {
                  ShowSnackBar.build(
                      scaffoldKey, 'Corrida finalizada com sucesso.', context);
                });
              } else {}
            },
          ),
        ),
      ),
    );
  }

  Future<void> _finalizarViagem() async {
    Viagem viagem = await _authBase.viagemFlux.first;
    viagem.Status = StatusViagem.Finalizada;
    await _viagemService.save(viagem);
    Future.delayed(const Duration(milliseconds: 1000), () {
      _homeBloc.stepMotoristaEvent.add(StepMotoristaHome.Inicio);
      _baseBloc.orchestration();
    });
  }
}
