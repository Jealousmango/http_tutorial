import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> _getUsers() async {
//  Collect JSON data from http request and store into data variable
    var data = await http.get("https://pokeapi.co/api/v2/pokemon/");

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for(var u in jsonData["results"]) {
      User user = User(u["url"], u["name"]);
//      print(user);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(

        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getUsers(),
//            snapshot collects data once returned from _getUsers()
            builder:  (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.data == null) {
                return Container(
                  child:  Center(
                    child: Text("Loading..."),
                  )
                );
              } else {
                return ListView.builder(
                  itemCount:  snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                      ),
                      title: Text(snapshot.data[index].name),
                      onTap: () {
                        Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                        );
                      },
                    );
                  },
                );
              }
            }
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;


  DetailPage(this.user);
//  var pokedata = http.get("https://pokeapi.co/api/v2/pokemon/");
//
//  var jsonData = json.decode(pokedata.body);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Card(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.pregnant_woman),
                title: new Text(
                    user.name
                ),
                subtitle: new Text(user.url),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class User {
//  final int index;
//  final String about;
  final String url;
  final String name;
//  Possibly add further attributes for User/Pokemon objects, appending additional details to objects once loaded into DetailPage
//  final String email;
//  final String picture;

  User(this.url,this.name);
}
