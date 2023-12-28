import 'package:kawtharuna/src/core/managers/localization/app_translation.dart';

abstract class StringHelper {
  StringHelper._();

  static const int _thousandsNumber = 1000;
  static const int _millionNumber = 1000000;
  static const int _billionNumber = 1000000000;
  static const int _setaNumber = 1000000000000;

  /// Formats the review upon the value range
  static String formatCount(int reviewsCount) {
    String phrase = '';
    int placeHolder = reviewsCount;
    if (placeHolder < _thousandsNumber) {
      phrase += placeHolder.toString();
    }
    if (placeHolder >= _thousandsNumber && placeHolder < _millionNumber) {
      phrase += (placeHolder ~/ _thousandsNumber).toString();
      phrase += translate.k;
    } else if (placeHolder >= _millionNumber && placeHolder < _billionNumber) {
      phrase += (placeHolder ~/ _millionNumber).toString();
      phrase += translate.m;
    } else if (placeHolder >= _billionNumber && placeHolder < _setaNumber) {
      phrase += (placeHolder ~/ _billionNumber).toString();
      phrase += translate.b;
    } else if (placeHolder >= _setaNumber) {
      phrase += (placeHolder ~/ _setaNumber).toString();
      phrase += translate.s;
    }

    return phrase;
  }

  /// Formats the review upon the value range
  static String formatReviewsCount(int reviewsCount) {
    return '(${formatCount(reviewsCount)} '
        '${reviewsCount > 1 ? translate.reviews : translate.review})';
  }

  /// Formats the times upon the value range
  static String formatTimesCount(int times) {
    return '(${formatCount(times)} '
        '${times > 1 ? translate.times_bought : translate.time_bought})';
  }

  /// Formats the price with specific logic
  static String formatPrice(int price) {
    try {
      return '\$${price.toString()}';
    } catch (e) {
      return '\$${price.toString()}';
    }
  }

  /// Formats the duration with specific logic
  // static String formatDuration(Duration duration) {
  //   int hours = duration.inHours;
  //   int minutes = duration.inMinutes.remainder(60);
  //   return "${translate.hours_count(hours)} ${translate.minutes_count(minutes)}";
  // }

  static int getMemberCountAsShortNumber(int? membersCount) {
    int phrase = 0;
    int placeHolder = membersCount ?? 0;
    if (placeHolder < _thousandsNumber) {
      phrase += placeHolder;
    }
    if (placeHolder >= _thousandsNumber && placeHolder < _millionNumber) {
      phrase += (placeHolder ~/ _thousandsNumber);
    } else if (placeHolder >= _millionNumber && placeHolder < _billionNumber) {
      phrase += (placeHolder ~/ _millionNumber);
    } else if (placeHolder >= _billionNumber && placeHolder < _setaNumber) {
      phrase += (placeHolder ~/ _billionNumber);
    } else if (placeHolder >= _setaNumber) {
      phrase += (placeHolder ~/ _setaNumber);
    }
    return phrase;
  }

  static String getMemberCountAsShortLitter(int? membersCount) {
    String phrase = '';
    int placeHolder = membersCount ?? 0;
    if (placeHolder >= _thousandsNumber && placeHolder < _millionNumber) {
      phrase += translate.k;
    } else if (placeHolder >= _millionNumber && placeHolder < _billionNumber) {
      phrase += translate.m;
    } else if (placeHolder >= _billionNumber && placeHolder < _setaNumber) {
      phrase += translate.b;
    } else if (placeHolder >= _setaNumber) {
      phrase += translate.s;
    }
    return phrase;
  }
}