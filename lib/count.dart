import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Count extends StatefulWidget {
  const Count({super.key});

  @override
  State<Count> createState() => _CountState();
}

class _CountState extends State<Count> {
  int count = 0;
  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    // initialize database
    ref = FirebaseDatabase.instance.ref('test');
    // get snapshot
    DataSnapshot snapshot = await ref.child('num').get();
    // set state
    if (snapshot.exists) {
      setState(() {
        count = snapshot.value as int;
      });
    }
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                incrementCount();
              },
            ),
            FloatingActionButton(
              child: const Icon(Icons.remove),
              onPressed: () {
                decrementCount();
              },
            ),
            FloatingActionButton(
              child: const Icon(Icons.numbers),
              onPressed: () {
                setData(0);
              },
            ),
            Text(
              '$count',
            ),
          ],
        ),
      ),
    );
  }

  void updateData() async {
    await ref.update({
      "num": count,
    });
  }

  void incrementCount() {
    setState(() {
      count++;
    });
    updateData();
  }

  void decrementCount() {
    setState(() {
      count--;
    });
    updateData();
  }

  void setData(key) {
    setState(() {
      count = key;
    });
    updateData();
  }
}
