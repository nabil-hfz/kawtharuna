import 'package:kawtharuna/main.dart';

class AppEndpoints {
  AppEndpoints._();

  // base url
  static String baseUrl = envVariables.baseUrl;

  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 30000;

  // Khatma
  static const String _khatma = "khatma";
  static const String getKhatmat = '$_khatma/';
  static String getKhatmaDetails(String id) => '$_khatma/$id';

  // Reciter
  static const String _reciter = "reciter";
  static const String getReciters = '$_reciter/';
  static const String getReciterDetails = '$_reciter/';

  // Recitation
  static const String _recitation = "recitation";
  static const String getRecitations = '$_recitation/';

  static String getRecitationDetails(String id) => '$_recitation/$id';
}

abstract class AppQueryParameters {
  AppQueryParameters._();

  static const String id = "id";
  static const String serviceId = "serviceId";
  static const String fileName = "fileName";
  static const String file = "file";
  static const String name = "name";
}
