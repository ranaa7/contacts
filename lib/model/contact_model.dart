import '../dbhelper/constant.dart';

class ContactModel{
    int? id;
    String name;
    String email;
    String phone;

    ContactModel({this.id, required this.name, required this.email, required this.phone});

  Map<String, dynamic> toMap(){
    return {
      columnName: name,
      columnEmail: email,
      columnPhone: phone
    };
  }

   factory ContactModel.fromMap(Map<String, dynamic> map){  //est5dmna factory ashan el constructor mynf3sh y5od return w da named constructor
    return ContactModel(
      id: map[columnId],
      name: map[columnName],
      email: map[columnEmail],
      phone: map[columnPhone]
    );
  }

}