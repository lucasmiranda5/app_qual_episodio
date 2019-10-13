import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qual_episodio/arquivo.dart';
import 'package:qual_episodio/inicio.dart';

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> with CtrlArquivo {
  String acao = 'Adicionar nova série';
  final nomeSerie = TextEditingController();
  final temporada = TextEditingController();
  final episodio = TextEditingController();
  bool assistindo = true;

  Future salvar() async {
    Map<String, dynamic> ob = Map();
    ob['titulo'] = nomeSerie.text;
    ob['episodio'] = episodio.text;
    ob['temporada'] = temporada.text;
    ob['assistindo'] = assistindo;
    listaSeries.add(ob);
    salvarArquivo();
    setState(() {
      episodio.text = '';
      nomeSerie.text = '';
      temporada.text = '';
      assistindo = true;
    });
    final snack = SnackBar(
      content: Text("Série Adicionada com sucesso"),
      duration: Duration(seconds: 3),
    );
    scaffoldKey.currentState.showSnackBar(snack);
    lerJson().then((data) {
        setState(() {
          listaSeries = json.decode(data);
        });
      });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lerJson().then((data) {
      setState(() {
        listaSeries = json.decode(data);
      });
    });
  }

  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var _orderFormKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: (){ 
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Inicio()),
          ); 
          }
        ),
        title: Center(child: Text("Em qual Episódio estou ?")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Center(child: Text('$acao', style: TextStyle(fontSize: 30))),
              Form(
                key: _orderFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      //key: _orderFormKey,
                      focusNode: new FocusNode(),
                      controller: nomeSerie,
                      decoration: InputDecoration(labelText: 'Nome da Série'),
                    ),
                    TextFormField(
                      //key: new GlobalKey(),
                      controller: episodio,
                      decoration: InputDecoration(
                        labelText: 'Episódio',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      //key: new GlobalKey(),
                      controller: temporada,
                      decoration: InputDecoration(
                        labelText: 'Temporada',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              Text('Você está assistindo a série?'),
              Switch(
                value: assistindo,
                onChanged: (bool value) {
                  setState(() {
                    assistindo = !assistindo;
                  });
                },
              ),
              RaisedButton.icon(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());                                
                salvar();
                },
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
    );
  }

  //Abrir Arquivo

}
