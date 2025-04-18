import 'package:aiponics_web_app/routes/route.dart'; // Importing route definitions
import 'package:aiponics_web_app/routes/routes_middleware.dart'; // Importing middleware for routes

import 'package:get/get.dart'; // Importing GetX package for state management and routing

import '../views/authentication/register_screen.dart'; // Importing the registration screen
import '../views/authentication/login_screen.dart'; // Importing the login screen
import '../views/authentication/splash_screen.dart';
import '../views/drawer_screen.dart';

// TAppRoute class that manages the app's routing
class TAppRoute {



  // List of pages registered with GetX
  static final List<GetPage> pages = [


    GetPage(name: TRoutes.login, page: () => const LoginScreen()), // Route for login
    GetPage(name: TRoutes.register, page: () => const RegisterScreen()), // Route for registration
    GetPage(name: TRoutes.splashScreen, page: () => const SplashScreen()), // Route for registration

    // Dashboard and other screens with middleware for access control
    GetPage(name: TRoutes.dashboard, page: () => const DrawerScreen(TRoutes.dashboard), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.soilDashboard, page: () => const DrawerScreen(TRoutes.soilDashboard), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.controlPanel, page: () => const DrawerScreen(TRoutes.controlPanel), middlewares: [TRouteMiddleWare()]),

    GetPage(name: TRoutes.addFarms, page: () => const DrawerScreen(TRoutes.addFarms), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.addDevice, page: () => const DrawerScreen(TRoutes.addDevice), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.viewFarmsAndDevices, page: () => const DrawerScreen(TRoutes.viewFarmsAndDevices), middlewares: [TRouteMiddleWare()]),

    GetPage(name: TRoutes.addATeam, page: () => const DrawerScreen(TRoutes.addATeam), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.addATeamMember, page: () => const DrawerScreen(TRoutes.addATeamMember), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.viewTeamsAndMembers, page: () => const DrawerScreen(TRoutes.viewTeamsAndMembers), middlewares: [TRouteMiddleWare()]),

    GetPage(name: TRoutes.monitoringSystem, page: () => const DrawerScreen(TRoutes.monitoringSystem), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.dosingSystem, page: () => const DrawerScreen(TRoutes.dosingSystem), middlewares: [TRouteMiddleWare()]),

    GetPage(name: TRoutes.addTodos, page: () => const DrawerScreen(TRoutes.addTodos), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.viewTodos, page: () => const DrawerScreen(TRoutes.viewTodos), middlewares: [TRouteMiddleWare()]),

    GetPage(name: TRoutes.transactionHistory, page: () => const DrawerScreen(TRoutes.transactionHistory), middlewares: [TRouteMiddleWare()]),
    GetPage(name: TRoutes.subscriptionPlans, page: () => const DrawerScreen(TRoutes.subscriptionPlans), middlewares: [TRouteMiddleWare()]),
  ];
}
