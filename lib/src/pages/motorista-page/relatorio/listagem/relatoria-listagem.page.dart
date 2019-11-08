import 'package:flutter/material.dart';
import 'package:flutter_icons/feather.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gocar/src/entity/entities.dart';
import 'package:gocar/src/pages/motorista-page/relatorio/filtro/relatorio-filtro.page.dart';
import 'package:gocar/src/provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../pages.dart';
import '../../pages.dart';

class RelatorioListagem extends StatefulWidget {
  const RelatorioListagem(this.changeDrawer);

  final ValueChanged<BuildContext> changeDrawer;

  @override
  _RelatorioListagemState createState() => _RelatorioListagemState();
}

class _RelatorioListagemState extends State<RelatorioListagem> {
  RelatorioMotoristaBloc _relatorioBloc;
  RelatorioService _relatorioService;

  @override
  void initState() {
    _relatorioService = RelatorioService();
    _relatorioBloc = RelatorioMotoristaBloc();
    super.initState();
  }


  @override
  void dispose() {
    _relatorioBloc?.dispose();
    super.dispose();
  }

  _load() async {
    /*refresh o fluxo*/
    await _relatorioBloc.loadRelatoriosByMotorista();
  }

  @override
  Widget build(BuildContext context) {
    _load();
    return Scaffold(
        bottomNavigationBar: _buildFooter(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RelatorioCadastroPage(null)));
          },
          child: Icon(Icons.add, color: Colors.black,),
          backgroundColor: Colors.amber,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: StreamBuilder(
                  stream: _relatorioBloc.listRelatorioFlux,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Relatorio>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.amber),
                      ));

                    List<Relatorio> listaViagens = snapshot.data;

                    if (listaViagens.length == 0)
                      return Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Feather.getIconData('search'),
                                    size: 40,
                                  ),
                                ),
                                Container(
                                    child: Text('Sem gastos registrados!',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                              ]));

                    return Padding(
                      padding: const EdgeInsets.only(top: 38),
                      child: ListView.builder(
                          itemCount: listaViagens.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                              child: _itemRelatorio(listaViagens[index]),
                              margin: EdgeInsets.only(top: 25),
                            );
                          }),
                    );
                  }),
            ),
            buttonBar(widget.changeDrawer, context),
            buttonFilterBar()
          ],
        ));
  }

  Widget buttonFilterBar() =>
      Align(
        alignment: Alignment.topRight,
        child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: RawMaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => RelatorioListagemPage()));
              },
              child: new Icon(
                Feather.getIconData('filter'),
                color: Colors.black,
                size: 25.0,
              ),
              shape: new CircleBorder(),
              elevation: 10.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(1.0),
            )),
      );

  _itemRelatorio(Relatorio relatorio) =>
      new Container(
        child: new Container(
          margin: new EdgeInsets.all(10.0),
          constraints: new BoxConstraints.expand(),
          child: new Container(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                          '${DateFormat('dd-MM-yyyy H:mm').format(
                              relatorio.ModificadoEm)}',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontFamily: 'roboto')),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Feather.getIconData('shopping-cart'),
                            size: 16,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Comida : R\$${(relatorio.Comida).toStringAsFixed(
                                2)}',
                            style: TextStyle(
                              fontSize: 16, fontFamily: 'roboto',),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Icon(Feather.getIconData('truck'), size: 16),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                              'Gasolina : R\$${(relatorio.Gasolina)
                                  .toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'roboto'))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Icon(Feather.getIconData('settings'), size: 16),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                              'Manutenção : R\$${(relatorio.ManutencaoCarro)
                                  .toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'roboto'))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Editar',
                  color: Colors.amberAccent.withOpacity(0.8),
                  icon: Feather.getIconData('edit'),
                  onTap: () =>
                      _showSnackBar(AcaoRelatorio.Editar, relatorio.Id),
                ),
                IconSlideAction(
                  caption: 'Remover',
                  color: Colors.redAccent,
                  icon: Feather.getIconData('trash'),
                  onTap: () =>
                      _showSnackBar(AcaoRelatorio.Deletar, relatorio.Id),
                ),
              ],
            ),
          ),
        ),
        height: 170.0,
        decoration: new BoxDecoration(
          color: new Color(0xFFFFFFFF),
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(1.0, 10.0),
            ),
          ],
        ),
      );

  Widget _buildFooter(context) =>
      Container(
        color: Colors.white,
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.amberAccent,
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: MaterialButton(
                    child: Text(
                      "LUCROS : ",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
                    padding:
                    EdgeInsets.only(top: 5, right: 25, left: 15, bottom: 5),
                    child: StreamBuilder(
                        stream: _relatorioBloc.totalRelatorioFlux,
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (!snapshot.hasData)
                            return Text('R\$ 0,0',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.bold));

                          return Text(
                              'R\$  ${(snapshot.data).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'roboto',
                                  fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,);
                        }))),
          ],
        ),
      );

  _showSnackBar(AcaoRelatorio acao, String id) async {
    if (acao == AcaoRelatorio.Deletar) {
      await _relatorioService.deleteById(id);
      await _relatorioBloc.loadRelatoriosByMotorista();
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => RelatorioCadastroPage(id)));
    }
  }
}
