import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SendDatatoDB(),
    );
  }
}

class SendDatatoDB extends StatefulWidget {
  @override
  _SendDatatoDB createState() => _SendDatatoDB();
}

class _SendDatatoDB extends State<SendDatatoDB> {
  final TextEditingController _controller = TextEditingController();

  final database_ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://database-practice-5fa22-default-rtdb.firebaseio.com/")
      .ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sending Data To DB"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter Name"),
            ),
            //Retreiving Data From Database
            Expanded(
                child: FirebaseAnimatedList(
              query: database_ref.child('Names'),
              itemBuilder: (context, snapshot, animation, index) => ListTile(
                title: Text(snapshot.child('Name').value.toString()),
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          database_ref
              .child('Names')
              .push()
              .set({'Name': _controller.text.toString()})
              .then((_) {})
              .onError((error, stackTrace) {
                print("Error: $error");
              });
        },
        tooltip: "Add Data To Database",
        child: Icon(Icons.add),
      ),
    );
  }
}
