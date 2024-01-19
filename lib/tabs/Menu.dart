import 'package:commit_me/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:commit_me/themes.dart';
import '/db/DatabaseHelperCommit.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  late DatabaseHelper handler;
  late Future<List<TaskModel>> tasks;
  final db = DatabaseHelper();

  final titleTextEditor = TextEditingController();
  final journalTextEditor = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    tasks = handler.getAllTasks();

    handler.initTaskDB().whenComplete(() {
      tasks = handler.getAllTasks();
    });
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
        title: Text(
          'Menu Page',
          style: normalTextStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateTask()))
              .then((value) {
            if (value) {
              _refresh();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: Column(children: [
        Row(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat.yMMMMd().format(DateTime.now()),
                            style: subTitleStyle),
                      ]),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  LocalNotifications.cancelAll();
                },
                child: const Text(
                  'Stop All Notifications',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<TaskModel>>(
            future: tasks,
            builder: (BuildContext context,
                AsyncSnapshot<List<TaskModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                    child:
                        Text("No data", style: TextStyle(color: Colors.white)));
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                final items = snapshot.data ?? <TaskModel>[];
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index].title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            db.deleteTask(items[index].id!).whenComplete(() {
                              _refresh();
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            titleTextEditor.text = items[index].title;
                            journalTextEditor.text = items[index].journal;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            db
                                                .updateTask(
                                                    titleTextEditor.text,
                                                    journalTextEditor.text,
                                                    items[index].id)
                                                .whenComplete(() {
                                              _refresh();
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text("Update",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ],
                                  title: const Text("Update Task",
                                      style: TextStyle(color: Colors.white)),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          cursorColor: Colors.white,
                                          controller: titleTextEditor,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Title is required";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            label: Text("Title"),
                                          ),
                                        ),
                                        TextFormField(
                                          cursorColor: Colors.white,
                                          controller: journalTextEditor,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Content is required";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            label: Text("Content"),
                                          ),
                                        ),
                                      ]),
                                );
                              });
                        },
                      );
                    });
              }
            },
          ),
        ),
      ]),
    );
  }
}

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final titleTextEditor = TextEditingController();
  final journalTextEditor = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Task",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  db
                      .insertTask(TaskModel(
                    title: titleTextEditor.text,
                    journal: journalTextEditor.text,
                  ))
                      .whenComplete(() {
                    Navigator.of(context).pop(true);
                  });
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 75,
            width: 600,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      LocalNotifications.showPeriodicNotifications(
                        title: titleTextEditor.text,
                        periodic: RepeatInterval.everyMinute,
                        body: journalTextEditor.text,
                        payload: 'This notification is set for EVERY MINUTE',
                      );
                    },
                    child: const Text('Every Minute',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      LocalNotifications.showPeriodicNotifications(
                        title: titleTextEditor.text,
                        periodic: RepeatInterval.daily,
                        body: journalTextEditor.text,
                        payload: 'This notificaion is set for EVERY DAY',
                      );
                    },
                    child: const Text('Daily',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      LocalNotifications.showPeriodicNotifications(
                        title: titleTextEditor.text,
                        periodic: RepeatInterval.weekly,
                        body: journalTextEditor.text,
                        payload: 'This notificaion is set for EVERY WEEK',
                      );
                    },
                    child: const Text('Weekly',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.white,
                      controller: titleTextEditor,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Title is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text(
                          "Title",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: journalTextEditor,
                        maxLines: null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Journal is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text(
                            "Journal",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
