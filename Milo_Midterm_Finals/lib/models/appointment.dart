import 'doctor.dart';
import 'patient.dart';

enum AppointmentStatus { scheduled, completed, cancelled }

class Appointment {
  final String id;
  final Patient patient;
  final Doctor doctor;
  final DateTime time;
  AppointmentStatus status;

  Appointment({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.time,
    this.status = AppointmentStatus.scheduled,
  });

  void cancel() => status = AppointmentStatus.cancelled;
  void complete() => status = AppointmentStatus.completed;

  bool get isActive => status == AppointmentStatus.scheduled;

  static String formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
  }

  @override
  String toString() =>
      '[$id] ${formatTime(time)} | ${patient.name} -> Dr. ${doctor.name} '
      '(${doctor.specialty}) | ${status.name.toUpperCase()}';
}
