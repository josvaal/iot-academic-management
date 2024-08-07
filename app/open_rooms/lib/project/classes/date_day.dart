class DateDay {
  final int year;
  final int month;
  final int day;

  const DateDay(this.year, this.month, this.day);

  @override
  String toString() {
    return "$year-$month-$day";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DateDay) return false;
    return year == other.year && month == other.month && day == other.day;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;
}
