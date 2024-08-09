import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:todo/views/size_config.dart';

import '../../models/task.dart';
import '../theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onTap});
  final Task task;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          color: _getBGClr(task.color!),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.title!,
                    style: headingStyle4.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${task.startTime} - ${task.endTime}',
                    style: headingStyle6.copyWith(
                        fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: SizeConfig.screenWidth - 100,
                    child: Flexible(
                      child: Text(
                        task.note!,
                        style: headingStyle5.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 5),
                color: Colors.grey[300],
                height: 60,
                width: 1,
              ),
              RotatedBox(
                quarterTurns: 3,
                child: AutoSizeText(
                  task.isComplete == 1 ? 'Completed' : 'TODO',
                  style: headingStyle6.copyWith(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBGClr(int i) {
    List<Color> colors = [bluishClr, pinkClr, orangeClr, Colors.green];
    return colors[i];
  }
}
