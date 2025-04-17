class BehaviorModel {
  String? id;
  String name;
  String iconPath;
  int total_point;
  String status;
  String date;
  BehaviorModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.total_point,
    required this.date,
    required this.status,
  });
  factory BehaviorModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['image_path'] ?? '';
    final formattedPath = rawPath.replaceAll('\\', '/'); // แปลง \ เป็น /

    return BehaviorModel(
      id: json['behavior_id']?.toString() ?? '',
      name: json['behavior_description'] ?? '',
      iconPath: 'http://127.0.0.1:4001/$formattedPath', // Full image URL
      total_point:
          json['total_points'] is int
              ? json['total_points']
              : int.tryParse(json['total_points'].toString()) ?? 0,
      date: json['behavior_date'] ?? '',
      status: json['behavior_status'],
    );
  }
}
