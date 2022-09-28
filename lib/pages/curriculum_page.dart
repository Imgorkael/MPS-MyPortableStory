import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mps/components/theme.dart';
import 'package:mps/components/user.dart';
import 'package:mps/pages/home_page.dart';
import 'dart:io';

class CurriculumPage extends StatefulWidget {
  const CurriculumPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  final formKey = GlobalKey<FormState>();
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  UploadTask? uploadTask;

  final addressController = TextEditingController();
  final phonenumberController = TextEditingController();
  final ageController = TextEditingController();
  String? valueChoose;
  List<String> items = ['M', 'F'];
  String dropdownValue = 'M';
  User? user = FirebaseAuth.instance.currentUser;
  String? imageurl = '';
  Future<Utente?> readUser() async {
    final docUser2 =
        FirebaseFirestore.instance.collection('Users').doc(user?.uid);
    final snapshot = await docUser2.get();
    if (snapshot.data()!.isNotEmpty) {
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
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<Utente?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 23),
                    decoration: boxDecorationBlu(),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.15,
                      left: MediaQuery.of(context).size.width * 0.34,
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: CircleAvatar(
                            radius: 65,
                            backgroundImage: snapshot.data!.profilourl ==
                                        null &&
                                    imgXFile == null
                                ? const AssetImage(pic4)
                                : snapshot.data!.profilourl == null &&
                                        imgXFile != null
                                    ? Image.file(File(imgXFile!.path)).image
                                    : Image.network(snapshot.data!.profilourl!)
                                        .image),
                      )),
                  Positioned(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.8,
                      top: MediaQuery.of(context).size.height * 0.25,
                      left: MediaQuery.of(context).size.width * 0.1,
                      child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //name
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                        initialValue: snapshot.data!.name,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[a-zA-Z]'))
                                        ],
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.maxLength(15,
                                              errorText: 'Max lenght'),
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "This field cannot be empty"),
                                        ]),
                                        textAlign: TextAlign.left,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color.fromARGB(
                                                255, 234, 220, 220),
                                            hintText: ('First name'),
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20)))),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),

                                  //age

                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                        controller: ageController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]'))
                                        ],
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.maxLength(2,
                                              errorText: 'Max lenght'),
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "This field cannot be empty"),
                                          FormBuilderValidators.numeric(
                                              errorText: 'Invalid number'),
                                          FormBuilderValidators.min(18,
                                              errorText: 'Invalid number')
                                        ]),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 2,
                                        decoration: InputDecoration(
                                            counterText: '',
                                            filled: true,
                                            fillColor: const Color.fromARGB(
                                                255, 234, 220, 220),
                                            hintText: ('Age'),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20)))),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // surname

                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                        initialValue: snapshot.data!.surname,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[a-zA-Z]'))
                                        ],
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.maxLength(15,
                                              errorText: 'Max lenght'),
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "This field cannot be empty"),
                                        ]),
                                        textAlign: TextAlign.left,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color.fromARGB(
                                                255, 234, 220, 220),
                                            hintText: ('Second name'),
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20)))),
                                  ),

                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),

                                  //gender

                                  Expanded(
                                    flex: 1,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 234, 220, 220),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none)),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValue = newValue!;
                                            });
                                          },
                                          value: dropdownValue,
                                          items: items
                                              .map<DropdownMenuItem<String>>(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            },
                                          ).toList(),
                                        )),
                                  ),
                                ],
                              ),

                              //email

                              TextFormField(
                                initialValue: snapshot.data!.email,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    suffixIcon:
                                        const Icon(Icons.mail_outline_rounded),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 234, 220, 220),
                                    hintText: ('Email'),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.email(
                                      errorText: 'Invalid email'),
                                  FormBuilderValidators.required(
                                      errorText: 'Empty field')
                                ]),
                              ),

                              //address

                              TextFormField(
                                controller: addressController,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.streetAddress,
                                decoration: InputDecoration(
                                    suffixIcon: const Icon(Icons.home_rounded),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 234, 220, 220),
                                    hintText: ('Address'),
                                    helperText:
                                        ('Ex. Via Roncagli 10, 10100 Torino TO'),
                                    helperStyle:
                                        const TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'Empty field')
                                ]),
                              ),

                              //phonenumber

                              TextFormField(
                                controller: phonenumberController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    suffixIcon: const Icon(Icons.phone_rounded),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 234, 220, 220),
                                    hintText: ('Phone number'),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(
                                      errorText: 'Invalid number'),
                                  FormBuilderValidators.required(
                                      errorText: 'Empty field')
                                ]),
                              ),
                            ],
                          ))),
                  Positioned(
                      left: MediaQuery.of(context).size.width * 0.15,
                      top: MediaQuery.of(context).size.width * 1.7,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.30,
                        child: IconButton(
                            padding: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.035),
                            color: const Color.fromARGB(255, 3, 107, 185),
                            alignment: Alignment.center,
                            iconSize: MediaQuery.of(context).size.width * 0.2,
                            icon: const Icon(
                              Icons.arrow_circle_right_rounded,
                              color: Color.fromARGB(255, 234, 220, 220),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(), elevation: 5),
                            onPressed: () async {
                              String? flag = snapshot.data!.age;
                              final isValidForm =
                                  formKey.currentState!.validate();
                              if (isValidForm) {
                                final docUser1 = FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user!.uid);

                                docUser1.update({'age': ageController.text});
                                docUser1.update({'gender': dropdownValue});
                                docUser1.update(
                                    {'address': addressController.text});
                                docUser1.update({
                                  'phoneNumber': phonenumberController.text
                                });
                                docUser1.update({
                                  'qrcodeurl':
                                      "https://firebasestorage.googleapis.com/v0/b/my-portable-story.appspot.com/o/png2pdf.pdf?alt=media&token=4bcd0ebd-da75-406f-978e-40ef278eae02"
                                });

                                if (flag == null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()),
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                }
                              }
                            }),
                      )),
                ]);
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}
