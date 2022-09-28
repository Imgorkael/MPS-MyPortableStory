import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mps/components/theme.dart';
import 'package:mps/widget/login_widget.dart';

const _pic1 = "assets/images/Rectangle19.jpg";
const _pic2 = "assets/images/icon.jpg";

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool cbState = false;

  final _focusNodeEmail = FocusNode();
  final _focusNodePassword = FocusNode();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String password = '';
  String errorMessage = '';
  bool isPasswordVisible = false;

  Future signIn() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.setPersistence(Persistence.LOCAL);
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
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
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: Container(
              alignment: Alignment.center,
              decoration: boxDecorationBlu(),
              child: Stack(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  decoration: boxDecorationBlu(),
                ),
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
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.asset(
                        _pic1,
                      ),
                    )),
                Positioned(
                    left: MediaQuery.of(context).size.width * 0.075,
                    top: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //Email Field

                          TextFormField(
                            controller: emailController,
                            focusNode: _focusNodeEmail,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: ('Email'),
                              suffixIcon: Icon(Icons.mail_outline_rounded),
                              border: OutlineInputBorder(),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.email(),
                              FormBuilderValidators.required(),
                            ]),
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.008,
                          ),
                          // Password Field

                          TextFormField(
                            controller: passwordController,
                            focusNode: _focusNodePassword,
                            obscureText: isPasswordVisible,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: ('Password'),
                              suffixIcon: IconButton(
                                icon: isPasswordVisible
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                                onPressed: () => setState(() =>
                                    isPasswordVisible = !isPasswordVisible),
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),

                            /*onSubmitted: (_) {
                                    signIn();
                                  },*/
                            textInputAction: TextInputAction.go,
                          ),

                          // checkbox
                          Row(children: <Widget>[
                            Checkbox(
                                fillColor: const MaterialStatePropertyAll(
                                    Color.fromARGB(255, 3, 107, 185)),
                                tristate: false,
                                value: cbState,
                                onChanged: (v) {
                                  setState(() => cbState = v!);
                                }),
                            const Text(
                              'Remember password',
                              style: TextStyle(
                                color: Color.fromARGB(255, 3, 107, 185),
                                fontSize: 16,
                              ),
                            )
                          ]),

                          //erroMEssage
                          showAlert(),

                          //forgotpass
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.5),
                            child: forgetPassButton(context),
                          ),

                          //login and register button

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(27),
                                      ),
                                      elevation: 5,
                                      fixedSize: const Size(151, 45)),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      signIn();
                                    }
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                registerEleButton(context),
                              ]),

                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.height * 0.05,
                          )
                        ],
                      ),
                    )),

                //bottom Image

                Positioned(
                  top: MediaQuery.of(context).size.height * 0.77,
                  left: MediaQuery.of(context).size.width * 0.39,
                  child: Image.asset(
                    _pic2,
                  ),
                ),
              ]),
            ))));
  }
}
