class FlightModel {
  final String id;
  final String airline;
  final String flightNumber;
  final String from;
  final String to;
  final double price;

  const FlightModel({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.from,
    required this.to,
    required this.price,
  });

  FlightModel copyWith({
    String? id,
    String? airline,
    String? flightNumber,
    String? from,
    String? to,
    double? price,
  }) {
    return FlightModel(
      id: id ?? this.id,
      airline: airline ?? this.airline,
      flightNumber: flightNumber ?? this.flightNumber,
      from: from ?? this.from,
      to: to ?? this.to,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline': airline,
      'flightNumber': flightNumber,
      'from': from,
      'to': to,
      'price': price,
    };
  }

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] as String,
      airline: json['airline'] as String,
      flightNumber: json['flightNumber'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class TrainModel {
  final String id;
  final String trainName;
  final String trainNumber;
  final String from;
  final String to;
  final double price;

  const TrainModel({
    required this.id,
    required this.trainName,
    required this.trainNumber,
    required this.from,
    required this.to,
    required this.price,
  });

  TrainModel copyWith({
    String? id,
    String? trainName,
    String? trainNumber,
    String? from,
    String? to,
    double? price,
  }) {
    return TrainModel(
      id: id ?? this.id,
      trainName: trainName ?? this.trainName,
      trainNumber: trainNumber ?? this.trainNumber,
      from: from ?? this.from,
      to: to ?? this.to,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trainName': trainName,
      'trainNumber': trainNumber,
      'from': from,
      'to': to,
      'price': price,
    };
  }

  factory TrainModel.fromJson(Map<String, dynamic> json) {
    return TrainModel(
      id: json['id'] as String,
      trainName: json['trainName'] as String,
      trainNumber: json['trainNumber'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class BusModel {
  final String id;
  final String operatorName;
  final String from;
  final String to;
  final double price;

  const BusModel({
    required this.id,
    required this.operatorName,
    required this.from,
    required this.to,
    required this.price,
  });

  BusModel copyWith({
    String? id,
    String? operatorName,
    String? from,
    String? to,
    double? price,
  }) {
    return BusModel(
      id: id ?? this.id,
      operatorName: operatorName ?? this.operatorName,
      from: from ?? this.from,
      to: to ?? this.to,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operatorName': operatorName,
      'from': from,
      'to': to,
      'price': price,
    };
  }

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json['id'] as String,
      operatorName: json['operatorName'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class HotelModel {
  final String id;
  final String name;
  final String location;
  final double pricePerNight;
  final double rating;

  const HotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerNight,
    required this.rating,
  });

  HotelModel copyWith({
    String? id,
    String? name,
    String? location,
    double? pricePerNight,
    double? rating,
  }) {
    return HotelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'pricePerNight': pricePerNight,
      'rating': rating,
    };
  }

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

class MovieModel {
  final String id;
  final String title;
  final String genre;
  final double pricePerSeat;

  const MovieModel({
    required this.id,
    required this.title,
    required this.genre,
    required this.pricePerSeat,
  });

  MovieModel copyWith({
    String? id,
    String? title,
    String? genre,
    double? pricePerSeat,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'pricePerSeat': pricePerSeat,
    };
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      genre: json['genre'] as String,
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
    );
  }
}
