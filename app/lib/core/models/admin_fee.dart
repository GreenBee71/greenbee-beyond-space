class AdminFee {
  final int id;
  final String billingMonth;
  final double totalAmount;
  final String status;
  final Map<String, dynamic> details;

  AdminFee({
    required this.id,
    required this.billingMonth,
    required this.totalAmount,
    required this.status,
    required this.details,
  });

  factory AdminFee.fromJson(Map<String, dynamic> json) {
    return AdminFee(
      id: json['id'],
      billingMonth: json['billing_month'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      details: json['details'] ?? {},
    );
  }
}
