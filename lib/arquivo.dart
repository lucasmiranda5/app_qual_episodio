import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class CtrlArquivo {
  List listaSeries = [];

  Future<File> getArquivo() async{
      final diretorio = await getApplicationDocumentsDirectory();
      return File("${diretorio.path}/dados.json");
    }

  Future<File> salvarArquivo() async{
      String data = json.encode(listaSeries);
      final arquivo = await getArquivo();
      return arquivo.writeAsString(data);
  }

  Future<String> lerJson() async {
    try{
      final file = await getArquivo();
      return file.readAsString();
    } catch (e){
      return null;
    }
  }

  
}
