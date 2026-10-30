import '../mixins/loggable.dart';

abstract class Person with Loggable {
  final String id;
  String name;
  int age;

  Person(this.id, this.name, this.age);

  String get role;
  String describe();

  @override
  String toString() => '$role $name (ID: $id)';
}
