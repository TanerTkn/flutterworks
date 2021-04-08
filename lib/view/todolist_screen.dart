import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/constants/color_constants.dart';
import 'package:todolist/controllers/database.dart';
import 'package:todolist/models/task_model.dart';
import 'package:todolist/view/addtask_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  int seciliIndex = 0;
  Future<List<Task>> _taskList;

  @override
  void initState() {
    super.initState();
    _updateTaskList();
    _controller = CalendarController();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  CalendarController _controller;
  DateTime _selectedDay = DateTime.now();
  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(
      color: Color(0xFFF9F3ED),
      fontWeight: fontWeight,
    );
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              "${task.priority}",
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                task.status = value ? 1 : 0;
                DatabaseHelper.instance.updateTask(task);
                _updateTaskList();
              },
              activeColor: Theme.of(context).primaryColor,
              value: task.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(
                  updateTaskList: _updateTaskList,
                  task: task,
                ),
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.instance.primary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: 'tr_TR',
              onDaySelected: (day, events, holidays) {
                setState(() {
                  _selectedDay = day;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekdayStyle: dayStyle(FontWeight.normal),
                weekendStyle: dayStyle(FontWeight.normal),
                selectedColor: Color(0xFFFF9800),
                todayColor: ColorConstants.instance.orangePeel,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: ColorConstants.instance.orangePeel,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                weekendStyle: TextStyle(
                  color: ColorConstants.instance.orangePeel,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: ColorConstants.instance.orangePeel,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Color(0xFFF9F3ED),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Color(0xFFF9F3ED),
                ),
              ),
              calendarController: _controller,
              
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                color: ColorConstants.instance.orangePeel,
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                        height: 4,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorConstants.instance.primary,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yMMMMd', 'tr').format(_selectedDay),
                          style: TextStyle(color: ColorConstants.instance.primary, fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: FutureBuilder(
                      future: _taskList,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final int completedTaskCount = snapshot.data.where((Task task) => task.status == 1).toList().length;

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          itemCount: 1 + snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Yapılacaklar",
                                      style: TextStyle(
                                        color: ColorConstants.instance.primary,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "$completedTaskCount of ${snapshot.data.length}",
                                      style: TextStyle(
                                        color: ColorConstants.instance.primary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return _buildTask(snapshot.data[index - 1]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
