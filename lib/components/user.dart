// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Utente {
  final String? id;
  final String name;
  final String surname;
  final String email;
  final String? age;
  final String? gender;
  final String? address;
  final String? phoneNumber;
  final String? qrcodeurl;
  final String? profilourl;
  Utente({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.age,
    this.gender,
    this.address,
    this.phoneNumber,
    this.qrcodeurl,
    this.profilourl,
  });

  Utente copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    String? age,
    String? gender,
    String? address,
    String? phoneNumber,
    String? qrcodeurl,
    String? profilourl,
  }) {
    return Utente(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      qrcodeurl: qrcodeurl ?? this.qrcodeurl,
      profilourl: profilourl ?? this.profilourl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'age': age,
      'gender': gender,
      'address': address,
      'phoneNumber': phoneNumber,
      'qrcodeurl': qrcodeurl,
      'profilourl': profilourl,
    };
  }

  factory Utente.fromMap(Map<String, dynamic> map) {
    return Utente(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      surname: map['surname'] as String,
      email: map['email'] as String,
      age: map['age'] != null ? map['age'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      qrcodeurl: map['qrcodeurl'] != null ? map['qrcodeurl'] as String : null,
      profilourl:
          map['profilourl'] != null ? map['profilourl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Utente.fromJson(String source) =>
      Utente.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Utente(id: $id, name: $name, surname: $surname, email: $email, age: $age, gender: $gender, address: $address, phoneNumber: $phoneNumber, qrcodeurl: $qrcodeurl, profilourl: $profilourl)';
  }

  @override
  bool operator ==(covariant Utente other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.surname == surname &&
        other.email == email &&
        other.age == age &&
        other.gender == gender &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        other.qrcodeurl == qrcodeurl &&
        other.profilourl == profilourl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        email.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode ^
        qrcodeurl.hashCode ^
        profilourl.hashCode;
  }
}
