import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:gocar/src/entity/enums.dart';
import 'package:gocar/src/provider/blocs/blocs.dart';
import 'package:gocar/src/provider/provider.dart';

import '../../pages.dart';

class ConfirmarCorridaWidget extends StatelessWidget {

  BaseMotoristaBloc _authBase = BlocProvider.getBloc<BaseMotoristaBloc>();
  AuthMotoristaBloc _authMotoristaBloc = BlocProvider.getBloc<
      AuthMotoristaBloc>();
  ViagemService _viagemService = new ViagemService();

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
                'Aceitar Corrida !',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onChanged: (result) {
              if (result == SwipePosition.SwipeRight) {
                _startViagem().then(((r) =>
                {
                }));
              } else {}
            },
          ),
        ),
      ),
    );
  }

  Future<void> _startViagem() async {
    Viagem viagem = await _authBase.viagemFlux.first;
    Motorista motorista = await _authMotoristaBloc.userInfoFlux.first;
    viagem.Status = StatusViagem.MotoristaACaminho;
    viagem.MotoristaEntity = motorista;
    await _viagemService.save(viagem);
  }
}
