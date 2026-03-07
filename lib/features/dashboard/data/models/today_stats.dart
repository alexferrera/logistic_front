
class TodayStatsModel {
  final int ordersCompleted;
  final int bottlesDelivered;

  TodayStatsModel({
    required this.ordersCompleted,
    required this.bottlesDelivered,
  });

  factory TodayStatsModel.fromJson(Map<String, dynamic> json) {
    return TodayStatsModel(
      ordersCompleted: json["orders_completed"] ?? 0,
      bottlesDelivered: json["bottles_delivered"] ?? 0,
    );
  }
}