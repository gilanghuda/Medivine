import '../../domain/entities/doctor.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../datasources/doctor_service.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorService service;
  DoctorRepositoryImpl(this.service);

  @override
  Future<List<Doctor>> getDoctors() async {
    final models = await service.fetchDoctors();
    return models.map((m) => m.toEntity()).toList();
  }
}
