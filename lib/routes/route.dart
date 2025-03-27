import 'package:aiponics_web_app/views/authentication/login_screen.dart';
import 'package:aiponics_web_app/views/authentication/register_screen.dart';
import 'package:aiponics_web_app/views/sideBar ( Drawer Screens )/dashboard%20management/control_panel.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/teams%20and%20permissions/add_a_team.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/teams%20and%20permissions/add_a_team_member.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/teams%20and%20permissions/view_team_and_members.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/user%20profile/subscription_plan.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/user%20profile/transaction_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/authentication/splash_screen.dart';
import '../views/sideBar ( Drawer Screens )/dashboard management/dashboard.dart';
import '../views/sideBar ( Drawer Screens )/dashboard management/soil_dashboard.dart';
import '../views/sideBar ( Drawer Screens )/data/records/dosing_system.dart';
import '../views/sideBar ( Drawer Screens )/data/records/monitoring_system.dart';
import '../views/sideBar ( Drawer Screens )/data/todos/add_todo.dart';
import '../views/sideBar ( Drawer Screens )/data/todos/view_all_todos.dart';
import '../views/sideBar ( Drawer Screens )/farms and devices/farms/add_device.dart';
import '../views/sideBar ( Drawer Screens )/farms and devices/farms/add_farms.dart';
import '../views/sideBar ( Drawer Screens )/farms and devices/farms/view_farm_and_devices.dart';

class TRoutes {
  // Define route constants for navigation


  static const login = '/login';
  static const forgetPassword = '/forget-password';
  static const register = '/register';
  static const splashScreen = '/splash-screen';

  static const dashboard = '/dashboard-management/dashboard';
  static const home = '/';
  static const soilDashboard = '/dashboard-management/soil-dashboard';
  static const controlPanel = '/dashboard-management/control-panel';

  static const farms = '/farms-and-devices/farms';
  static const addFarms = '/farms-and-devices/farms/add-a-new-farm';
  static const addDevice = '/farms-and-devices/farms/add-a-new-device';
  static const viewFarmsAndDevices = '/farms-and-devices/farms/view-farms-and-devices';

  static const addATeam = '/teams-and-permissions/add-a-team';
  static const addATeamMember = '/teams-and-permissions/add-a-team-member';
  static const viewTeamsAndMembers = '/teams-and-permissions/view-teams-and-members';

  static const users = '/users';
  static const analytics = '/analytics';
  static const records = '/data/records';
  static const monitoringSystem = '/data/records/monitoring-system';
  static const dosingSystem = '/data/records/dosing-system';
  static const todos = '/todos';
  static const addTodos = '/data/todos/add-todo';
  static const viewTodos = '/data/todos/view-all-todos';

  static const userPages = '/user-profile/user-pages';
  static const transactionHistory = '/user-profile/transaction-history';
  static const subscriptionPlans = '/user-profile/subscription-plans';

  static const documentation = '/documentation';


  // Map of routes to corresponding widgets
  static Map<String, Widget> routesMap = {
    login: const LoginScreen(),
    register: const RegisterScreen(),
    dashboard: const Dashboard(),
    home: const Dashboard(),
    soilDashboard: const SoilBasedDashboard(),
    controlPanel: const ControlPanel(),
    viewFarmsAndDevices: const ViewFarmAndDevices(),
    monitoringSystem: const MonitoringSystem(),
    dosingSystem: const DosingSystem(),
    addTodos: const AddTodo(),
    viewTodos: const ViewTodos(),
    addFarms: const AddFarms(),
    addDevice: const AddDevice(),
    addATeam: const AddATeam(),
    addATeamMember: const AddATeamMember(showHeader: true),
    viewTeamsAndMembers: const ViewTeamsAndMembers(),
    transactionHistory: const TransactionHistory(),
    subscriptionPlans: const SubscriptionPlan(),
    splashScreen: const SplashScreen(),
  };

  // Define the side menu structure with sections and sub-options
  static const List<Map<String, dynamic>> sideMenuItems = [

    // Section headers
    {'text': 'Dashboard Management', 'isHeader': true},
    {'text': 'Dashboard', 'icon': Icons.dashboard, 'route': dashboard},
    {'text': 'Soil Dashboard', 'icon': Icons.dashboard_outlined, 'route': soilDashboard},
    {'text': 'Control Panel', 'icon': CupertinoIcons.slider_horizontal_3, 'route': controlPanel},

    // Section headers
    {'text': 'FARMS AND DEVICES', 'isHeader': true},
    {
      'text': 'Farms & Devices',
      'icon': CupertinoIcons.house_fill,
      'route': farms,
      'hasSubOptions': true,
      'subOptions': [
        {'text': 'Add Farm', 'icon': Icons.add, 'action': addFarms},
        {'text': 'Add Device', 'icon': Icons.add, 'action': addDevice},
      ],
    },
    {'text': 'View Farms & Devices', 'icon': Icons.remove_red_eye, 'route':  viewFarmsAndDevices},

    // Section headers
    {'text': 'TEAMS AND PERMISSIONS', 'isHeader': true},
    {'text': 'Add a Team', 'icon': CupertinoIcons.person, 'route': addATeam},
    {'text': 'Add a Team Member', 'icon': CupertinoIcons.person_3_fill, 'route': addATeamMember},
    {'text': 'View Teams & Members', 'icon': CupertinoIcons.eye_fill, 'route': viewTeamsAndMembers},


    {'text': 'DATA', 'isHeader': true},
    {'text': 'Users', 'icon': Icons.person, 'route': users},
    {'text': 'Analytics', 'icon': Icons.analytics, 'route': analytics},
    {
      'text': 'Records',
      'icon': Icons.library_books,
      'route': records,
      'hasSubOptions': true,
      'subOptions': [
        {'text': 'Monitoring System', 'icon': CupertinoIcons.chart_bar, 'action': monitoringSystem},
        {'text': 'Dosing System', 'icon': CupertinoIcons.chart_bar, 'action': dosingSystem},
      ],
    },

    {
      'text': 'Todos',
      'icon': Icons.check_circle,
      'route': todos,
      'hasSubOptions': true,
      'subOptions': [
        {'text': 'Add Todo', 'icon': CupertinoIcons.eye_fill, 'action': addTodos},
        {'text': 'View All Todos', 'icon': CupertinoIcons.add_circled, 'action': viewTodos},
      ],
    },

    {'text': 'USER PROFILE', 'isHeader': true},
    {'text': 'User Pages', 'icon': Icons.person_outline, 'route': userPages},
    {'text': 'Transaction History', 'icon': Icons.history, 'route': transactionHistory},
    {'text': 'Subscription Plans', 'icon': Icons.card_membership, 'route': subscriptionPlans},

    {'text': 'HELP', 'isHeader': true},
    {'text': 'Documentation', 'icon': Icons.description, 'route': documentation},
  ];
}
