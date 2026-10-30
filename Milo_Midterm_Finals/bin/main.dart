import 'dart:io';

import 'package:clinic_tracker/exceptions.dart';
import 'package:clinic_tracker/services/clinic_service.dart';

void clearScreen() {
  stdout.write('\x1B[2J\x1B[3J\x1B[H');
}

String ask(String prompt) {
  stdout.write(prompt);
  return (stdin.readLineSync() ?? '').trim();
}

void pause() {
  ask('\nPress Enter to continue...');
}

void header(String title) {
  clearScreen();
  print('==================================');
  print('   CLINIC APPOINTMENT TRACKER');
  print('==================================');
  print('   $title\n');
}

Future<void> main() async {
  final clinic = ClinicService();

  clearScreen();
  try {
    await clinic.loadData();
  } catch (e) {
    print('Failed to load data: $e');
    return;
  }
  pause();

  var running = true;

  while (running) {
    header('MAIN MENU');
    print(' 1. View doctors and patients');
    print(' 2. Register new patient');
    print(' 3. Book appointment');
    print(' 4. Cancel appointment');
    print(' 5. View appointment schedule');
    print(' 0. Exit');
    final choice = ask('\nChoose an option: ');

    try {
      switch (choice) {
        case '1':
          header('DOCTORS AND PATIENTS');
          clinic.printDirectory();
          break;

        case '2':
          header('REGISTER NEW PATIENT');
          final name = ask('Full name: ');
          final age = int.tryParse(ask('Age: '));
          final contact = ask('Contact number: ');
          if (age == null) {
            throw ClinicException('Age must be a number.');
          }
          final patient = await clinic.registerPatient(name, age, contact);
          print('\nSuccess! Patient registered with ID ${patient.id}.');
          break;

        case '3':
          header('BOOK APPOINTMENT');
          clinic.printDirectory();
          final patientId = ask('\nPatient ID (e.g. P01): ').toUpperCase();
          final doctorId = ask('Doctor ID (e.g. D01): ').toUpperCase();
          final date = ask('Date (YYYY-MM-DD): ');
          final time = ask('Time (HH:MM, 24-hour): ');
          final when = DateTime.tryParse('$date $time');
          if (when == null) {
            throw ClinicException('Invalid date or time format.');
          }
          final appt = await clinic.bookAppointment(
            patientId: patientId,
            doctorId: doctorId,
            time: when,
          );
          print('\nSuccess! $appt');
          break;

        case '4':
          header('CANCEL APPOINTMENT');
          clinic.printSchedule();
          final id = ask('\nAppointment ID to cancel (e.g. A001): ').toUpperCase();
          await clinic.cancelAppointment(id);
          print('\nAppointment $id cancelled.');
          break;

        case '5':
          header('APPOINTMENT SCHEDULE');
          clinic.printSchedule();
          break;

        case '0':
          running = false;
          clearScreen();
          print('Thank you for using the Clinic Appointment Tracker. Goodbye!');
          break;

        default:
          print('\nInvalid option. Please choose 0-5.');
      }
    } on ClinicException catch (e) {
      print('\nError: ${e.message}');
    } catch (e) {
      print('\nUnexpected error: $e');
    }

    if (running) {
      pause();
    }
  }
}
