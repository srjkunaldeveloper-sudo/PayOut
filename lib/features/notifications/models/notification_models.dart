class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String category; // Payment, Security, Offers, Recharge, Bills, etc.
  final String time;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.time,
    required this.isRead,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? time,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'time': time,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      time: json['time'] as String,
      isRead: json['isRead'] as bool,
    );
  }
}

class NotificationCategoryModel {
  final String name;
  final String code;

  const NotificationCategoryModel({required this.name, required this.code});
}

class NotificationActionModel {
  final String actionLabel;
  final String actionRoute;

  const NotificationActionModel({required this.actionLabel, required this.actionRoute});
}

class NotificationPreferenceModel {
  final bool enablePush;
  final bool enableEmail;

  const NotificationPreferenceModel({required this.enablePush, required this.enableEmail});
}
