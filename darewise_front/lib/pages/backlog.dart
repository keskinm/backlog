import 'package:flutter/material.dart';
import 'package:darewise_front/dio.dart';
import 'package:dio/dio.dart';

Future<List> getBacklog() async {
  Response response = await dioHttpGet(
    route: 'get_backlog',
    token: false,
  );
  return response.data;
}


class Backlog extends StatelessWidget {
  const Backlog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<List<dynamic>> items = getBacklog();
    const title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: FutureBuilder<List<dynamic>>(
            future: items,
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              Widget body;

              if (snapshot.hasData){


                body = ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final rawEpic = snapshot.data![index];

                    return ListTile(
                      title: Text(rawEpic['name']),
                      subtitle: Text(rawEpic['description'] + ' | status: ' + rawEpic["status"])
                    );
                  },
                );

              }

              else if (snapshot.hasError) {
                body = Text('Error: ${snapshot.error}');
              }

              else {
                body = Text('Awaiting result...');
              }

              return Scaffold(body: body);


            },

          )

      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

