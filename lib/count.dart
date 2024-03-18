import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Count extends StatefulWidget {
  const Count({super.key});

  @override
  State<Count> createState() => _CountState();
}

class _CountState extends State<Count> {
  int count = 0;

  @override
  void initState() {
    //initData();
    super.initState();
  }

  void initData() async {
    // set count to database
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await ref.child('test/num').get();
    setState(() {
      count = snapshot.value as int;
    });
    //print(snapshot.value as int);
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Count Page"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    count++;
                  });
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    count--;
                  });
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.numbers),
                onPressed: () {
                  setState(() {
                    count = 0;
                  });
                },
              ),
              Text(
                '$count',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
