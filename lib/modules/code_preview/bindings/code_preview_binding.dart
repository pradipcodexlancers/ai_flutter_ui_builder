import 'package:get/get.dart';
import '../controllers/code_preview_controller.dart';

class CodePreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CodePreviewController>(() => CodePreviewController());
  }
}
