import 'package:flutter/material.dart';
import 'package:darewise_front/pages/backlog.dart';
import 'package:darewise_front/pages/items.dart';

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
                child: const Text('Backlogs'),
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


            ]))



    );
  }
}

