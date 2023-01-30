import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp_flutter/services/notification_services.dart';
import 'package:todoapp_flutter/ui/widget/custom_button_widget.dart';
import '../controllers/task_controller.dart';
import '../services/theme_services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../ultis/constants.dart';
import '../ultis/dimensions.dart';
import 'add_task_screen.dart';
import 'package:get_storage/get_storage.dart';

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
          _showTask(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AlertDialog();
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
          _selectedDate = date;
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
            Get.to(const AddTaskScreen());
          },
        ),
        SizedBox(width: Dimensions.width10),
      ],
    );
  }

  _showTask() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, context) {
              print(_taskController.taskList.length);
              return Container(
                width: Dimensions.width20 * 5,
                height: Dimensions.height50,
                color: Colors.green,
              );
            },
          );
        },
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
}
