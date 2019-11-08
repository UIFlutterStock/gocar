import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:gocar/src/pages/motorista-page/pages.dart';
import 'package:gocar/src/provider/blocs/passageiro-bloc/blocs.dart';
import 'package:gocar/src/provider/provider.dart';

import 'infra/admin/admin.dart';
import 'pages/passageiro-page/start-passageiro.page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Bloc<BlocBase>> blocsPassageiro = _blocPassageiro();
    List<Bloc<BlocBase>> blocsMotorista = _blocMotorista();

    return BlocProvider(
      blocs: configAmbiente == Ambiente.Passageiro
          ? blocsPassageiro
          : blocsMotorista,
      child: MaterialApp(
          locale: Locale('pt', 'PT'),
          title: "GoCar App ",
          debugShowCheckedModeBanner: false,
          home: configAmbiente == Ambiente.Passageiro
              ? StartPassageiroPage()
              : StartMotoristaPage(),
          routes: configAmbiente == Ambiente.Passageiro
              ? routesPassageiroConfig
              : routesMotoristaConfig,
          theme: ThemeData(
              fontFamily: "Raleway",
              scaffoldBackgroundColor: Colors.white,
              textTheme: TextTheme(body1: TextStyle(fontSize: 16)))),
    );
  }

  /*provider passageiro*/
  List<Bloc<BlocBase>> _blocPassageiro() {
    final List<Bloc> blocsPassageiro = [
      Bloc((i) => LoadingBloc()),
      Bloc((i) => HomeTabBloc()),
      Bloc((i) => HomePassageiroBloc()),
      Bloc((i) => AuthPassageiroBloc()),
      Bloc((i) => ViagemPassageiroBloc()),
      Bloc((i) => BasePassageiroBloc()),
    ];
    return blocsPassageiro;
  }

/*provider motorista*/
  List<Bloc<BlocBase>> _blocMotorista() {
    final List<Bloc> blocsPassageiro = [
      Bloc((i) => LoadingBloc()),
      Bloc((i) => HomeTabBloc()),
      Bloc((i) => HomeMotoristaBloc()),
      Bloc((i) => AuthMotoristaBloc()),
      Bloc((i) => BaseMotoristaBloc()),
    ];
    return blocsPassageiro;
  }
}
