import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import 'package:flutter/material.dart';
import 'package:todo/views/theme.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/views/widgets/custom_button.dart';
import 'package:todo/views/widgets/custom_text_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key, required this.selectedDate}) : super(key: key);
  final DateTime selectedDate;
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  late String _selectedDate = DateFormat.yMd().format(widget.selectedDate);
  String _startTime = DateFormat('hh:mm a').format(DateTime.now());
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)));

  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Add Task',
                    style: headingStyle2,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    title: 'Title',
                    hint: 'Enter title here.',
                    controller: _titleController,
                  ),
                  CustomTextField(
                    title: 'Note',
                    hint: 'Enter task here.',
                    controller: _noteController,
                  ),
                  CustomTextField(
                      title: 'Date',
                      hint: _selectedDate,
                      suffixButton: IconButton(
                          onPressed: _showDatePicker,
                          icon: Icon(
                            Icons.date_range,
                            color: Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.black,
                          ))),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        title: 'Start Time',
                        hint: _startTime,
                        suffixButton: IconButton(
                          icon: Icon(
                            Icons.access_time,
                            color: Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.black,
                          ),
                          onPressed: () => _showTimePicker(isStartTime: true),
                        ),
                      )),
                      const SizedBox(width: 15),
                      Expanded(
                          child: CustomTextField(
                        title: 'End Time',
                        hint: _endTime,
                        suffixButton: IconButton(
                          icon: Icon(
                            Icons.access_time,
                            color: Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.black,
                          ),
                          onPressed: () => _showTimePicker(isStartTime: false),
                        ),
                      )),
                    ],
                  ),
                  CustomTextField(
                    title: 'Repeat',
                    hint: _selectedRepeat,
                    suffixButton: DropdownButton(
                      items: repeatList
                          .map((e) => DropdownMenuItem<String>(
                              value: e, child: Text(e)))
                          .toList(),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 32,
                        color: Get.isDarkMode ? Colors.grey[300] : Colors.black,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedRepeat = value!;
                        });
                      },
                      underline: Container(height: 0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Color', style: headingStyle4),
                            _colorPalette()
                          ]),
                      CustomButton(
                          label: 'Create Task',
                          onTap: () {
                            _addTaskToDatabase();
                            _taskController.getTasks();
                          })
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            )),
      ),
    );
  }

  _addTaskToDatabase() async {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required Fields',
          'You must type something in title and note fields.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 5),
          onTap: (snack) => Get.back(),
          colorText: Get.isDarkMode ? Colors.black : Colors.white,
          backgroundColor: Get.isDarkMode
              ? Colors.white.withOpacity(.7)
              : Colors.black.withOpacity(.7));
    } else {
      _taskController.addTask(Task(
          title: _titleController.text,
          note: _noteController.text,
          date: _selectedDate,
          startTime: _startTime,
          endTime: _endTime,
          repeat: _selectedRepeat,
          isComplete: 0,
          color: _selectedColor));
      Get.back();
    }
  }

  AppBar _customAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back()),
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

  _showDatePicker() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat.yMd().format(_pickedDate);
      });
    }
  }

  void _showTimePicker({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    String _formattedTime = _pickedTime!.format(context);
    if (_pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = _formattedTime;
        } else {
          _endTime = _formattedTime;
        }
      });
    }
  }

  Widget _colorPalette() {
    List<Color> colors = [bluishClr, pinkClr, orangeClr, Colors.green];
    return (Wrap(
      spacing: 7,
      children: List.generate(
          4,
          ((index) => GestureDetector(
                onTap: (() {
                  setState(() {
                    _selectedColor = index;
                  });
                }),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 16,
                  child: CircleAvatar(
                    backgroundColor: colors[index],
                    radius: 15,
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.check_outlined,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ))),
    ));
  }
}
