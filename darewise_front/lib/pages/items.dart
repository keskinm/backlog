import 'package:flutter/material.dart';
import 'package:darewise_front/dio.dart';
import 'package:dio/dio.dart';


Future<String> justAPost(
    {required String aString}) async {
  String body = '{"aString": "$aString"}';
  Response response = await dioHttpPost(
    route: 'get_stuff',
    jsonData: body,
    token: false,
  );
  print(response.data);
  return response.data['answer'];
}




// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: _title,
//       home: Items(),
//     );
//   }
// }

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  // final Future<String> _calculation = Future<String>.delayed(
  //   const Duration(seconds: 2),
  //       () => 'Data Loaded',
  // );

  final Future<String> _calculation = justAPost(aString: "foo");

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [

              DefaultTextStyle(
                style: Theme.of(context).textTheme.headline2!,
                textAlign: TextAlign.center,
                child: FutureBuilder<String>(
                  future: _calculation, // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Result: ${snapshot.data}'),
                        )
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        )
                      ];
                    } else {
                      children = const <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Awaiting result...'),
                        )
                      ];
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    );
                  },
                ),
              ),



              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),

            ],
          )

      ),

    );
  }
}
