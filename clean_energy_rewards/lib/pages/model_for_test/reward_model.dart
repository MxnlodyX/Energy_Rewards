class RewardModel {
  int id;
  String name;
  String description;
  String iconPath;
  int total_point;
  String? exchangeDate; // <- เพิ่มตรงนี้

  RewardModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.total_point,
    this.exchangeDate,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['image_path'] ?? '';
    final formattedPath = rawPath.replaceAll('\\', '/');

    return RewardModel(
      id: json['reward_id'], // ใช้เป็น int โดยตรง
      name: json['reward_name'] ?? '',
      description: json['description'] ?? '',
      iconPath: 'https://energy-rewards.onrender.com/$formattedPath',
      total_point: json['exchange_point'] ?? 0,
      exchangeDate: json['exchange_on'] ?? '',
    );
  }
}
