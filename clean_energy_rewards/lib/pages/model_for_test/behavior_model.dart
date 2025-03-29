
class BehaviorModel {
  String name;
  String iconPath;
  int total_point;
  String status;
  String date;
  BehaviorModel({
    required this.name,
    required this.iconPath,
    required this.total_point,
    required this.date,
    required this.status,
  });

  static List<BehaviorModel> getBehaviors() {
    List<BehaviorModel> behaviors = [];
    behaviors.add(
      BehaviorModel(
        name: 'ใช้ขวดน้ำตัวเองแทนพลาสติก',
        iconPath: 'assets/yeti.jpg',
        total_point: 2000,
        date: '2025-12-2',
        status: 'Pending',
      ),
    );
    behaviors.add(
      BehaviorModel(
        name: 'ใช้ถุงผ้า',
        iconPath: 'assets/bag.jpg',
        total_point: 2000,
        date: '2025-12-2',
        status: 'Success',
      ),
    );
    behaviors.add(
      BehaviorModel(
        name: 'ติดตั้งโซล่าเซล',
        iconPath: 'assets/solar_cell.jpg',
        total_point: 2000,
        date: '2025-12-2',
        status: 'Pending',
      ),
    );
    behaviors.add(
      BehaviorModel(
        name: 'ใช้รถไฟฟ้าไปทำงาน',
        iconPath: 'assets/evcar.jpg',
        total_point: 2000,
        date: '2025-12-2',
        status: 'Success',
      ),
    );
    return behaviors;
  }
}
