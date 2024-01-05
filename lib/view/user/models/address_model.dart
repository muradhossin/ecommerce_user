
const String addressFieldAddressLine1='address';
const String addressFieldCity='city';
const String addressFieldZipcode='zipcode';

class AddressModel{
  String? address;
  String? city;
  String? zipcode;

  AddressModel({
    this.address,
    this.city,
    this.zipcode
  });

  Map<String,dynamic>toMap(){
    return <String,dynamic>{
      addressFieldAddressLine1:address,
      addressFieldCity:city,
      addressFieldZipcode:zipcode,
    };
  }

  factory AddressModel.fromMap(Map<String,dynamic>map)=>AddressModel(
    address: map[addressFieldAddressLine1],
    city: map[addressFieldCity],
    zipcode: map[addressFieldZipcode],
  );
}