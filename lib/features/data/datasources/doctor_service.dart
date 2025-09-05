import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';

class DoctorService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<List<DoctorModel>> fetchDoctors() async {
    final query = await _usersRef.where('role', isEqualTo: 'doctor').get();
    return query.docs.map((doc) {
      final data = doc.data();
      return DoctorModel(
        id: doc.id,
        name: data['name'] ?? '',
        specialty: data['specialty'] ?? '',
        experience: data['experience'] ?? '',
        rating: (data['rating'] ?? '').toString(),
        price: data['price'] ?? '',
        image: data['image'] ?? '',
      );
    }).toList();
  }
}
