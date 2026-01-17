class Wallet {
  final int id;
  final int userId;
  final double balance;
  final String currency;
  final DateTime updatedAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      userId: json['user_id'],
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Transaction {
  final int id;
  final int walletId;
  final double amount;
  final String type;
  final String? description;
  final String status;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      walletId: json['wallet_id'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
