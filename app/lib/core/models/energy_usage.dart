class EnergyUsage {
  final int id;
  final String usageMonth;
  final int electricity;
  final int water;
  final int gas;
  final int heating;

  EnergyUsage({
    required this.id,
    required this.usageMonth,
    required this.electricity,
    required this.water,
    required this.gas,
    required this.heating,
  });

  factory EnergyUsage.fromJson(Map<String, dynamic> json) {
    return EnergyUsage(
      id: json['id'],
      usageMonth: json['usage_month'],
      electricity: json['electricity'],
      water: json['water'],
      gas: json['gas'],
      heating: json['heating'],
    );
  }
}
