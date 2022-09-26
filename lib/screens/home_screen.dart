
import 'package:flutter/material.dart';


import '../dbhelper/database_helper.dart';
import '../model/contact_model.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String email ="" ;
  String phone = "";

  bool flag = false;

  List<ContactModel> contactList = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Contact'),
        centerTitle: true,
      ),
      body:  FutureBuilder(
          future: getContactList(),
          builder: (context, snapshot) {
            return createListView(context, snapshot);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
               openAlterDialog(null);
        },
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {

    contactList = snapshot.data ?? [];



    if (contactList !=[]) {
      return ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            return Dismissible(   //hya el widget ely bt3ml swap ymen aw shmal
                key: UniqueKey(),
                onDismissed: (direction) {
                  DataBaseHelper helper =DataBaseHelper();
                  helper.deleteContact(contactList[index].id!);
                },
                background: Container(
                  color: Colors.red,
                ),
                child: buildItem(contactList[index], index));
          });
    } else {
      return Container();
    }
  }

  buildItem(ContactModel noteModel,int index) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(
          noteModel.name.toString(),
          style: TextStyle(fontSize: 25 ,fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noteModel.phone.toString(),
              style: TextStyle(fontSize: 20),
            ),
            Text(
              noteModel.email.toString(),
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.indigo,
          child: Text(noteModel.name.substring(0,1).toUpperCase()),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
                  openAlterDialog(noteModel);
          },
        ),
      ),
    );
  }


    openAlterDialog(ContactModel? contactModel) {
    if (contactModel != null) {
      name = contactModel.name;
      email = contactModel.email;
      phone = contactModel.phone;
      flag = true;
    } else {
      name = '';
      email = '';
      phone = '';
      flag = false;

    }

    showDialog(
     context: context,
     builder:(context) {
     return AlertDialog(
        content: Container(
          height: 250,
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text('contact',style: TextStyle(fontSize: 20),),
                TextFormField(
                  initialValue: name,
                  onSaved: (value) {
                    name = value!;
                  },
                  decoration: InputDecoration(hintText: 'name'),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: phone.toString(),
                  onSaved: (value ) {
                    phone = value! ;
                  },
                  decoration: InputDecoration(hintText: 'phone',),

                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  initialValue: email,
                  onSaved: (value ) {
                    email = (value!) ;
                  },
                  decoration: InputDecoration(hintText: 'phone',),

                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        flag  ? editContact(contactModel!.id) : addContact();
                      },
                      child: Text(flag ? 'edit' : 'save')),
                )
              ],
            ),
          ),
        ),
     );
     }
   );
  }


  Future<List<ContactModel>> getContactList() async {

    var db = DataBaseHelper();
    await db.getAllContact().then((value) {
      print(value);
      contactList = value;
    });

    return  contactList;
  }

  void addContact() {
    _formKey.currentState!.save();
    var db = DataBaseHelper();
    db
        .insertContact(ContactModel(
            name: name,
            phone: phone,
            email: email,
            ))
        .then((value) {
      print(value);
      print("inserted");
      Navigator.of(context).pop();
      setState(() {});
    });
  }

  void editContact(int? id) {
    _formKey.currentState!.save();

    var db = DataBaseHelper();
    ContactModel noteModel = ContactModel(
        id: id,
        name: name,
        phone: phone,
        email: email,
    );

    db.updateContact(noteModel)
        .then((value) {
      print(value);
      print("edited");
      Navigator.pop(context);
      setState(() {
        flag = false;
      });
    });
  }


}

