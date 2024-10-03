extension DeliveryDate on DateTime {
  static const List<String> _monthAbbreviations = [
    'Jan',
    'Feb',
    'March',
    'April',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get formatDate {
    return "${_monthAbbreviations[month - 1]} $day, $year";
  }
}
