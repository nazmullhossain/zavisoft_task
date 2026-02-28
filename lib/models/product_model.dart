import 'dart:convert';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'].toDouble(),
      count: json['count'],
    );
  }
}

class User {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final Address address;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['name']['firstname'],
      lastName: json['name']['lastname'],
      phone: json['phone'],
      address: Address.fromJson(json['address']),
    );
  }

  @override
  String toString() {
    return 'User: $firstName $lastName, Email: $email';
  }
}

class Address {
  final String city;
  final String street;
  final int number;
  final String zipcode;

  Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      street: json['street'],
      number: json['number'],
      zipcode: json['zipcode'],
    );
  }
}