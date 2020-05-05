import 'package:flutter/material.dart';
import 'package:sqlite/models/employ_user.dart';
import 'package:sqlite/connWithDatabase_utils/database_helper.dart';
import 'package:sqlite/userInterface_ui/employee_screen.dart';

class ListViewEploye extends StatefulWidget {
  @override
  _ListViewEployeState createState() => _ListViewEployeState();
}

class _ListViewEployeState extends State<ListViewEploye> {
  //========================================  كود ربط الداتا بيز مع الواجهه  ===========================================
// اعرف متغير للست الي بضيف له البيانات
  List<EmployUser> items = new List();

  // اعرف متغير للكلاس الي فيه عمليات الداتا بيز عشان اقدر اوصل لها
  DatabaseHelper db = new DatabaseHelper();

// احتاج لداله initState لان البيانات متغيرة وكل شويه بيتم اضافه بيانات جديدة
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  emloyees هنا جيب كل البيانات وضعها داخل المتغير
    db.getAllEmployUser().then((emloyees) {
      // هنا وظيفه forEach  انها تقوم تملي بيانات لداخل الداتا بيز
      setState(() {
        emloyees.forEach((emloyees) {
          items.add(EmployUser.fromMap(emloyees));
        });
      });
    });
  }

  //=================================================================================================================================
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All UserEmpoye',
      home: Scaffold(
        appBar: AppBar(
          title: Text("UserEmpoye"),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, postion) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 5,
                    ),
                    ListTile(
//==========================================================اسناد القيم للمتغيرات=======================================================================

                      title: Text(
                        '${items[postion].name}',
                        style:
                            TextStyle(fontSize: 22.0, color: Colors.redAccent),
                      ),

                      subtitle: Text(
                        '${items[postion].age}-  ${items[postion].city}- ${items[postion].department}-',
                        style: TextStyle(
                            fontSize: 22.0, fontStyle: FontStyle.italic),
                      ),

                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(20)),
                          CircleAvatar(
                            backgroundColor: Colors.amber,
                            radius: 18,
                            child: Text(
                              '${items[postion].id}',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                          ),
//============================================================== استدعاء دالة الحذف في الواجهه===================================================================
                          IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.redAccent,
                              // استدعاء داله الحذف
                              onPressed: () => _deleteEmploy(

                                  // في داله عمليه الحذف احتاج المحتوى مع الموقع العنصر المراد حذفه
                                  context,
                                  items[postion],
                                  postion))

                          //============================================================استدعاء دالة التحديث في الواجهه=====================================================================
                        ],
                      ),
                      // استدعاء داله الاضافه
                      onTap: () => _navigateEmploye

                          // في داله عمليه الاضافه احتاج المحتوى مع موقع العنصر المراد اضافته
                          (context, items[postion]),
                    )
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.redAccent,
            onPressed: () => _createEmployr(context)),
      ),
    );
  }
//=============================================================دالة الحذف في الواجهه====================================================================

  _deleteEmploy(
      // داله الحذف تحتاج الى المحتوى  و   معلومات الموظف   و الموقع
      BuildContext context,
      EmployUser employUser,
      int postion) async {
    //emloyees ونعرضها بالمتغير الي با اللست (employUser) نجلب البيانات  الي بداخل  الداتا
    db.delete(employUser.id).then((emloyees) {
      setState(() {
        items.removeAt(postion);
      });
    });
  }

  //==============================================================دالة التحديث في الواجهه===================================================================

// تحتاج الى قيمتين الاولى المحتوى والثانيه بيانات المستخدم
  void _navigateEmploye(BuildContext context, EmployUser employUser) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployScreen(employUser)),
    );
    if (result == 'update') {
      // emloyees هنا نقوم بجلب البيانات كامله لداخل المصفوفه عن طريق المتغير
      db.getAllEmployUser().then((emloyees) {
        setState(() {
          // هنا يعني امسح البيانات القديمه
          items.clear();

          // الدوارة forEach  بتعبي البيانات الجديدة
          emloyees.forEach((employUser) {
            items.add(EmployUser.fromMap(employUser));
          });
        });
      });
    }
  }

  //==================================================================دالة انشاء يوزر جديد في الواجهه===============================================================
  void _createEmployr(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmployScreen(EmployUser('', '', '', '', ''))),
    );
    if (result == 'save') {
      // emloyees هنا نقوم بجلب البيانات كامله لداخل المصفوفه عن طريق المتغير
      db.getAllEmployUser().then((emloyees) {
        setState(() {
          // هنا يعني امسح البيانات القديمه
          items.clear();

          // الدوارة forEach  بتعبي البيانات الجديدة
          emloyees.forEach((employUser) {
            items.add(EmployUser.fromMap(employUser));
          });
        });
      });
    }
  }
}
