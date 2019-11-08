import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:gocar/src/provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../pages.dart';
import '2-confirmar-corrida/confirmar-corrida.widget.dart';
import 'widget.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.changeDrawer);

  final ValueChanged<BuildContext> changeDrawer;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeMotoristaBloc _homeBloc;
  BaseMotoristaBloc _baseBloc;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Completer<GoogleMapController> _controller;


  @override
  void initState() {
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _controller = Completer();
    _baseBloc = BlocProvider.getBloc<BaseMotoristaBloc>();
    _homeBloc = BlocProvider.getBloc<HomeMotoristaBloc>();
    _homeBloc.stepMotoristaEvent.add(StepMotoristaHome.Inicio);
    _baseBloc.orchestration();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: StreamBuilder(
            stream: _homeBloc.stepMotoristaFlux,
            builder: (BuildContext context,
                AsyncSnapshot<StepMotoristaHome> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
                ));
              }

              StepMotoristaHome step = snapshot.data;
              var widgetsHome = _configHome(step);
              return Stack(
                children: widgetsHome,
              );
            }));
  }

  /*constroi a tela de acordo com a etapa atual do processo*/
  List<Widget> _configHome(StepMotoristaHome stepHome) {
    var widgetsHome = <Widget>[];
    widgetsHome = <Widget>[_buildGoogleMap()];

    switch (stepHome) {
      case StepMotoristaHome.Inicio:
        widgetsHome.add(buttonBar(widget.changeDrawer, context));
        widgetsHome.add(SwitchAtivarBuscaCorrida(false, _scaffoldKey));
        return widgetsHome;
        break;
      case StepMotoristaHome.Procurandoviagem:
        widgetsHome.add(buttonBar(widget.changeDrawer, context));
        widgetsHome.add(InputProcurandoCorrida());
        widgetsHome.add(RadarWidget());
        widgetsHome.add(SwitchAtivarBuscaCorrida(true, _scaffoldKey));
        return widgetsHome;
        break;
      case StepMotoristaHome.Viagemencontrada:
        widgetsHome.add(ConfirmarCorridaWidget());
        return widgetsHome;
        break;
      case StepMotoristaHome.Viagemaceita:
        widgetsHome.add(IniciarCorridaWidget(_scaffoldKey));
        return widgetsHome;
        break;
      case StepMotoristaHome.Fimviagem:
        widgetsHome.add(EncerrarCorridaWidget(_scaffoldKey));
        return widgetsHome;
        break;
      default:
        return widgetsHome;
        break;
    }
  }

  Future _resizeZoom(ProviderMapa provider) async {
    var next = await _homeBloc.stepMotoristaFlux.first;

    if (next == StepMotoristaHome.Inicio)
      await Future.delayed(const Duration(milliseconds: 1500), () {
        _gotoLocation(provider.LatLngPosicaoMotoristaPoint.latitude,
            provider.LatLngPosicaoMotoristaPoint.longitude, 18, 0, 0);
      });
    else if (next == StepMotoristaHome.Procurandoviagem) {
      await Future.delayed(const Duration(milliseconds: 1500), () {
        _gotoLocation(provider.LatLngPosicaoMotoristaPoint.latitude,
            provider.LatLngPosicaoMotoristaPoint.longitude, 14, 0, 0);
      });
    } else if (next == StepMotoristaHome.Viagemencontrada) {
      await Future.delayed(const Duration(milliseconds: 1500), () {
        _gotoLocation(provider.LatLngPosicaoMotoristaPoint.latitude,
            provider.LatLngPosicaoMotoristaPoint.longitude, 17, 0, 0);
      });
    } else if (next == StepMotoristaHome.Viagemaceita) {
      await Future.delayed(const Duration(milliseconds: 1500), () {
        _gotoLocation(provider.LatLngPosicaoMotoristaPoint.latitude,
            provider.LatLngPosicaoMotoristaPoint.longitude, 18, 0, 0);
      });
    } else if (next == StepMotoristaHome.Fimviagem) {
      await Future.delayed(const Duration(milliseconds: 1500), () {
        _gotoLocation(provider.LatLngPosicaoMotoristaPoint.latitude,
            provider.LatLngPosicaoMotoristaPoint.longitude, 16, 0, 0);
      });
    }

    return false;
  }

  Widget _buildGoogleMap() {
    return StreamBuilder(
        stream: _baseBloc.providermapFlux,
        builder: (BuildContext context, AsyncSnapshot<ProviderMapa> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
            ));
          }

          ProviderMapa provider = snapshot.data;

          /*reposiziona com zoom*/
          _resizeZoom(provider);

          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              circles: provider.CircleMapa,
              initialCameraPosition: CameraPosition(
                  target: provider.LatLngPosicaoMotoristaPoint, zoom: 16),
              //onMapCreated: appState.onCreated,
              myLocationEnabled: false,
              mapType: MapType.normal,
              compassEnabled: true,
              markers: provider.Markers,
              // onCameraMove: appState.onCameraMove,
              polylines: provider.Polylines,
            ),
          );
        });
  }

  Future<void> _gotoLocation(
      double lat, double long, double zoom, double tilt, double bearing) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: zoom,
      tilt: tilt,
      bearing: bearing,
    )));
  }
}
