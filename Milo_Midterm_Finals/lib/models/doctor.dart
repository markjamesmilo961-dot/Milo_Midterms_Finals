import 'appointment.dart';
import 'person.dart';

class Doctor extends Person {
  final String specialty;
  final List<Appointment> appointments = [];

  Doctor(String id, String name, int age, {required this.specialty})
      : super(id, name, age);

  @override
  String get role => 'Doctor';

  bool isAvailable(DateTime time) =>
      !appointments.any((a) => a.isActive && a.time == time);

  @override
  String describe() => '[$id] Dr. $name, $age yrs old | Specialty: $specialty | '
      'Appointments: ${appointments.where((a) => a.isActive).length} active';
}
