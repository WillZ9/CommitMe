import 'package:flutter/material.dart';
import '/db/DatabaseHelperCommit.dart';

class Journal extends StatefulWidget {
  const Journal({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => JournalState();
}

/// The state for DetailsScreen
class JournalState extends State<Journal> {
  late DatabaseHelper handler;
  late Future<List<TaskModel>> tasks;
  final db = DatabaseHelper();

  @override
  void initState() {
    handler = DatabaseHelper();
    tasks = handler.getAllTasks();

    handler.initTaskDB().whenComplete(() {
      tasks = handler.getAllTasks();
    });
    _refresh();
    super.initState();
  }

  Future<void> _refresh() async {
    setState(() {
      tasks = handler.getAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journals'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: _refresh, child: const Text('Refresh Page', style: TextStyle(color: Colors.white),)),
          Expanded(
            child: FutureBuilder<List<TaskModel>>(
              future: tasks,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TaskModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No data",
                          style: TextStyle(color: Colors.white)));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final items = snapshot.data ?? <TaskModel>[];
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(items[index].journal),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
