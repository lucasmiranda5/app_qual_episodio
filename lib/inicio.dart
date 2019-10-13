import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qual_episodio/arquivo.dart';
import 'package:qual_episodio/formulario.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> with CtrlArquivo {

  final nomeSerie = TextEditingController();
  final temporada = TextEditingController();
  final episodio = TextEditingController();
  bool assistindo = true;
  int indexEditar;

  @override
  void initState() {
    super.initState();

    setState(() {
      lerJson().then((data) {
        setState(() {
          listaSeries = json.decode(data);
        });
      });
    });

    
  }

  Future excluir(int index) async {
    listaSeries.removeAt(index);
    salvarArquivo();
    setState(() {
      lerJson().then((data) {
        setState(() {
          listaSeries = json.decode(data);
        });
      });
    });
  }

  Future salvar() async {
    listaSeries[indexEditar]['titulo'] = nomeSerie.text;
    listaSeries[indexEditar]['episodio'] = episodio.text;
    listaSeries[indexEditar]['temporada'] = temporada.text;
    listaSeries[indexEditar]['assistindo'] = assistindo;
    salvarArquivo();
    final snack = SnackBar(
      content: Text("Série Editada com sucesso"),
      duration: Duration(seconds: 2),
    );
    setState(() {
      lerJson().then((data) {
        setState(() {
          listaSeries = json.decode(data);
        });
      });
    });
    Navigator.pop(context);
    scaffoldKey.currentState.showSnackBar(snack);
    //Scaffold.of(context).showSnackBar(snack);
  }
  Future editar(int index) async {
    AlertDialog alert;
    indexEditar = index;
    setState(() {
      nomeSerie.text = listaSeries[index]['titulo'];
      episodio.text = listaSeries[index]['episodio'];
      temporada.text = listaSeries[index]['temporada'];
      assistindo = listaSeries[index]['assistindo'];

    });
    alert = AlertDialog(
      title: Text("Editar ${listaSeries[index]['titulo']}"),
      content: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            
          Form(
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
                  Icons.save,
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
      )
      );
    
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }

  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var _orderFormKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(child: Text("Em qual Episódio estou ?")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Formulario()),
          ); 
        },
        tooltip: "Adicionar uma nova série",
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: listaSeries.length,
                itemBuilder: buildItem),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('Desenvolvido por Lucas Miranda'),
              
            ],
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Card(
        color: listaSeries[index]['assistindo'] ? Colors.white : Colors.green,
        child: Column(
      children: <Widget>[
        ListTile(
            title: Text(listaSeries[index]['titulo']),
            subtitle: Text(
                "Temporada: ${listaSeries[index]['temporada']} | Episódio: ${listaSeries[index]['episodio']}")),
        ButtonTheme.bar(
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () => { editar(index)},
                child: Text('Editar'),
              ),
              FlatButton(
                onPressed: () => { excluir(index) },
                child: Text('Excluir'),
              )
            ],
          ),
        )
      ],
    ));
  }
} 
