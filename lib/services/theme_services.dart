

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';


class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode)=>_box.write(_key, isDarkMode);
  ///load theme từ _box
  bool _loadThemeFormBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFormBox() ? ThemeMode.dark : ThemeMode.light;


  /// Nếu theme đang là light thì chuyển sang dark và ngược lại
  void SwitchTheme() {
    Get.changeThemeMode(_loadThemeFormBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFormBox());
  }
}
