import 'package:flutter/material.dart';
import 'package:mps/pages/register_page.dart';

Widget forgetPassButton(BuildContext context) => TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 14),
      ),
      onPressed: () {},
      child: const Text('Forget Password'),
    );

Widget registerEleButton(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 5,
          fixedSize: const Size(151, 45)),
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const RegisterPage())),
      child: const Text(
        'Register',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
