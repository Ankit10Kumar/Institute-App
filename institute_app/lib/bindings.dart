import 'package:get/get.dart';
import 'package:imstitute/controller/authorisation_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthrisationController>(
      () => AuthrisationController(),
      fenix: true,
    );
  }
}
