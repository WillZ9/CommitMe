import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();
  DatabaseHelper._();
  late Database db;
  factory DatabaseHelper() {
    return _databaseHelper;
  }

  String users = """create table users (
        uid TEXT UNIQUE,
        email TEXT UNIQUE, 
        username TEXT,
        password TEXT NOT NULL
        )
  """;

  String tasks = """create table tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        journal TEXT NOT NULL,
        date TEXT
        )
  """;
  //user database management
  Future<Database> initUserDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'commit_user.db');

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
    });
  }

  Future<Database> initTaskDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'commit_task.db');

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(tasks);
    });
  }

  Future<Map<String, Object?>> getUserData(
      String email, String password) async {
    final Database db = await initUserDB();
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE email = ? AND password = ?",
        [email, password]);
  
    return result.first;
  }

  Future<bool> login(User user) async {
    final Database db = await initUserDB();
    var result = await db.rawQuery(
        "select * from users where email = '${user.email}' AND password = '${user.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /*Future<List<String>> getEmailList() async {
    final Database db = await initUserDB();
    List<String> ans = [];
    for (Map<String, Object?> i
        in await db.rawQuery("SELECT * FROM users WHERE email")) {
      ans.add(i.toString());
    }
    return ans;
  }*/

  Future<int> deleteUser(String email) async {
    final Database db = await initUserDB(); 
    return db.delete('users', where: 'id = ?', whereArgs: [email]);
  }

  Future<int> signup(User user) async {
    final Database db = await initUserDB();
    return db.insert('users', user.toMap());
  }

  //Create task
  Future<int> insertTask(TaskModel task) async {
    final Database db = await initTaskDB();
    return db.insert('tasks', task.toMap());
  }

  //Get task
  Future<List<TaskModel>> getAllTasks() async {
    final Database db = await initTaskDB();
    var result = await db.rawQuery('SELECT * FROM tasks');
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  //Delete task 
  Future<int> deleteTask(int id) async {
    final Database db = await initTaskDB(); //SOMETHING VERY WRONG HERE
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  //Update task
  Future<int> updateTask(title, journal, id) async {
    final Database db = await initTaskDB();
    return db.rawUpdate(
        'update tasks set title = ?, journal = ? where id = ?',
        [title, journal, id]);
  }
}

class User {
  String? username;
  String? uid;
  String password;
  String email;

  User(
      {
      this.username,
      this.uid,
      required this.password,
      required this.email});

  factory User.fromMap(Map<String, dynamic> res) {
    return User(
      username: res['username'],
      uid: res['uid'],
      password: res['password'],
      email: res['email'],
    );
  }

  Map<String, Object?> toMap() {
    return {
      'username': username,
      'uid': uid,
      'password': password,
      'email': email,
    };
  }
}

class CurrentUser {
  static final CurrentUser currentUserHelper = CurrentUser._();
  CurrentUser._();
  factory CurrentUser() {
    return currentUserHelper;
  }

  static User currentUser = User(email: '', uid: '', password: '');
  static void updateUser(Map<String, dynamic> res) {
    currentUser = User.fromMap(res);
  }

  String get getpassword => currentUser.password;
  String get getEmail => currentUser.email;
  String get getUid => currentUser.uid!;
  String? get getUsername => currentUser.username;
}

class TaskModel {
  final int? id;
  final String title;
  final String journal;
  final String? date;

  TaskModel({
    this.id,
    required this.title,
    required this.journal,
    this.date,
  });

  factory TaskModel.fromMap(Map<String, dynamic> res) => TaskModel(
        id: res["id"],
        title: res["title"],
        journal: res["journal"],
        date: res["date"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "journal": journal,
        "date": date,
      };
}


