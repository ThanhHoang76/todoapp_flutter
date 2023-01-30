import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp_flutter/models/task_model.dart';
import 'package:todoapp_flutter/services/notification_services.dart';
import 'package:todoapp_flutter/ui/widget/custom_button_widget.dart';
import 'package:todoapp_flutter/ui/widget/task_tile.dart';
import '../controllers/task_controller.dart';
import '../services/theme_services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../ultis/constants.dart';
import '../ultis/dimensions.dart';
import 'add_task_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  var notifyHelper = NotifyHelper();
  bool _iconBool = false;
  final IconData _iconLight = Icons.wb_sunny;
  final IconData _iconDark = Icons.nights_stay_sharp;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _taskController.getTask();
    notifyHelper.initializeNotification();
    debugPrint(Get.context!.height.toString());
    //cấp quyền thông báo cho app
    notifyHelper.requestIOSPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          Dimensions.gapH15,
          _showTask(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _taskController.deleteAllTasks();
        },
        child: const Icon(Icons.delete),
      ),
    );
  }

  ///datetime picker bar
  _addDateBar() {
    return Container(
      margin:
          EdgeInsets.only(top: Dimensions.height10, left: Dimensions.width10),
      child: DatePicker(
        DateTime.now(),
        height: Dimensions.height100,
        width: Dimensions.width20 * 4,
        initialSelectedDate: DateTime.now(),
        selectionColor: kPrimaryColor,
        dateTextStyle: GoogleFonts.comfortaa(
          textStyle: TextStyle(
            fontSize: Dimensions.font20,
            fontWeight: FontWeight.w600,
          ),
        ),
        monthTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle()),
        dayTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle()),
        locale: 'vi_VN',
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  //add Task button
  _addTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: Dimensions.height15 * 5),
        //Ngày tháng năm
        Container(
          padding: EdgeInsets.only(
            top: Dimensions.height20,
            left: Dimensions.width10,
            right: Dimensions.width10,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: GoogleFonts.comfortaa(
                  textStyle: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              //SizedBox(height: Dimensions.height1 * 3),
              Text(
                "Hôm nay",
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                      fontSize: Dimensions.font15, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        //SizedBox(width: Dimensions.width1*7),
        //button add task
        CustomButton(
          label: "+ Add Task",
          onTap: () {
            //Get.toNamed(RouterHelper.getAddTask());
            Get.to(
              () => const AddTaskScreen(),
              transition: Transition.leftToRight,
              duration: const Duration(milliseconds: 300),
            );
            //return _taskController.getTask();
          },
        ),
        Dimensions.gapH10,
      ],
    );
  }

  _showTask() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (context, index) {
              Task task = _taskController.taskList[index];
              var date = DateFormat.jm().parse(task.startTime!);
              var myTime = DateFormat('HH:mm').format(date);
              handlingReminder(task.remind!, myTime, task);
              print(task.toMap());
              if(task.repeat == 'Hàng Ngày' ||
                  task.date == DateFormat('dd/MM/yyyy').format(_selectedDate) ||
                  (task.repeat == 'Hàng Tuần' && _selectedDate.difference(DateFormat.yMd().parse(task.date!)).inDays % 7 == 0)||
                  (task.repeat == 'Hàng Tháng' && DateFormat.yMd().parse(task.date!).day == _selectedDate.day)){
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(
                              task,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              /*if(task.date == DateFormat('dd/MM/yyyy').format(_selectedDate)){
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(
                              task,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }*/
              else{
                return Container();
              }

            },
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: Dimensions.height3),
        height: task.isCompleted == 1
            ? Dimensions.height100 * 1.7
            : Dimensions.height100 * 2.2,
        decoration: BoxDecoration(
          color:
              Get.isDarkMode ? kContentColorLightTheme : kContentColorDarkTheme,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimensions.radius20),
            topLeft: Radius.circular(Dimensions.radius20),
          ),
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Hoàn thành công việc",
                    onTap: () {
                      _taskController.markAsCompleted(task.id!);
                      Get.back();
                    },
                    context: context,
                    color: Colors.green,
                  ),
            Dimensions.gapH10,
            _bottomSheetButton(
              label: "Xoá công việc",
              onTap: () {
                _taskController.deleteTaskId(task);
                Get.back();
              },
              color: Colors.red,
              context: context,
            ),
            Dimensions.gapH24,
            _bottomSheetButton(
              label: "Đóng",
              onTap: () {
                Get.back();
              },
              isClose: true,
              color: Colors.green,
              context: context,
            ),
            Dimensions.gapH40,
          ],
        ),
      ),
    );
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color color,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: Dimensions.height40,
        width: Get.context!.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true ? Colors.grey : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.grey : color,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.comfortaa(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.font15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      //backgroundColor: Get.isDarkMode ? kContentColorLightTheme : Colors.white,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            //thay đổi theme
            ThemeService().SwitchTheme();
            //hiển thị thông báo them đã thay đổi
            notifyHelper.displayNotification(
                title: "Theme",
                body: Get.isDarkMode ? "Chế độ sáng" : "Chế độ Tối");
            //thông báo lại sau 5s nếu không tắt thông báo
            //notifyHelper.scheduledNotification();
            setState(() {
              _iconBool = !_iconBool;
            });
          },
          icon: Icon(
            _iconBool ? _iconLight : _iconDark,
            size: Dimensions.height30,
            color: _iconBool ? Colors.white : Colors.black87,
          )),
      actions: [
        CircleAvatar(
          backgroundImage: const AssetImage("assets/images/person.png"),
          backgroundColor: _iconBool ? Colors.black : Colors.white,
        ),
        SizedBox(
          width: Dimensions.width30,
        ),
      ],
    );
  }

  handlingReminder(int reminder, var myTime, Task task) {
    var minutes = int.parse(myTime.toString().split(':')[1]);
    var hours = int.parse(myTime.toString().split(':')[0]);
    if (reminder == 5) {
      notifyHelper.scheduledNotification(minutes < 5 ? hours - 1 : hours,
          minutes < 5 ? minutes + 55 : minutes - 5, task);
    } else if (reminder == 10) {
      notifyHelper.scheduledNotification(minutes < 10 ? hours - 1 : hours,
          minutes < 10 ? minutes + 50 : minutes - 10, task);
    } else if (reminder == 15) {
      notifyHelper.scheduledNotification(minutes < 15 ? hours - 1 : hours,
          minutes < 15 ? minutes + 45 : minutes - 15, task);
    } else {
      notifyHelper.scheduledNotification(minutes < 20 ? hours - 1 : hours,
          minutes < 20 ? minutes + 40 : minutes - 20, task);
    }
  }
}
