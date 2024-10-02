class Transaction {
  final String id;
  final String name;
  final double amount;
  final DateTime createdAt;
  final String type; 
  final bool isRepeated;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.type,
    this.isRepeated = false,
  });

Transaction copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? createdAt,
    String? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

}