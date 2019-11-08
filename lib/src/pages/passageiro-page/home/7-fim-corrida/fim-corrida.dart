import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:gocar/src/provider/blocs/blocs.dart';
import 'package:gocar/src/provider/provider.dart';

import '../../../pages.dart';

class CorridaFinalizadaWidget extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  CorridaFinalizadaWidget(this.scaffoldKey);

  HomePassageiroBloc _homeBloc = BlocProvider.getBloc<HomePassageiroBloc>();
  BasePassageiroBloc _baseBloc = BlocProvider.getBloc<BasePassageiroBloc>();


  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), () async {

      ShowSnackBar.build(
          scaffoldKey, 'Viagem realizada com sucesso !', context);

      _homeBloc.stepProcessoEvent.add(StepPassageiroHome.Inicio);
      await _baseBloc.orchestration();
    });

    return Container(height: 1, width: 1);
  }
}
