import 'person_model.dart';

class FamilyTree {
  final Person person;
  final Person? father;
  final Person? mother;
  final List<Person> spouses;
  final List<Person> children;

  FamilyTree({
    required this.person,
    this.father,
    this.mother,
    required this.spouses,
    required this.children,
  });

  factory FamilyTree.fromJson(Map<String, dynamic> json) {
    return FamilyTree(
      person: Person.fromJson(json['person']),
      father: json['father'] != null ? Person.fromJson(json['father']) : null,
      mother: json['mother'] != null ? Person.fromJson(json['mother']) : null,
      spouses: (json['spouses'] as List).map((i) => Person.fromJson(i)).toList(),
      children: (json['children'] as List).map((i) => Person.fromJson(i)).toList(),
    );
  }
}