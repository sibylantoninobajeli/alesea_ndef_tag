import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:alesea_ndef_tag/local_data/preferences_helper.dart';
import 'package:alesea_ndef_tag/models/user.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';

import '../globals.dart';


class DatabaseHelperSingleton {
  static final bool needDebug=false;
  static final DatabaseHelperSingleton _instance = DatabaseHelperSingleton.internal();
  bool isWeb = kIsWeb;
  factory DatabaseHelperSingleton() {
    return _instance;
  }

  DatabaseHelperSingleton.internal(){
    final String _methodName="DatabaseHelperSingleton.internal";
    if (needDebug) log(runtimeType.toString()+"::"+_methodName);
  }

  static Database? _db;

  Future<Database?> get db async {
    if (isWeb){
      return null;
    }else {
      if (_db != null)
        return _db;
      _db = await initDb();
      return _db;
    }
  }
  var dbClient;


  initDb() async {
    if (isWeb){
      return null;
    }else {
      final String _methodName = "initDb";
      //io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(await getDatabasesPath(), "main1.db");

      var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
      if (needDebug) log(
          runtimeType.toString() + "::" + _methodName +" Completed");
      return theDb;
    }
  }


  void _onCreate(Database db, int version) async {
    if (isWeb){
      return null;
    }else {
      final String _methodName = "_onCreate";
      // When creating the db, create the table
      await db.execute(
          "CREATE TABLE User(username TEXT, password TEXT, token TEXT)");
      if (needDebug) log(
          runtimeType.toString() + "::" + _methodName +" completed");
    }
  }

  Future<int> saveUser(User user) async {
    if (isWeb){
      String ecnoded=jsonEncode(user.toMap());
      return await setJsonStrUser(ecnoded).then((value){
        return 1;
      });
    }else {
      final String _methodName = "saveUser";
      var dbClient = await db;
      int res = await dbClient!.delete("User");
      res = await dbClient.insert("User", user.toMap());
      if (needDebug) log(
          runtimeType.toString() + "::" + _methodName +" Completed");
      return res;
    }
  }

  Future<int> deleteUsers() async {
    if (isWeb){
      return clearPref().then((value) {return 1;});
    }else {
      final String _methodName = "deleteUsers";
      var dbClient = await db;
      int res = await dbClient!.delete("User");
      if (needDebug) log(
          runtimeType.toString() + "::" + _methodName+ " Completed");
      return res;
    }
  }

  Future<bool> existsUser() async {
    if (isWeb){
      return await getJsonStrUser().then((value){
        if (value!=null)
          return true;
        else
          return false;
      });
    }else {
      final String _methodName = "isLoggedIn";
      var dbClient = await db;
      ((!isRelease) && resetDeviceStoredPrefsUser) ?
      await dbClient!.rawDelete('DELETE FROM User')
          : log(runtimeType.toString() + "::" + _methodName+
          " Non cancello il DB preesistente");
      var res = await dbClient!.query("User");
      bool userFound = res.length > 0 ? true : false;
      if (needDebug) log(
          runtimeType.toString() + "::" + _methodName+ " Completed");
      return userFound;
    }
  }

  Future<User> getUser() async {
    if (isWeb){
      return getJsonStrUser().then((value){
        if(value!=null) {
          final JsonDecoder _decoder = new JsonDecoder();
          User u = User.fromDbMap(_decoder.convert(value));
          return u;
        }else{
          User u= User.empty();
          return u;
        }
      });
    }else {
      final String _methodName = "getUser";
      var dbClient = await db;
      var res = await dbClient!.query("User", limit: 1);
      if (needDebug) log(
          runtimeType.toString() + "::" + _methodName+
          " From DB " + res.first.toString());
      User usr = User.fromDbMap(res.first);
      if (needDebug) log(
          runtimeType.toString() + "::" + _methodName+
          " To User obj " + usr.username);
      return usr;
    }
  }


}