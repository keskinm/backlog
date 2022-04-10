import 'package:flutter/material.dart';
import 'package:front/dio.dart';
import 'package:dio/dio.dart';


Future<String> getFormattedBacklog() async {
  Response response = await dioHttpGet(
    route: 'get_formatted_backlog',
    token: false,
  );
  return response.data;
}


class FormattedBacklog extends StatefulWidget {
  const FormattedBacklog({Key? key}) : super(key: key);

  @override
  State<FormattedBacklog> createState() => _FormattedBacklogState();
}

class _FormattedBacklogState extends State<FormattedBacklog> {
  final Future<String> formattedBacklog = getFormattedBacklog();

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
                  future: formattedBacklog, // a previously-obtained Future<String> or null
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
