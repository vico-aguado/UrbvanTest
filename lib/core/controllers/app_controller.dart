import 'package:get/get.dart';
import 'package:urbvan/configuration.dart';
import 'package:urbvan/core/models/issLocation_model.dart';
import 'package:urbvan/core/network/api.dart';

class AppController extends GetxController {
  final AppApi api = AppApi();

  Stream<ISSLocationModel> getLiveISSLocation() async* {
    yield* Stream.periodic(Duration(seconds: secondsToGetLocation), (_) {
      return api.getISSLocation();
    }).asyncMap(
      (value) async => await value,
    );
  }
}
