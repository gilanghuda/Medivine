import '../entities/doctor.dart';
import '../repositories/doctor_repository.dart';

class GetDoctor {
  final DoctorRepository repository;
  GetDoctor(this.repository);

  Future<List<Doctor>> call() async {
    return await repository.getDoctors();
  }
}
