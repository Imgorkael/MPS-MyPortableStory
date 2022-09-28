import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mps/components/navigation_drawer.dart';
import 'package:mps/components/theme.dart';
import 'package:mps/pages/curriculum_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mps/components/user.dart';

const _pic3 = "assets/images/logo.jpg";
const pic4 = "assets/images/profilo.jpg";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  UploadTask? uploadTask;
  User? user = FirebaseAuth.instance.currentUser;
  String? imageurl = '';

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

  getImage() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgXFile;
    });
    uploadImage();
  }

  Future uploadImage() async {
    final docUser1 =
        FirebaseFirestore.instance.collection('Users').doc(user!.uid);
    final path = 'files/${imgXFile!.name}';

    final file = File(imgXFile!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDowload = await snapshot.ref.getDownloadURL();

    imageurl = urlDowload;

    docUser1.update({'profilourl': imageurl});

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          resizeToAvoidBottomInset: false,
          drawer: const NavigationDrawer(),
          body: FutureBuilder<Utente?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Stack(children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: boxDecorationBlu(),
                    ),

                    Positioned(
                        left: MediaQuery.of(context).size.width * 0.075,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Image.asset(
                              _pic3,
                            ))),

                    const SizedBox(height: 50),

                    //account image+button

                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.075,
                      top: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            width: 50,
                          ),
                          CircleAvatar(
                            backgroundImage: snapshot.data!.profilourl ==
                                        null &&
                                    imgXFile == null
                                ? const AssetImage(pic4)
                                : snapshot.data!.profilourl == null &&
                                        imgXFile != null
                                    ? Image.file(File(imgXFile!.path)).image
                                    : Image.network(snapshot.data!.profilourl!)
                                        .image,
                            radius: 65,
                          ),
                          Container(
                            height: 130,
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                                onPressed: () {
                                  getImage();
                                },
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 33,
                                )),
                          ),
                        ],
                      ),
                    ),

                    // name field
                    Positioned(
                      height: MediaQuery.of(context).size.height * 0.33,
                      width: MediaQuery.of(context).size.width * 0.8,
                      top: MediaQuery.of(context).size.height * 0.37,
                      left: MediaQuery.of(context).size.width * 0.1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${snapshot.data!.name}  ${snapshot.data!.surname}',
                            style: GoogleFonts.domine(
                                color: Colors.white, fontSize: 30),
                          ),
                          Text(
                            '${snapshot.data!.age}',
                            style: GoogleFonts.domine(
                                color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            '${snapshot.data!.address}',
                            style: GoogleFonts.domine(
                                color: Colors.white, fontSize: 17),
                          ),
                          Text(
                            snapshot.data!.email,
                            style: GoogleFonts.domine(
                                color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            '${snapshot.data!.phoneNumber}',
                            style: GoogleFonts.domine(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.075,
                      top: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 25),
                          ),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CurriculumPage())),
                          child: const Text(
                            'Curriculum',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 25),
                          ),
                          onPressed: () {},
                          child: const Text('References',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 25),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                      child: Container(
                                          width: 200,
                                          height: 200,
                                          color: Colors.white,
                                          child: QrImage(
                                              data:
                                                  snapshot.data!.qrcodeurl!)));
                                });
                          },
                          child: const Text('QR Code',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                    )
                  ]);
                } else {
                  return const Text("Errore");
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );
}
