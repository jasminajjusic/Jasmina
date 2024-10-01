
class Transaction {
  final String id;
  final String name;
  final double amount;
  final DateTime createdAt;
  final String type; 

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.type,
  });
}
