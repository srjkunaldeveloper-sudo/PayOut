class BillerModel {
  final String id;
  final String name;
  final String category;

  const BillerModel({required this.id, required this.name, required this.category});

  BillerModel copyWith({String? id, String? name, String? category}) {
    return BillerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'category': category};
  }

  factory BillerModel.fromJson(Map<String, dynamic> json) {
    return BillerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
    );
  }
}

class BillModel {
  final String id;
  final String billerName;
  final String consumerNumber;
  final double amount;
  final String dueDate;
  final String status; // DUE, PAID, OVERDUE
  final String consumerName;
  final String billNumber;
  final String billDate;
  final double lateFee;

  const BillModel({
    required this.id,
    required this.billerName,
    required this.consumerNumber,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.consumerName,
    required this.billNumber,
    required this.billDate,
    required this.lateFee,
  });

  BillModel copyWith({
    String? id,
    String? billerName,
    String? consumerNumber,
    double? amount,
    String? dueDate,
    String? status,
    String? consumerName,
    String? billNumber,
    String? billDate,
    double? lateFee,
  }) {
    return BillModel(
      id: id ?? this.id,
      billerName: billerName ?? this.billerName,
      consumerNumber: consumerNumber ?? this.consumerNumber,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      consumerName: consumerName ?? this.consumerName,
      billNumber: billNumber ?? this.billNumber,
      billDate: billDate ?? this.billDate,
      lateFee: lateFee ?? this.lateFee,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billerName': billerName,
      'consumerNumber': consumerNumber,
      'amount': amount,
      'dueDate': dueDate,
      'status': status,
      'consumerName': consumerName,
      'billNumber': billNumber,
      'billDate': billDate,
      'lateFee': lateFee,
    };
  }

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as String,
      billerName: json['billerName'] as String,
      consumerNumber: json['consumerNumber'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: json['dueDate'] as String,
      status: json['status'] as String,
      consumerName: json['consumerName'] as String? ?? 'Rahul Sharma',
      billNumber: json['billNumber'] as String? ?? 'BILL-999999',
      billDate: json['billDate'] as String? ?? 'Aug 01, 2026',
      lateFee: (json['lateFee'] as num? ?? 0.0).toDouble(),
    );
  }
}
