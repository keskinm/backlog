import 'package:flutter/material.dart';
import 'package:front/dio.dart';
import 'package:dio/dio.dart';

Future<List> getBacklog() async {
  Response response = await dioHttpGet(
    route: 'get_backlog',
    token: false,
  );
  return response.data;
}

void addDocument(
    {required String name, required String collectionName, required String epicId}) async {
  String jsonData = '{"collection_name": "$collectionName", "document": {"name": "$name"}, "epic_id": "$epicId"}';
  await dioHttpPost(
    route: 'add_document',
    jsonData: jsonData,
    token: false,
  );
}

void deleteDocument(
    {required String name, required String collectionName}) async {
  String jsonData = '{"collection_name": "$collectionName", "delete_query": {"name": "$name"}}';
  await dioHttpPost(
    route: 'delete_document',
    jsonData: jsonData,
    token: false,
  );
}

class Backlog extends StatefulWidget {
  const Backlog({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _Backlog();
  }
}

class _Backlog extends State<Backlog> {
  @override
  Widget build(BuildContext context) {

    Future<List<dynamic>> items = getBacklog();
    const title = 'Backlog';

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
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final TextEditingController addController = TextEditingController();

                    final rawEpic = snapshot.data![index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(rawEpic['name']),
                        Text(rawEpic['description'] + ' | status: ' + rawEpic["status"]),
                        const Text('Bugs :'),
                        buildDocumentsList(rawEpic, 'bugs'),
                        const Text('Tasks :'),
                        buildDocumentsList(rawEpic, 'tasks'),
                        TextField(
                          controller: addController,
                          decoration: const InputDecoration(hintText: 'Enter Task or Bug Name'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addDocument(name: addController.text, collectionName: 'tasks',
                                epicId: rawEpic["_id"]);
                            setState(() {});
                          },
                          child: const Text('Add task'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addDocument(name: addController.text, collectionName: 'bugs',
                                epicId: rawEpic["_id"]);
                            setState(() {});
                          },
                          child: const Text('Add bug'),
                        )
                      ],
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

  ListView buildDocumentsList(rawEpic, collectionName) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: rawEpic[collectionName].length,
        itemBuilder: (context, bugsIndex) {
          final document = rawEpic[collectionName][bugsIndex];
          String documentName = document['name'];
          return Stack(
            children: [
              Text(documentName + '\n'),
              ElevatedButton(
                onPressed: () {
                  deleteDocument(name: documentName, collectionName: collectionName);
                  setState(() {});
                },
                child: const Text('Delete'),
              )
            ],
          );
        });
  }

}


