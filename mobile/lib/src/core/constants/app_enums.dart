class AppConstants {
  AppConstants._();

  static const fileSize = 1.8;

  static const textFieldMaxLines = 4;
  static const checkboxBorderWidth = 1.5;
  static const borderWidth = 1.0;
}

enum PlatformTargetApp { android, iOS, web, macOs, windows, linux }

enum SiteStatus { pending, processing, success, failure }