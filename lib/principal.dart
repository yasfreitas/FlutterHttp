import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Principal extends StatefulWidget {
  Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<dynamic> _data = [];

  @override
  void _carregarDados() async{
    setState(() {
      _buscarDados();
    });
  }
  Future<void> _buscarDados() async{
    try{
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200){
        setState(() {
          _data = jsonDecode(response.body);
        });
        print("GET ok HTTP CRUD com FLUTTER");
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error){
      print(error);
    }
  }
  Future<void> _criarDados() async {
    try {
      final response = await http.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'title': 'FLUTTER HTTP CRUD',
            'body': 'Inserindo dados com HTTP CRUD no FLUTTER',
            'userId': 1,
          }));
      if (response.statusCode == 201) {
        _buscarDados();
        print("POST ok HTTP CRUD com Flutter");
      } else {
        throw Exception('Failed to create data');
      }
    } catch (error){
      print(error);
    }
    }
    Future<void> _alterarDados(int id) async{
    try{
      final response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'title': 'FLUTTER HTTP CRUD',
            'body': 'Inserindo dados com HTTP CRUD no FLUTTER',
            'userId': 1,
          }));
      if (response.statusCode == 200) {
        _buscarDados();
        print("Update ok HTTP CRUD com Flutter");
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error){
      print(error);
    }
    }
    Future<void> _deletarDados(int id) async{
    try{
      final response = await http
          .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

      if (response.statusCode == 200) {
        print("DELETE ok HTTP CRUD com Flutter");
        _buscarDados();
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error){
      print(error);
    }
    }

    @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("CONSUMIR API COM HTTP"),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _data[index];
          return ListTile(
            title: Text(data['title'],
            style: TextStyle(
              color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          subtitle: Text(
            data['body'],
            style: TextStyle(fontSize: 10),
          ),
          trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _alterarDados(data['id']),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deletarDados(data['id']),
          ),
          ],
          ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _criarDados,
        tooltip: 'Create',
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
        elevation: 5,
      ),
    );
    }

  }
