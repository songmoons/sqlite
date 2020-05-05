import 'package:flutter/material.dart';
import 'package:sqlite/models/employ_user.dart';
import 'package:sqlite/connWithDatabase_utils/database_helper.dart';

class EmployScreen extends StatefulWidget {
  // وظيفتهما تبادل البيانات بين الشاشتين
  final EmployUser employUser;
  EmployScreen(this.employUser);

  @override
  _EmployScreenState createState() => _EmployScreenState();
}

class _EmployScreenState extends State<EmployScreen> {
  DatabaseHelper db = new DatabaseHelper();

  //========================================  ربط الواجهه بقاعدة البيانات واسناد متغيرات الداتا بمتغيرات الواجهه ===========================================

  //هنا يتم تعريف الكونترولر لكي تستقبل البيانات من اليوزر
  TextEditingController _ageController;
  TextEditingController _nameController;
  TextEditingController _departmentController;
  TextEditingController _cityController;
  TextEditingController _descriptionController;

  // هنا بيتم اسناد القيم الماخوذه من اليوزر وادخالها لقاعدة البيانات
  @override
  void initState() {
    super.initState();

    // هي القيمه الي تم اضافتها من اليوزر  _ageController     هو المتغير الي بالداتا بيز مستدعى من كلاس اليوزر .employUser.age
    _ageController = new TextEditingController(text: widget.employUser.age);
    _nameController = new TextEditingController(text: widget.employUser.name);
    _departmentController =
        new TextEditingController(text: widget.employUser.department);
    _cityController = new TextEditingController(text: widget.employUser.city);
    _descriptionController =
        new TextEditingController(text: widget.employUser.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EmployeDB'),
      ),

//======================================================== بناء الشاشه الخاصه بالمستخدم  =============================================

      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              Padding(padding: EdgeInsets.all(5)),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              Padding(padding: EdgeInsets.all(5)),
              TextField(
                controller: _departmentController,
                decoration: InputDecoration(labelText: 'department'),
              ),
              Padding(padding: EdgeInsets.all(5)),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'city'),
              ),
              Padding(padding: EdgeInsets.all(5)),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'description'),
              ),
              Padding(padding: EdgeInsets.all(5)),
              //======================================================== بناء البوتون الخاص بالواجهه  =============================================

              RaisedButton(
                  // هنا اذا لم يكن هناك  id وكان فارغ فان العمليه بتكون حفظ
                  // واذا اليوزر اعطانا id  فان العمليه هي تحديث
                  child: (widget.employUser.id != null)
                      ? Text('update')
                      : Text('save'),
                  color: Colors.deepOrangeAccent,

                  //  هنا اذا اليوزر اعطانا id في هذه الحاله كانت العمليه تحديث
                  onPressed: () {
                    if (widget.employUser.id != null) {
                      db
                          .ubdate(EmployUser.fromMap({
                        'id': widget.employUser.id,
                        'age': widget.employUser.age,
                        'name': widget.employUser.name,
                        'department': widget.employUser.department,
                        'city': widget.employUser.city,
                        'description': widget.employUser.description,
                      }))
                          .then((_) {
                        Navigator.pop(context, 'update');
                      });

                      // هنا في حال اذا لم يدخل اليوزر  id   فانه يتم الحفظ
                    } else {
                      db
                          .saveEmploy(EmployUser(
                        _ageController.text,
                        _nameController.text,
                        _departmentController.text,
                        _cityController.text,
                        _descriptionController.text,
                      ))
                          .then((_) {
                        Navigator.pop(context, 'save');
                      });
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }
}
