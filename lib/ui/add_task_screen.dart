import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp_flutter/ui/widget/custom_button_widget.dart';
import 'package:todoapp_flutter/ui/widget/input_field.dart';

import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../ultis/constants.dart';
import '../ultis/dimensions.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());

  //tiêu đề
  final TextEditingController _titleController = TextEditingController();
  //ghi chú
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  //DateTime _selectedDate = DateFormat("yMMMMd").format(DateTime.now());
  String _endTime = "9:30 PM";
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeat = "Không";
  List<String> repeatList = ["Không", "Hàng Ngày", "Hàng Tuần", "Hàng Tháng"];

  int _selectedColor = 0;

  ///Lấy thời gian hiện tại rồi format thành hh:mm a sau đó parse thành String
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        margin: EdgeInsets.only(
          left: Dimensions.width10,
          right: Dimensions.width20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dimensions.gapH5,
              Text(
                "Thêm công việc",
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //form Tiêu đề
              Dimensions.gapH15,
              CustomInputField(
                title: "Tiêu đề",
                hint: "Nhập tiêu đề",
                controller: _titleController,
              ),
              //form ghi chú
              Dimensions.gapH10,
              CustomInputField(
                title: "Ghi chú",
                hint: "Nhập ghi chú",
                controller: _noteController,
              ),
              //form ngày tháng
              Dimensions.gapH10,
              CustomInputField(
                title: "Ngày tháng",
                hint: DateFormat('dd/MM/yyyy').format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              //form Thời gian
              Dimensions.gapH10,
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      title: "Thời gian bắt đầu",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Dimensions.gapW15,
                  Expanded(
                    child: CustomInputField(
                      title: "Thời gian kết thúc",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //form báo lại
              Dimensions.gapH10,
              CustomInputField(
                title: "Báo lại",
                hint: "$_selectedRemind Phút",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.grey,
                  ),
                  iconSize: Dimensions.iconSize24,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  //show list tuỳ chọn
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        value.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  //set value cho _selectedRemind bằng giá trị đã chọn
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                ),
              ),
              //form lặp lại
              Dimensions.gapH10,
              CustomInputField(
                title: "Lăp lại",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.grey,
                  ),
                  iconSize: Dimensions.iconSize24,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  //show list tuỳ chọn
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  //set value cho _selectedRemind bằng giá trị đã chọn
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                ),
              ),
              Dimensions.gapH15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _stickerPallete(),
                  CustomButton(
                    label: "Tạo Công việc",
                    onTap: () async {
                      //_validateData();
                      final Task task = Task();
                      _addTaskToDB(task);
                      await _taskController.addTask(task);
                      Get.back();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //push data vào database
  /* _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("id: $value");
  }*/
  _addTaskToDB(Task task) {
    task.isCompleted = 0;
    task.color = -_selectedColor;
    task.title = _titleController.text;
    task.note = _noteController.text;
    task.repeat = _selectedRepeat;
    task.remind = _selectedRemind;
    task.date = DateFormat('dd/MM/yyyy').format(_selectedDate);
    task.startTime = _startTime;
    task.endTime = _endTime;
  }

  //check data nhập vào
  /*_validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Bắt buộc",
        "Những thông tin này là bắt buộc!",
        snackPosition: SnackPosition.TOP,
        backgroundColor:
            Get.isDarkMode ? kContentColorLightTheme : kContentColorDarkTheme,
        icon: const Icon(Icons.warning_amber_rounded),
      );
    }
  }*/

  //Chọn nhãn dán màu cho công việc
  _stickerPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nhãn",
          style: titleStyle,
        ),
        Dimensions.gapH5,
        Wrap(
          spacing: Dimensions.width5,
          children: List<Widget>.generate(2, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: CircleAvatar(
                radius: Dimensions.radius5 * 3.5,
                backgroundColor: index == 0
                    ? kStickers1
                    : kStickers2,
                        //: kStickers3,
                child: _selectedColor ==
                        index //Nếu _selectedColor == index thì hiện icon done ngược lại none
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                        size: Dimensions.iconSize16,
                      )
                    : Container(),
              ),
            );
          }),
        )
      ],
    );
  }

  //widget appbar
  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Get.isDarkMode ? kContentColorLightTheme : Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        const CircleAvatar(
          backgroundImage: AssetImage("assets/images/person.png"),
        ),
        SizedBox(
          width: Dimensions.width20,
        ),
      ],
    );
  }

  //func Ngày tháng
  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2060),
      //locale: const Locale('vi')
    );

    if (pickerDate != null) {
      /// update state của hinttext _selectedDate thành _pickerDate
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      debugPrint("error");
    }
  }

  //func Thời gian
  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      debugPrint("cancel");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formatedTime;
      });
    }
  }

  //func show Time picker
  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        ///_startTime -> hh:mm a
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
