extension ValidNumber on String {
  String? get validPhoneNumber {
    String? newPh;
    if (length == 11) {
      if (startsWith("0")) {
        newPh = replaceFirst(RegExp(r"0"), "+234");
      }
    } else if (length > 11) {
      if (startsWith(r"234")) {
        newPh = padLeft(14, "+");
      } else if (startsWith(RegExp(r"\+234"))) {
        newPh = this;
      }
    }

    return newPh;
  }
}
