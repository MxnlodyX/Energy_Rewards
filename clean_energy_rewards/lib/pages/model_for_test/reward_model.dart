
class RewardModel {
  String name;
  String iconPath;
  int total_point;
  RewardModel({
    required this.name,
    required this.iconPath,
    required this.total_point,
  });

  static List<RewardModel> getRewards() {
    List<RewardModel> rewards = [];
    rewards.add(
      RewardModel(
        name: 'Sneaker',
        iconPath: 'assets/gucci.jpg',
        total_point: 2000,
      ),
    );
    rewards.add(
      RewardModel(
        name: 'Adidas T-shirt',
        iconPath: 'assets/Adidas_t-shirt.avif',
        total_point: 2000,
      ),
    );
    rewards.add(
      RewardModel(
        name: 'The Toth Bag',
        iconPath: 'assets/bag.jpg',
        total_point: 2000,
      ),
    );
    rewards.add(
      RewardModel(
        name: 'Yeti ',
        iconPath: 'assets/yeti.jpg',
        total_point: 2000,
      ),
    );
    rewards.add(
      RewardModel(
        name: 'Yeti v2 ',
        iconPath: 'assets/yeti.jpg',
        total_point: 2000,
      ),
    );
    return rewards;
  }
}
