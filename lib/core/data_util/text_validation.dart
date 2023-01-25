import 'package:intl/intl.dart';

class WEDIDTextValidation {
  static String dateTimeFormat1(DateTime value) {
    return DateFormat('yyyy.MM.dd').format(value);
  }

  static String dateTimeFormat2(DateTime value) {
    return DateFormat('yy.MM.dd').format(value);
  }

  static String dateTimeFormat3(DateTime value) {
    return DateFormat('yy/MM/dd').format(value);
  }

  static String dateTimeFormat4(DateTime value) {
    return DateFormat('jm').format(value);
  }
}

extension StringExtention on String {
  bool isKorean() {
    RegExp regExp = RegExp(
      r'^[가-힣]+$',
      caseSensitive: true,
      multiLine: false,
    );
    return regExp.hasMatch(this);
  }

  bool isTrimNotEmpty() {
    return trim().isNotEmpty;
  }

  bool isTrimEmpty() {
    return trim().isEmpty;
  }

  bool isDate() {
    RegExp regExp = RegExp(
      r'^\d{8}$',
      caseSensitive: false,
      multiLine: false,
    );

    if(regExp.hasMatch(replaceAll('/',''))) {
      final year = split('/')[0];
      final month = split('/')[1];
      final day = split('/')[2];

      if(int.parse(year) > DateTime.now().year || int.parse(month) > 12 || int.parse(day) > 31) {
        return false;
      }

      return true;
    }else{
      return false;
    }
  }

  bool isPhoneNumber() {
    RegExp regExp = RegExp(
      r'^(\d{10}|\d{11})$',
      caseSensitive: false,
      multiLine: false,
    );

    return regExp.hasMatch(this);
  }

  bool isCertNumber() {
    RegExp regExp = RegExp(
      r'^\d{6}$',
      caseSensitive: false,
      multiLine: false,
    );

    return regExp.hasMatch(this);
  }

  bool isUnder12Word() {
    RegExp regExp = RegExp(
      r'^[가-힣0-9 ]{3,12}$',
      caseSensitive: false,
      multiLine: false,
    );

    return regExp.hasMatch(this);
  }
}
