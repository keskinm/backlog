import 'package:flutter/material.dart';
import 'package:front/dio.dart';

void updateBacklog(
    {required String backlog}) async {
  await dioHttpPost(
    route: 'update_backlog',
    jsonData: backlog,
    token: false,
  );
}


class MergeBacklog extends StatefulWidget {
  const MergeBacklog({Key? key}) : super(key: key);

  @override
  _MergeBacklogState createState() {
    return _MergeBacklogState();
  }
}

class _MergeBacklogState extends State<MergeBacklog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merge Backlog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Merge Backlog'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: buildColumn(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Backlog'),
        ),
        ElevatedButton(
          onPressed: () {

            updateBacklog(backlog: _controller.text);

          },
          child: const Text('Merge Backlog'),
        ),
      ],
    );
  }


}