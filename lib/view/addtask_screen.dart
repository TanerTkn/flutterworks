import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/controllers/database.dart';
import 'package:todolist/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Function updateTaskList;
  final Task task;

  AddTaskScreen({this.task, this.updateTaskList});
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  String _title = "";
  String _priority;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");
  final List<String> _priorities = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _title = widget.task.title;
      _date = widget.task.date;
      _priority = widget.task.priority;
    }

    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  _submit() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      Task task = Task(title: _title, date: _date, priority: _priority);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF10455B),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color(0xFFFFAF20),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  widget.task == null ? "Yapılacak Ekle" : "Yapılacak Güncelle",
                  style: TextStyle(color: Color(0xFFFFAF20), fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFF9F3ED),
                          ),
                          decoration: InputDecoration(
                            // fillColor: Color(0xFFFFAF20),
                            labelText: "Başlık",
                            labelStyle: TextStyle(
                              color: Color(0xFFFFAF20),
                              fontSize: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFAF20),
                              ),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty ? "Lütfen yapılacak başlığı giriniz" : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFF9F3ED),
                          ),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                            labelText: "Tarih",
                            labelStyle: TextStyle(
                              color: Color(0xFFFFAF20),
                              fontSize: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFAF20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: DropdownButtonFormField(
                          dropdownColor: Color(0xFF10455B),
                          isDense: true,
                          items: _priorities.map((String priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(
                                  color: Color(0xFFF9F3ED),
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }).toList(),
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22,
                          iconEnabledColor: Color(0xFFFFAF20),
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF10455B),
                          ),
                          decoration: InputDecoration(
                            labelText: "Öncelik",
                            labelStyle: TextStyle(
                              color: Color(0xFFFFAF20),
                              fontSize: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFAF20),
                              ),
                            ),
                          ),
                          validator: (input) => _priority == null ? "Lütfen öncelik seçiniz" : null,
                          onChanged: (value) {
                            setState(() {
                              _priority = value;
                            });
                          },
                          value: _priority,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFAF20),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: FlatButton(
                          child: Text(
                            widget.task == null ? "Ekle" : "Güncelle",
                            style: TextStyle(
                              color: Color(0xFF10455B),
                              fontSize: 20,
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.task != null
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFAF20),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: FlatButton(
                                child: Text(
                                  "Sil",
                                  style: TextStyle(
                                    color: Color(0xFF10455B),
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: _delete,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
