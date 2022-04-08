import 'package:darewise_front/pages/formatted_backlog.dart';
import 'package:darewise_front/pages/backlog.dart';
import 'package:darewise_front/pages/items.dart';
import 'package:darewise_front/pages/merge_backlog.dart';
import 'package:flutter/material.dart';


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
                    MaterialPageRoute(builder: (context) => const Backlogs()),
                  );
                },
              ),

              ElevatedButton(
                child: const Text('Items'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Items()),
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


            ]))



    );
  }
}

