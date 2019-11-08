import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../provider.dart';
import 'blocs.dart';

class BasePassageiroBloc extends BlocBase {

  /*variaveis observable*/

  /*gerenciamento da viagem*/
  final BehaviorSubject<Viagem> _viagemController =
      new BehaviorSubject<Viagem>();

  Stream<Viagem> get viagemFlux => _viagemController.stream;

  Sink<Viagem> get viagemEvent => _viagemController.sink;

/*fim viagem*/

/*variavel relacionado ao mapaprovider*/
  final BehaviorSubject<ProviderMapa> _providerMapController =
      new BehaviorSubject<ProviderMapa>();

  Observable<ProviderMapa> get providermapFlux => _providerMapController.stream;

  Sink<ProviderMapa> get providermapEvent => _providerMapController.sink;

/*fim provider mapa*/

  BasePassageiroBloc() {}

  /*classe central , responsavel por concentrar inteligencia das ações tomadas*/
  Future<void> orchestration() async {
    HomePassageiroBloc _homePassageiroBloc =
    BlocProvider.getBloc<HomePassageiroBloc>();
    StepPassageiroHome _stepHome =
    await _homePassageiroBloc.stepProcessoFlux.first;
    StepPassagieroInicioBiz _stepPassageiroInicioBiz =
    StepPassagieroInicioBiz();
    StepConfirmaCorridaBiz _stepConfirmaCorridaBiz = StepConfirmaCorridaBiz();
    StepPassageiroProcurarMotorista _stepPassageiroProcurarMotorista =
    StepPassageiroProcurarMotorista();

    /*garante que não irá existir fluxo ativo enquando for inicial processo*/
    encerrarFluxosStream();


    switch (_stepHome) {
      case StepPassageiroHome.Inicio:
        _stepPassageiroInicioBiz.start();
        break;
      case StepPassageiroHome.ConfirmaValor:
        _stepConfirmaCorridaBiz.start();
        break;
      case StepPassageiroHome.ProcurandoMotorista:
        _stepPassageiroProcurarMotorista.start();
        break;
      default:
        throw new Exception('Chamada de ação que não deveria existir.');
        break;
    }
  }

  void encerrarFluxosStream() {
    StepPassagieroInicioBiz _stepPassageiroInicioBiz =
    StepPassagieroInicioBiz();
    StepPassageiroProcurarMotorista _stepPassageiroProcurarMotorista =
    StepPassageiroProcurarMotorista();

    /*garante que não irá existir fluxo ativo enquando for inicial processo*/
    _stepPassageiroInicioBiz.encerrarFluxosStream();
    _stepPassageiroProcurarMotorista.encerrarFluxosStream();
    //stepMotoristaProcurarViagem.encerrarFluxosStream();
    //stepMotoristaViagemIniciada.encerrarFluxosStream();
  }

  /*cancelamento corrida segundo nivel*/
  Future cancelarCorrida() async {
    ViagemService _viagemService = ViagemService();
    Viagem viagem = await viagemFlux.first;
    viagem.Status = StatusViagem.Cancelada;
    /*mata o stream do firebase se tiver aberta e outros*/
    encerrarFluxosStream();
    await _viagemService.save(viagem);
  }

  /*fim cancelamento corrida*/

  /*adiciona ponto ao provider map  */
  refreshProvider(LatLng localizacao, String Endereco,
      ReferenciaLocal referenciaLocal) async {
    ProviderMapa provider = await providermapFlux.first;
    provider.Markers = Set<Marker>();
    if (referenciaLocal != ReferenciaLocal.Destino) {
      provider.LatLngOrigemPoint = localizacao;
      provider.EnderecoOrigem = Endereco;
    } else {
      provider.EnderecoDestino = Endereco;
      provider.LatLngDestinoPoint = localizacao;
    }
    providermapEvent.add(provider);
  }

  /* end provider  */

  @override
  void dispose() {
    _viagemController?.close();
    _providerMapController?.close();
    super.dispose();
  }
}
