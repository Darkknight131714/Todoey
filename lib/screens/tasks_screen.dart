import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final GlobalKey taskListKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.list,
                      size: 30,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "TODOEY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "${Provider.of<myTasks>(context).tasks.length} tasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TasksList(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddTaskScreen(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TasksList extends StatefulWidget {
  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<myTasks>(context).tasks.length == 0) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            "NO Tasks CURRENTLY🥳🥳",
            style: TextStyle(color: Colors.lightBlueAccent, fontSize: 28),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: Provider.of<myTasks>(context).tasks.length,
      itemBuilder: (context, index) {
        return TaskTile(
          index: index,
        );
      },
    );
  }
}

class TaskTile extends StatefulWidget {
  int index;
  TaskTile({required this.index});
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Provider.of<myTasks>(context, listen: false).removeTask(widget.index);
      },
      child: ListTile(
        title: Text(
          Provider.of<myTasks>(context).tasks[widget.index],
          style: TextStyle(
              decoration: Provider.of<myTasks>(context).status[widget.index]
                  ? TextDecoration.lineThrough
                  : null),
        ),
        trailing: Checkbox(
          activeColor: Colors.lightBlueAccent,
          value: Provider.of<myTasks>(context).status[widget.index],
          onChanged: (bool? value) {
            Provider.of<myTasks>(context, listen: false)
                .changeStatus(value!, widget.index);
          },
        ),
      ),
    );
  }
}

class myTasks extends ChangeNotifier {
  List<String> tasks = [];
  List<bool> status = [];

  void addTask(String task) {
    tasks.add(task);
    status.add(false);
    notifyListeners();
  }

  void changeStatus(bool value, int index) {
    status[index] = value;
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    status.removeAt(index);
    notifyListeners();
  }
}
