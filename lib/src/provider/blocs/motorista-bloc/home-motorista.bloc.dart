import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:rxdart/rxdart.dart';

class HomeMotoristaBloc extends BlocBase {
  final BehaviorSubject<StepPassageiroHome> _stepProcessoController =
  new BehaviorSubject<StepPassageiroHome>();

  Stream<StepPassageiroHome> get stepProcessoFlux =>
      _stepProcessoController.stream;

  Sink<StepPassageiroHome> get stepProcessoEvent =>
      _stepProcessoController.sink;

  final BehaviorSubject<StepMotoristaHome> _stepMotoristaController =
  new BehaviorSubject<StepMotoristaHome>();

  Stream<StepMotoristaHome> get stepMotoristaFlux =>
      _stepMotoristaController.stream;

  Sink<StepMotoristaHome> get stepMotoristaEvent =>
      _stepMotoristaController.sink;

  final BehaviorSubject<String> _timeController = new BehaviorSubject<String>();

  Stream<String> get timeFlux => _timeController.stream;

  Sink<String> get timeEvent => _timeController.sink;

  /*gerenciamento preco/distancia */
  final BehaviorSubject<TipoCarro> _tipoCarroController =
      new BehaviorSubject<TipoCarro>();

  Stream<TipoCarro> get tipocarroFlux => _tipoCarroController.stream;

  Sink<TipoCarro> get tipocarroEvent => _tipoCarroController.sink;

  /*fim viagem*/

  HomeMotoristaBloc() {}

  @override
  void dispose() {
    _tipoCarroController?.close();
    _stepMotoristaController?.close();
    _stepProcessoController?.close();
    _timeController?.close();
    super.dispose();
  }
}
