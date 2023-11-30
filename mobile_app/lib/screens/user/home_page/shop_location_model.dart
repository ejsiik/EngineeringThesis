class ShopLocationModel {
  String location;
  String monday;
  String tuesday;
  String wednesday;
  String thursday;
  String friday;
  String saturday;
  String sunday;
  bool isExpanded;

  ShopLocationModel(
      {required this.location,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday,
      required this.isExpanded});
}
