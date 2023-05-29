import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.Signup;

  void _submit() {

  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10) 
      ),
      child: Container(
        height: 320, 
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
                keyboardType: TextInputType.emailAddress,
              ), 
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha'
                ),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
              ), 
              if (_authMode == AuthMode.Signup) 
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirmação de Senha'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                ),
              SizedBox(height: 20,), 
              ElevatedButton(
                onPressed: _submit, 
                child: Text(
                  _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'
                ), 
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ), 
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30, 
                    vertical: 8
                  )
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}