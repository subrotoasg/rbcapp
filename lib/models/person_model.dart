class Person {
  final String id;
  final String name;
  final String? gender;
  final String? fatherId;
  final String? motherId;
  final List<String>? spouseIds;
  final List<String>? childrenIds;
  final String? mobile;
  final String? whatsapp;
  final String? email;
  final String? occupation;
  final String? bloodGroup;
  final String? dateOfBirth;
  final bool isAlive;
  final String? facebook;      
  final String? dateOfDeath;   
  final String? nid;          
  final String? profileImage;  

  Person({
    required this.id,
    required this.name,
    this.gender,
    this.fatherId,
    this.motherId,
    this.spouseIds,
    this.childrenIds,
    this.mobile,
    this.whatsapp,
    this.email,
    this.occupation,
    this.bloodGroup,
    this.dateOfBirth,
    this.facebook,
    this.dateOfDeath,
    this.nid,
    this.profileImage,
    required this.isAlive,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'],
      name: json['name'],
      gender: json['gender'],
      fatherId: json['fatherId'],
      motherId: json['motherId'],
      spouseIds: List<String>.from(json['spouseIds'] ?? []),
      childrenIds: List<String>.from(json['childrenIds'] ?? []),
      mobile: json['mobile'],
      whatsapp: json['whatsapp'],
      email: json['email'],
      occupation: json['occupation'],
      bloodGroup: json['bloodGroup'],
      dateOfBirth: json['dateOfBirth'],
      isAlive: json['isAlive'] ?? true,
      facebook: json['facebook'],
      dateOfDeath: json['dateOfDeath'],
      nid: json['nid'],
      profileImage: json['profileImage'],
    );
  }
}

