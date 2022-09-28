import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mps/components/user.dart';
import 'package:mps/pages/home_page.dart';

Widget buildHeader(BuildContext context) {
  Future<Utente?> readUser() async {
    User user = FirebaseAuth.instance.currentUser!;

    final docUser2 =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    final snapshot = await docUser2.get();

    if (snapshot.data() != null) {
      return Utente.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  return FutureBuilder<Utente?>(
      future: readUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Container(
              color: const Color.fromARGB(255, 3, 107, 185),
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 24,
              ),
              child: Column(children: <Widget>[
                CircleAvatar(
                  radius: 52,
                  backgroundImage: snapshot.data!.profilourl == null
                      ? const AssetImage(pic4)
                      : Image.network(snapshot.data!.profilourl!).image,
                ),
                const SizedBox(height: 12),
                Text(
                  '${snapshot.data!.name} ${snapshot.data!.surname}',
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text(
                  snapshot.data!.email,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ]),
            );
          } else {
            return const Text("Errore");
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      });
}

Widget buildMenuItems(BuildContext context) => Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        const Divider(
          color: Colors.blueGrey,
        ),
        const SizedBox(
          height: 415,
        ),
        const Divider(
          color: Colors.blueGrey,
        ),
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            })
      ],
    );
