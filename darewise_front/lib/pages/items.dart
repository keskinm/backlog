import 'package:flutter/material.dart';
import 'package:darewise_front/dio.dart';
import 'package:dio/dio.dart';

Future<List> getItems() async {
  Response response = await dioHttpGet(
    route: 'get_backlog',
    token: false,
  );
  return response.data;
}


class Items extends StatelessWidget {
  const Items({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<List<dynamic>> items = getItems();
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
                  // Let the ListView know how many items it needs to build.
                  itemCount: snapshot.data!.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.

                  itemBuilder: (context, index) {
                    final rawEpic = snapshot.data![index];

                    return ListTile(
                      title: Text(rawEpic['name']),
                      subtitle: ListTile(
                        title: Text(rawEpic['description'] + ' | status: ' + rawEpic["status"]),
                        subtitle: ListTile(
                          title: Text('tasks: ' + rawEpic["tasks"] + '\n'),
                          subtitle: ListTile(
                            title: Text('sub_tasks: ' + rawEpic["sub_tasks"])
                          ),
                        ),
                      ),
                    );

                    // return ListTile(
                    //   title: item.buildTitle(context),
                    //   subtitle: item.buildSubtitle(context),
                    // );
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

