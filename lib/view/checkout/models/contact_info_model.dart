
const String contactInfoFieldName='name';
const String contactInfoFieldPhoneNumber='phone-number';

class ContactInfoModel{
  String? name;
  String? phoneNumber;

  ContactInfoModel({
    this.name,
    this.phoneNumber
  });

  Map<String,dynamic>toMap(){
    return <String,dynamic>{
      contactInfoFieldName:name,
      contactInfoFieldPhoneNumber:phoneNumber,
    };
  }

  factory ContactInfoModel.fromMap(Map<String,dynamic>map)=>ContactInfoModel(
    name: map[contactInfoFieldName],
    phoneNumber: map[contactInfoFieldPhoneNumber],
  );
}