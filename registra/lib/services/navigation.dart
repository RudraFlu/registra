import 'package:flutter/material.dart';
import 'package:registra/Homepage/account.dart';
import 'package:registra/Homepage/friends.dart';
import 'package:registra/Homepage/groups.dart';
import 'package:registra/Homepage/home.dart';
import 'package:registra/Homepage/insights.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();


MaterialPageRoute bottombarNavigate(int value){
 if(value == 0){
  return MaterialPageRoute(builder: (_)=>HomePage());
 }
 else if(value == 1){
  return MaterialPageRoute(builder: (_)=>GroupsPage());
 }else if(value == 2){
  return MaterialPageRoute(builder: (_)=>FriendsPage());
 }else if(value == 3){
  return MaterialPageRoute(builder: (_)=>InsightPage());
 }else if(value == 4){
  return MaterialPageRoute(builder: (_)=>AccountsPage());
 } else{
  throw Exception("Invalid bottom navigation index: $value");
 }
}
