import 'package:flutter/material.dart';
import 'package:todolist/components/bottom_item.dart';
import 'package:todolist/constants/color_constants.dart';
import 'package:todolist/controllers/database.dart';
import 'package:todolist/models/task_model.dart';
import 'package:todolist/view/addtask_screen.dart';
import 'package:todolist/view/profile_view.dart';
import 'package:todolist/view/todolist_screen.dart';

class Home extends StatefulWidget {
  final PageController mainBottomController;

  const Home({Key key, this.mainBottomController}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  Future<List<Task>> _taskList;
  final pages = [
    TodoListScreen(),
    ProfileView(),
  ];

  final pagesnames = [
    'Takvim',
    'Profil',
  ];

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: _buildBottomTab(),
      floatingActionButton: Transform.scale(
        scale: 1.2,
        child: FloatingActionButton(
            backgroundColor: Colors.blue[700],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                    updateTaskList: _updateTaskList,
                  ),
                ),
              );
            },
            child: Icon(
              Icons.add,
              size: 35,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomAppBar _buildBottomTab() {
    return BottomAppBar(
      color: ColorConstants.instance.primary,
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomItem(
              text: pagesnames[0],
              icon: Icons.calendar_today_rounded,
              isSelected: currentIndex == 0,
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
              },
            ),
            BottomItem(
              text: pagesnames[1],
              icon: Icons.person_outline,
              isSelected: currentIndex == 1,
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
