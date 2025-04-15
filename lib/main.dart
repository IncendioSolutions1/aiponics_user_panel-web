import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:seo/seo.dart';
import 'package:aiponics_web_app/routes/app_routes.dart'; // Import application routes
import 'package:aiponics_web_app/routes/route.dart'; // Import route definitions
import 'package:aiponics_web_app/routes/routes_observer.dart'; // Import custom route observer
import 'package:aiponics_web_app/views/page_not_found.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod for state management
import 'package:get/get.dart'; // Import GetX for navigation and state management
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'controllers/common_methods.dart';
import 'controllers/network controllers/dependancy_injection_controller.dart';
import 'controllers/token controllers/access_and_refresh_token_controller.dart';
import 'provider/colors and theme provider/theme_provider.dart'; // Import for web plugins

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Hive.initFlutter();
  // Set URL strategy for web
  setUrlStrategy(PathUrlStrategy());

  // Set up meta SEO configuration for web
  if (kIsWeb) MetaSEO().config();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  DependencyInjection.init();
  await initializeTokenManager(); // Restore token expiry before app starts
  // Run the application within a ProviderScope
  runApp(
    ProviderScope(
      child: Builder(
        builder: (context) {
          return const MyApp();
        },
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider); // Watch the themeProvider for changes

    return SeoController(
      tree: WidgetTree(context: context),
      child: GetMaterialApp(
        title: 'AI Ponics Web User Application', // Application title
        debugShowCheckedModeBanner: false, // Disable debug banner
        scrollBehavior: const DBehavior(),
        theme: theme, // Apply the theme from the provider
        getPages: TAppRoute.pages, // Define the application pages
        initialRoute: TRoutes.splashScreen, // Set initial route
        navigatorKey: CommonMethods.navigatorKey, // Assign the global key here
        unknownRoute: GetPage(
          name: '/page-not-found',
          page: () => const Scaffold(
            body: PageNotFound(),
          ),
        ),
        navigatorObservers: [RouteObserverCustom()], // Add custom route observer
      ),
    );
  }
}

class DBehavior extends ScrollBehavior {
  const DBehavior();

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    // This override removes the default glow effect on overscroll.
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Optionally, you can define custom scroll physics if needed.
    return const BouncingScrollPhysics();
  }
}