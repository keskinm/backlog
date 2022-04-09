import 'package:darewise_front/pages/bugs_epics.dart';
import 'package:darewise_front/pages/epics_bugs.dart';
import 'package:darewise_front/pages/formatted_backlog.dart';
import 'package:darewise_front/pages/backlog.dart';
import 'package:darewise_front/pages/merge_backlog.dart';
import 'package:flutter/material.dart';

import 'dio.dart';


void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),


      body: Container(
        alignment: Alignment.center,
        child: Column(
            children: [

              ElevatedButton(
                child: const Text('Backlog'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Backlog()),
                  );
                },
              ),

              ElevatedButton(
                child: const Text('Export'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormattedBacklog()),
                  );
                },
              ),

              ElevatedButton(
                child: const Text('Merge Backlog'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MergeBacklog()),
                  );
                },
              ),

              ElevatedButton(
                child: const Text('Blocked epics by bugs'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BugsEpics()),
                  );
                },
              ),

              ElevatedButton(
                child: const Text('Epics bugs'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EpicsBugs()),
                  );
                },
              ),

              ElevatedButton(
                child: const Text('Re-initialize database'),
                onPressed: () async {
                  await dioHttpGet(
                      route: 'reinitialize_database',
                      token: false,
                  );
                },
              ),


            ]))



    );
  }
}

