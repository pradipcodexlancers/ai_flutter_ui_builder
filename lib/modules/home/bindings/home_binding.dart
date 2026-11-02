import 'package:get/get.dart';
import '../../../data/repositories/gemini_repository.dart';
import '../../../services/api_service.dart';
import '../../../services/image_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<ImageService>(() => ImageService());
    Get.lazyPut<IGeminiRepository>(
      () => GeminiRepository(apiService: Get.find<ApiService>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
        repository: Get.find<IGeminiRepository>(),
        imageService: Get.find<ImageService>(),
      ),
    );
  }
}
