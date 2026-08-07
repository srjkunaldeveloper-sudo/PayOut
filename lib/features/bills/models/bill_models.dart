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

  const BillModel({
    required this.id,
    required this.billerName,
    required this.consumerNumber,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  BillModel copyWith({
    String? id,
    String? billerName,
    String? consumerNumber,
    double? amount,
    String? dueDate,
    String? status,
  }) {
    return BillModel(
      id: id ?? this.id,
      billerName: billerName ?? this.billerName,
      consumerNumber: consumerNumber ?? this.consumerNumber,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
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
    );
  }
}
