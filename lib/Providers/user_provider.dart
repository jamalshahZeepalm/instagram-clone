 

import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/Database%20Services/auth_services.dart';
import 'package:instagram_clone/Model/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get getUser => _userModel;
  AuthServices authServices = AuthServices();
  Future<void> refreshUser() async {
    UserModel userModel = await authServices.getUserDetails();
    _userModel = userModel;
    notifyListeners();
  }
}
