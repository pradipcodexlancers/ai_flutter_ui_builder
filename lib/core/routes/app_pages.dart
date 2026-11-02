import 'package:get/get.dart';
import '../../modules/analysis/bindings/analysis_binding.dart';
import '../../modules/analysis/views/analysis_view.dart';
import '../../modules/code_preview/bindings/code_preview_binding.dart';
import '../../modules/code_preview/views/code_preview_view.dart';
import '../../modules/code_preview/views/ui_preview_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.analysis,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.codePreview,
      page: () => const CodePreviewView(),
      binding: CodePreviewBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.uiPreview,
      page: () => const UiPreviewView(),
      binding: CodePreviewBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
