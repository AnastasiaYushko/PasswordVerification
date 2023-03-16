import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/provider/MwProvider.dart';
import '../models/PasswordVerificationData.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool isPasswordVisible = true;
  bool isRepeatPasswordVisible = true;
  Future<PasswordVerificationData>? futurePasswordVerificationData;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  TextFormField _passwordFormField() {
    return TextFormField(
        controller: _passwordController,
        obscureText: isPasswordVisible,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(40),
        ],
        decoration: const InputDecoration(labelText: "Введите пароль"));
  }

  TextFormField _repeatPasswordFormField() {
    return TextFormField(
        controller: _repeatPasswordController,
        obscureText: isRepeatPasswordVisible,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(40),
        ],
        decoration: const InputDecoration(labelText: "Подтвердите пароль"));
  }

  Widget _wrapper(Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      _wrapper(_passwordFormField()),
                      const SizedBox(height: 6),
                      _wrapper(_repeatPasswordFormField()),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_passwordController.text ==
                            _repeatPasswordController.text &&
                        await passwordVerification(_passwordController) &&
                        await passwordVerification(_repeatPasswordController)) {
                      Widget okButton = TextButton(
                        child: const Text("OK"),
                        onPressed: () {},
                      );

                      AlertDialog alert = AlertDialog(
                        title: const Text("Оповещение"),
                        content: const Text("Все ОК!"),
                        actions: [
                          okButton,
                        ],
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    } else {
                      Widget okButton = TextButton(
                        child: const Text("ОК"),
                        onPressed: () {},
                      );

                      AlertDialog alert = AlertDialog(
                        title: const Text("Оповещение"),
                        content: const Text("Все не ок!"),
                        actions: [
                          okButton,
                        ],
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  },
                  child: const Text('Проверить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> passwordVerification(TextEditingController password) async {
  Future<PasswordVerificationData> checkPass = MwProvider().getPasswordData();

  String maskPass = await checkPass.then((value) => value.passwordMask);
  int len = await checkPass.then((value) => value.lengthPassword);

  var array = maskPass.split('');
  for (var element in array) {
    if (!password.text.contains(element)) {
      return false;
    }
  }

  if (password.text.length >= len) {
    return true;
  }

  return false;
}

