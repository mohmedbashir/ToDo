import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:todo/views/theme.dart';
import 'package:todo/views/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/task_controller.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/views/pages/add_task_page.dart';
import 'package:todo/views/widgets/custom_button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final String _dateTime = DateFormat.yMMMMd().format(DateTime.now());
final TaskController _taskController = Get.put(TaskController());
DateTime _selectedDate = DateTime.now();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            _addTaskBar(),
            const SizedBox(height: 10),
            _dateBar(),
            const SizedBox(height: 10),
            _body(),
          ],
        ),
      ),
    );
  }

  AppBar _customAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 26,
          ),
          onPressed: () => ThemeServices().switchTheme()),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 22,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/person.jpeg'),
              radius: 21,
            ),
          ),
        ),
      ],
    );
  }

  Widget _addTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dateTime,
              style: headingStyle4,
            ),
            Text('Today', style: headingStyle3)
          ],
        ),
        CustomButton(
            label: 'Add Task',
            onTap: (() async {
              await Get.to(() => AddTaskPage(selectedDate: _selectedDate));
              _taskController.getTasks();
            }))
      ],
    );
  }

  Widget _dateBar() {
    return DatePicker(
      DateTime.now(),
      width: 65,
      height: 100,
      initialSelectedDate: DateTime.now(),
      monthTextStyle: headingStyle6,
      dayTextStyle: headingStyle6,
      dateTextStyle: headingStyle3,
      selectionColor: primaryClr,
      onDateChange: (selectedDate) {
        setState(() {
          _selectedDate = selectedDate;
        });
      },
    );
  }

  Widget _body() {
    return Expanded(
      child: Obx(() {
        if (_taskController.tasksList.isEmpty) {
          return _noTasksListMsg();
        }
        return _tasksListList();
      }),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(
        const Duration(seconds: 1), () => _taskController.getTasks());
  }

  Widget _noTasksListMsg() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizeConfig.orientation == Orientation.landscape
                ? const SizedBox(height: 0)
                : const SizedBox(height: 120),
            SvgPicture.asset(
              'images/task.svg',
              color: primaryClr.withOpacity(.6),
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 10),
            Text(
              'You don\'t have any task today',
              style: headingStyle4,
            ),
            Text(
              'add some tasks to make your days productive.',
              style: headingStyle6,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ]),
    );
  }

  Widget _tasksListList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final task = _taskController.tasksList[index];
        if (task.repeat == 'Daily' ||
            task.date == DateFormat.yMd().format(_selectedDate) ||
            (task.repeat == 'Weekly' &&
                _selectedDate
                            .difference(DateFormat.yMd().parse(task.date!))
                            .inDays %
                        7 ==
                    0) ||
            (task.repeat == 'Monthly' &&
                DateFormat.yMd().parse(task.date!).day == _selectedDate.day)) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              horizontalOffset: 150,
              child: FadeInAnimation(
                duration: const Duration(milliseconds: 100),
                child: TaskTile(
                  task: task,
                  onTap: () {
                    _showBottomSheet(task);
                  },
                ),
              ),
            ),
          );
        }
        return Container();
      },
      itemCount: _taskController.tasksList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  _showBottomSheet(Task task) {
    Get.bottomSheet(
      Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        height: task.isComplete == 1 ? 170 : 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (task.isComplete != 1)
              Column(
                children: [
                  _buildBottomSheetItem(
                      label: 'Mark as completed task',
                      color: Colors.green,
                      onPressed: () {
                        _taskController.markAsCompleted(task.id!);
                        Get.back();
                      }),
                  const SizedBox(height: 10)
                ],
              ),
            _buildBottomSheetItem(
                label: 'Delete Task',
                color: Colors.red,
                onPressed: () {
                  _taskController.deletsTask(task.id!);
                  Get.back();
                }),
            const Divider(
              color: Colors.white,
              endIndent: 25,
              indent: 25,
            ),
            _buildBottomSheetItem(
                label: 'Cancel',
                color: Colors.white,
                onPressed: () {
                  Get.back();
                }),
          ],
        ),
      ),
      backgroundColor: Colors.black.withOpacity(.5),
    );
  }

  Widget _buildBottomSheetItem(
      {required String label,
      required Color color,
      required Function() onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          color: color,
          child: Text(
            label,
            style: headingStyle4.copyWith(
                color: color == white ? Colors.black : Colors.white,
                fontSize: 20),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
