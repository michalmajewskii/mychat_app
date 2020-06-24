import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychatapp/views/main_view.dart';

class MainPopupMenu{
  static const String Account = 'Account Settings';
  static const String Users = 'All Users';
  static const String Logout = 'Sign Out';


  static const List<String> choices = <String>[
    Account,
    Users,
    Logout
  ];





}