import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env if present
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env is optional if user enters API key in UI settings
  }

  runApp(const AiFlutterUiBuilderApp());
}

class AiFlutterUiBuilderApp extends StatelessWidget {
  const AiFlutterUiBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    );
  }
}
