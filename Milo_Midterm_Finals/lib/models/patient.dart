import 'appointment.dart';
import 'person.dart';

class Patient extends Person {
  final String contactNumber;
  final List<Appointment> appointments = [];

  Patient(String id, String name, int age, {required this.contactNumber})
      : super(id, name, age);

  @override
  String get role => 'Patient';

  @override
  String describe() => '[$id] $name, $age yrs old | Contact: $contactNumber | '
      'Appointments: ${appointments.where((a) => a.isActive).length} active';
}
