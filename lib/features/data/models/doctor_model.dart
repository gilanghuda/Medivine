import '../../domain/entities/doctor.dart';

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String experience;
  final String rating;
  final String price;
  final String image;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.price,
    required this.image,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json, String id) {
    return DoctorModel(
      id: id,
      name: json['name'],
      specialty: json['specialty'],
      experience: json['experience'],
      rating: json['rating'],
      price: json['price'],
      image: json['image'],
    );
  }

  Doctor toEntity() {
    return Doctor(
      id: id,
      name: name,
      specialty: specialty,
      experience: experience,
      rating: rating,
      price: price,
      image: image,
    );
  }
}
