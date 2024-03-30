class Patient {
  // VARTIABLES
  // personal info
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? dob;
  String? bloodGroup;
  String? rhFactor;
  // contact
  String? email;
  List<PhoneData>? phone = [];
  List<Map<String, PhoneData>>? emergency;
  // illnesses/allergies
  List<String>? currIllness = [];
  List<String>? prevIllness = [];
  List<String>? allergies = [];
  // medications
  List<String>? currMedications;
  List<String>? prevMedications;

  // CONSTRUCTORS
  Patient();
  // convert patient data to a map
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dob': dob?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'rhFactor': rhFactor,
      'email': email,
      'phone': phone?.map((e) => e.toJson()).toList(),
      'illnessCurr': currIllness ?? [],
      'illnessPrev': prevIllness ?? [],
      'allergies': allergies ?? [],
    };
  }
}
class PhoneData {
  // variables
  String? type;
  String? phoneNumber;
  // convert phone data to a map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'phoneNumber': phoneNumber,
    };
  }
}
