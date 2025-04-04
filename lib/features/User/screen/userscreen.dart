import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/user_model/user_model.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = FirebaseFirestoreHelper.instance.getUserModelsListFB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;
          users.sort((a, b) => b.timeStampModel.dateAndTime
              .compareTo(a.timeStampModel.dateAndTime));
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: EdgeInsets.all(Dimensions.dimenisonNo8),
                child: ListTile(
                  leading: user.image != null
                      ? Image.network(user.image!)
                      : Icon(Icons.person),
                  title: Text(user.name),
                  subtitle: Text(
                      'Phone: ${user.phone}\nEmail: ${user.email}\nAge: ${user.age ?? 'N/A'}\nGender: ${user.gender ?? 'N/A'}\nDOB: ${user.dateOfBirth != null ? user.dateOfBirth!.toLocal().toString().split(' ')[0] : 'N/A'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
