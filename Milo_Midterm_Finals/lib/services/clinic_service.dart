import '../exceptions.dart';
import '../mixins/loggable.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import '../models/patient.dart';

class ClinicService with Loggable {
  final List<Patient> _patients = [];
  final List<Doctor> _doctors = [];
  final List<Appointment> _appointments = [];
  int _nextAppointmentId = 1;

  Future<void> loadData() async {
    log('Loading clinic data...');
    await Future.delayed(Duration(seconds: 2));

    _doctors.addAll([
      Doctor('D01', 'Maria Santos', 45, specialty: 'Pediatrics'),
      Doctor('D02', 'Jose Reyes', 52, specialty: 'Cardiology'),
    ]);
    _patients.addAll([
      Patient('P01', 'Juan Dela Cruz', 30, contactNumber: '0917-123-4567'),
      Patient('P02', 'Ana Villanueva', 24, contactNumber: '0918-987-6543'),
    ]);
    log('Loaded ${_doctors.length} doctors and ${_patients.length} patients.');
  }

  Future<Patient> registerPatient(String name, int age, String contact) async {
    log('Registering patient...');
    await Future.delayed(Duration(milliseconds: 800));

    if (name.isEmpty) {
      throw ClinicException('Name cannot be empty.');
    }
    if (age <= 0 || age > 120) {
      throw ClinicException('Age must be between 1 and 120.');
    }
    if (contact.isEmpty) {
      throw ClinicException('Contact number cannot be empty.');
    }

    final id = 'P${(_patients.length + 1).toString().padLeft(2, '0')}';
    final patient = Patient(id, name, age, contactNumber: contact);
    _patients.add(patient);
    log('Registered: ${patient.describe()}');
    return patient;
  }

  Future<Appointment> bookAppointment({
    required String patientId,
    required String doctorId,
    required DateTime time,
  }) async {
    log('Booking appointment...');
    await Future.delayed(Duration(seconds: 1));

    final patient = _findPatient(patientId);
    final doctor = _findDoctor(doctorId);

    if (time.isBefore(DateTime.now())) {
      throw ClinicException('Cannot book an appointment in the past.');
    }
    if (!doctor.isAvailable(time)) {
      throw ClinicException(
          'Dr. ${doctor.name} is already booked at ${Appointment.formatTime(time)}.');
    }

    final appt = Appointment(
      id: 'A${(_nextAppointmentId++).toString().padLeft(3, '0')}',
      patient: patient,
      doctor: doctor,
      time: time,
    );
    _appointments.add(appt);
    patient.appointments.add(appt);
    doctor.appointments.add(appt);
    log('Booked: $appt');
    return appt;
  }

  Future<void> cancelAppointment(String appointmentId) async {
    log('Cancelling $appointmentId...');
    await Future.delayed(Duration(milliseconds: 800));

    final appt = _appointments.firstWhere(
      (a) => a.id == appointmentId,
      orElse: () => throw ClinicException('Appointment $appointmentId not found.'),
    );
    if (!appt.isActive) {
      throw ClinicException('Appointment $appointmentId is already ${appt.status.name}.');
    }
    appt.cancel();
    log('Cancelled: $appt');
  }

  Patient _findPatient(String id) => _patients.firstWhere(
        (p) => p.id == id,
        orElse: () => throw ClinicException('Patient "$id" not found.'),
      );

  Doctor _findDoctor(String id) => _doctors.firstWhere(
        (d) => d.id == id,
        orElse: () => throw ClinicException('Doctor "$id" not found.'),
      );

  void printDirectory() {
    print('--- DOCTORS ---');
    for (final d in _doctors) {
      print(' ${d.describe()}');
    }
    print('\n--- PATIENTS ---');
    for (final p in _patients) {
      print(' ${p.describe()}');
    }
  }

  void printSchedule() {
    print('--- APPOINTMENT SCHEDULE ---');
    if (_appointments.isEmpty) {
      print(' (no appointments yet)');
      return;
    }
    for (final a in _appointments) {
      print(' $a');
    }
  }
}
