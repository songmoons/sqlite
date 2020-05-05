//هو الكلاس المسؤول عن ربط التطبيق مع الداتا بيز

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite/models/employ_user.dart';

class DatabaseHelper {
  //نعرف البيانات الي داخل الداتا بيز واولها اسم الجدول

  final String tableEmploy = 'employTable';
  final String columnId = 'id';
  final String columnAge = 'age';
  final String columnName = 'name';
  final String columnDepartment = 'department';
  final String columnCity = 'city';
  final String columnDescription = 'description';

  static Database _db;

  //هنا سيتم التاكد من اتصال قاعدة البيانات اذا كان لايساوي "null" يعني في اتصال بيجيب قاعدة البيانات واذا لم يكن هناك اتصال يقوم بعمل اتصال

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await intDb();
    return _db;
  }

  intDb() async {
    //هنا يتم صنع المسار
    String databasePath = await getDatabasesPath();

    //هنا يتم ربط المسار مع اسم قاعدة البيانات
    String path = join(databasePath, 'emloyees.db');

    //هنا يتم فتح الاتصال
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  //========================================  في داله _onCreat يتم انشاء وتكوين الجداول  ===========================================

  void _onCreate(Database db, int newVersion) async {
    var sql = 'CREATE TABLE $tableEmploy($columnId INTEGER PRIMARY KEY,'
        '$columnAge TEXT, $columnName TEXT ,'
        '$columnDepartment TEXT,$columnCity TEXT ,$columnDescription TEXT)';
  }
  //========================================  دالة الحفظ  ===========================================

  //  ليش اخذ قيمه"<int>"" لانه في حاله الحفظ بيرجع قيمتين اما 0 او 1 يعني تم الحفظ او لا
  Future<int> saveEmploy(EmployUser employUser) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableEmploy, employUser.toMap());
    return result;
  }

  //========================================  دالة ارجاع كل اليوزر  ===========================================

  // ليش لست عشان ترجع البيانات على شكل مصفوفه
  Future<List> getAllEmployUser() async {
    // داله فتح الاتصال
    var dbClient = await db;
    // عند احضار كل البيانات احتاج كل الاعمدة عشان اشوف كل البيانات
    var result = await dbClient.query(tableEmploy, columns: [
      columnId,
      columnAge,
      columnName,
      columnDepartment,
      columnCity,
      columnDescription
    ]);
    return result.toList();
  }

  //========================================  دالة ارجاع العدد الكلي لليوزر  ===========================================

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*)FROM $tableEmploy'));
  }

  //========================================  دالة ارجاع يوزر واحد فقط  ===========================================

  //    هذه خاصه بالمستخدم (int id) مثلا نقول له اي يوزر انت تشتيه ؟ لازم يحدد id

  // هذه  <EmployUser> خاصه بالمبرمج اعرف ايش احتاج من return بارجعه للمستخدم

  Future<EmployUser> getUser(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableEmploy,
        columns: [
          columnId,
          columnAge,
          columnName,
          columnDepartment,
          columnCity,
          columnDescription
        ],

        // هنا $columnId = ?' معنى علامه الاستفهام يعني اني مش عارف ايش من  id بيدخله المستخدم باخليه اتوماتيكي
        where: '$columnId = ?',
        whereArgs: ['id']);
    // اذا كان مافيش id نفس الي اعطاني هو المستخدم بيرجع null واذا وجدها بيرجع اول قيمه لقاها بالداتا بيز
    if (result.length > 0) {
      return new EmployUser.fromMap(result.first);
    }
    return null;
  }

  //========================================  دالة التحديث  ===========================================

  Future<int> ubdate(EmployUser employUser) async {
    var dbClient = await db;
    // ليش toMap لانه هي المسؤوله عن قراءة البيانات وادخال البيانات الى المكان المخصص لها وتحتوي على id
    return await dbClient.update(tableEmploy, employUser.toMap(),
        where: '$columnId = ?', whereArgs: [employUser.id]);
  }

  //========================================  دالة الحذف  ===========================================

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        //  هنا بعد اسم الجدول tableEmploy مااحتاج بيانات او اي معلومات عن اليوزر يكفي بس الشرط
        .delete(tableEmploy, where: '$columnId = ?', whereArgs: [id]);
  }

  //========================================  دالة الاغلاق  ===========================================

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
