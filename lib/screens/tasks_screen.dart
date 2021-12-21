import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Dismissible(
      key: Key(Provider.of<myTasks>(context).tasks[widget.index]),
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.delete),
            Icon(Icons.delete),
          ],
        ),
      ),
      onDismissed: (direction) async {
        await Provider.of<myTasks>(context, listen: false)
            .removeTask(widget.index);
        final snackBar = SnackBar(content: Text('Item Deleted'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          onChanged: (bool? value) async {
            await Provider.of<myTasks>(context, listen: false)
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
  List<String> boolList = [];
  myTasks() {
    callme();
  }
  Future callme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tasks = prefs.getStringList('tasks') ?? [];
    boolList = prefs.getStringList('boolList') ?? [];
    for (int i = 0; i < boolList.length; i++) {
      if (boolList[i] == 'true') {
        status.add(true);
      } else {
        status.add(false);
      }
    }
    notifyListeners();
  }

  Future addTask(String task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tasks.add(task);
    print(tasks);
    status.add(false);
    boolList.add("false");
    prefs.setStringList('tasks', tasks);
    prefs.setStringList('boolList', boolList);
    notifyListeners();
  }

  Future changeStatus(bool value, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    status[index] = value;
    if (value) {
      boolList[index] = "true";
    } else {
      boolList[index] = "false";
    }
    prefs.setStringList('boolList', boolList);
    notifyListeners();
  }

  Future removeTask(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tasks.removeAt(index);
    status.removeAt(index);
    boolList.removeAt(index);
    prefs.setStringList('tasks', tasks);
    prefs.setStringList('boolList', boolList);
    notifyListeners();
  }
}
