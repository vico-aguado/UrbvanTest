import 'package:dio/dio.dart';
import 'package:urbvan/core/models/issLocation_model.dart';

class AppApi {
  final Dio dio = Dio();

  static String _urlISSLocation = "http://api.open-notify.org/iss-now.json";

  Future<ISSLocationModel> getISSLocation() async {
    try {
      Response request = await dio.get(_urlISSLocation);
      if (request.statusCode == 200) {
        return ISSLocationModel.fromMap(request.data);
      }

      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
