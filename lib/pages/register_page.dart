import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mps/components/user.dart';
import 'package:mps/components/theme.dart';
import 'package:mps/pages/curriculum_page.dart';

const _pic2 = "assets/images/icon.jpg";
final docUser = FirebaseFirestore.instance.collection('Users').doc();

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();

  bool isPasswordVisible = false;
  dynamic passwordmatch;
  String errorMessage = '';

  Future signUp(Utente user) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(value.user!.uid)
            .set(user.toMap());
      }).then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CurriculumPage())));
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        errorMessage = e.message!;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget showAlert() {
    // ignore: unnecessary_null_comparison
    if (errorMessage != null && errorMessage != '') {
      return Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width * 0.93,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
        child: Row(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03),
            child: const Icon(Icons.error_outline),
          ),
          Expanded(
            child: Text(
              errorMessage,
              maxLines: 3,
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  errorMessage = '';
                });
              },
            ),
          )
        ]),
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            decoration: boxDecorationBlu(),
            child: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.04,
                        MediaQuery.of(context).size.height * 0.02,
                        MediaQuery.of(context).size.width * 0.04,
                        MediaQuery.of(context).size.height * 0.02),
                    width: MediaQuery.of(context).size.width * 0.93,
                    height: MediaQuery.of(context).size.height * 0.93,
                    decoration: boxDecorationBianco()),

                //top image

                Positioned(
                    top: MediaQuery.of(context).size.height * 0.075,
                    left: MediaQuery.of(context).size.width * 0.075,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image.asset(
                          _pic2,
                        ))),

                //colonna campi

                Positioned(
                    left: MediaQuery.of(context).size.width * 0.075,
                    top: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //errorMessage

                          showAlert(),

                          //first name

                          TextFormField(
                              controller: nameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z]'))
                              ],
                              textInputAction: TextInputAction.done,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: ('First name'),
                                suffixIcon: Icon(Icons.person_rounded),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.maxLength(20),
                                FormBuilderValidators.required(),
                              ])),

                          // second name

                          TextFormField(
                              controller: surnameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z]'))
                              ],
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: ('Second name'),
                                suffixIcon: Icon(Icons.people),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.maxLength(20),
                                FormBuilderValidators.required(),
                              ])),

                          //email

                          TextFormField(
                              controller: emailController,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.mail_outline_rounded),
                                border: OutlineInputBorder(),
                                labelText: ('Email'),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.email(),
                                FormBuilderValidators.required(),
                              ])),

                          //password

                          TextFormField(
                              controller: passwordController,
                              obscureText: isPasswordVisible,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: isPasswordVisible
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onPressed: () => setState(() =>
                                      isPasswordVisible = !isPasswordVisible),
                                ),
                                labelText: ('Password'),
                                border: const OutlineInputBorder(),
                              ),
                              validator: FormBuilderValidators.compose([
                                (value) {
                                  passwordmatch = value;
                                  return null;
                                },
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(5),
                              ])),

                          //repeat password

                          TextFormField(
                              obscureText: isPasswordVisible,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: isPasswordVisible
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onPressed: () => setState(() =>
                                      isPasswordVisible = !isPasswordVisible),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: ('Repeat Password'),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                ((value) {
                                  if (value != passwordmatch) {
                                    return 'Passwords do not match ';
                                  }
                                  return null;
                                })
                              ])),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),

                          //registerbutton
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                  elevation: 5,
                                  fixedSize: const Size(151, 45)),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                final isValidForm =
                                    formKey.currentState!.validate();
                                if (isValidForm) {
                                  final user = Utente(
                                    name: nameController.text,
                                    surname: surnameController.text,
                                    email: emailController.text,
                                  );
                                  signUp(user);
                                }
                              }),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ],
                      ),
                    )),

                //bottom Image
              ],
            ),
          ),
        ),
      ),
    );
  }
}
