class Visitor {
  final int id;
  final String carNumber;
  final String? visitorName;
  final String visitDate;
  final String purpose;
  final String status;

  Visitor({
    required this.id,
    required this.carNumber,
    this.visitorName,
    required this.visitDate,
    required this.purpose,
    required this.status,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'],
      carNumber: json['car_number'],
      visitorName: json['visitor_name'],
      visitDate: json['visit_date'],
      purpose: json['purpose'],
      status: json['status'],
    );
  }
}
