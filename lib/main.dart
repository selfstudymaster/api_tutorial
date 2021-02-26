import 'dart:async';
import 'dart:convert';

import 'package:api_tutorial/connpass_repository.dart';
// import 'package:api_tutorial/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyHomePage());

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connpass API App',
      home: MyApp(title: 'Connpassアプリ'),
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<ConnpassRepository> futureConnpassRepository;

  Future<ConnpassRepository> fetchConnpassRepository() async {
    final response =
        await http.get('https://connpass.com/api/v1/event/?keyword=python');
    print('${jsonDecode(response.body)['events'][0]['title']}');

    if (response.statusCode == 200) {
      return ConnpassRepository.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('失敗');
    }
  }

  @override
  void initState() {
    super.initState();
    futureConnpassRepository = fetchConnpassRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'api of connpass',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: Scaffold(
        appBar: AppBar(
          title: Text('イベント詳細'),
        ),
        body: Center(
          child: FutureBuilder<ConnpassRepository>(
            future: futureConnpassRepository,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.events[0].title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // ${jsonDecode(eventname.data.events)}
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

// Fetch data from the internet
// https://flutter.dev/docs/cookbook/networking/fetch-data
//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// Future<Album> fetchAlbum() async {
//   final response =
//       await http.get('https://connpass.com/api/v1/event/?keyword=python');
//
//   if (response.statusCode == 200) {
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to load album');
//   }
// }
//
// class Album {
//   final String resultsReturned;
//   final int resultsAvailable;
//   final int resultsStart;
//   final List events;
//
//   Album({
//     this.resultsReturned,
//     this.resultsAvailable,
//     this.resultsStart,
//     this.events,
//   });
//
//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       resultsReturned: json['results_returned'],
//       resultsAvailable: json['results_available'],
//       resultsStart: json['results_start'],
//       events: json['events'],
//     );
//   }
// }
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   MyApp({Key key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   Future<Album> futureAlbum;
//
//   @override
//   void initState() {
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch Data Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Fetch Data Example'),
//         ),
//         body: Center(
//           child: FutureBuilder<Album>(
//             future: futureAlbum,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Text(snapshot.data.resultsReturned);
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }
//
//               // By default, show a loading spinner.
//               return CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
