import 'package:flutter/material.dart';
import 'package:darewise_front/dio.dart';
import 'package:dio/dio.dart';

Future<List> justAGet(
    {required String aString}) async {
  Response response = await dioHttpGet(
    route: 'get_backlog',
    token: false,
  );
  // print(response.data);
  return response.data;
}


class Items extends StatelessWidget {
  const Items({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<List<dynamic>> items = justAGet(aString: '');
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

          print("0");

            return Scaffold(body:
            ListView.builder(
              // Let the ListView know how many items it needs to build.
              itemCount: snapshot.data!.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.

              itemBuilder: (context, index) {
                final rawEpic = snapshot.data![index];
                EpicItem item = EpicItem(rawEpic['name'], rawEpic['description'], rawEpic["status"]);

                return ListTile(
                  title: item.buildTitle(context),
                  subtitle: item.buildSubtitle(context),
                );
              },
              ),
            );

          },

          // ListView.builder(
          //   // Let the ListView know how many items it needs to build.
          //   itemCount: items.length,
          //   // Provide a builder function. This is where the magic happens.
          //   // Convert each item into a widget based on the type of item it is.
          //   itemBuilder: (context, index) {
          //     final item = items[index];
          //
          //     return ListTile(
          //       title: item.buildTitle(context),
          //       subtitle: item.buildSubtitle(context),
          //     );
          //   },
          // ),


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

// /// A ListItem that contains data to display a heading.
// class HeadingItem implements ListItem {
//   final String heading;
//
//   HeadingItem(this.heading);
//
//   @override
//   Widget buildTitle(BuildContext context) {
//     return Text(
//       heading,
//       style: Theme.of(context).textTheme.headline5,
//     );
//   }
//
//   @override
//   Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
// }

/// A ListItem that contains data to display a message.
class EpicItem implements ListItem {
  final String name;
  final String description;
  final String status;
  // final List<String> body;
  // final List<String> body;
  // final List<String> body;
  EpicItem(this.name, this.description, this.status);

  @override
  Widget buildTitle(BuildContext context) => Text(name);

  @override
  Widget buildSubtitle(BuildContext context) => Text(description + ' ' + status);

  @override
  Widget buildStatus(BuildContext context) => Text(status);

}