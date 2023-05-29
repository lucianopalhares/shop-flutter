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
  AuthMode _authMode = AuthMode.Login;
  
  Map<String, String> _authData = {
    'email': '', 
    'password': ''
  };

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _submit() {
    //se o formulario esta validado
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    // pega os dados do form
    _formKey.currentState?.save();

    if (_isLogin()) {
      //valida login
    } else {
      //valida registro
    }

    setState(() {
      _isLoading = false;
    });
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
        height: _isLogin() ? 310 : 400, 
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => 
                  _authData['email'] = email ?? '', 
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um email válido';
                  }
                  return null;
                },
              ), 
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha'
                ),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                onSaved: (password) => 
                  _authData['password'] = password ?? '', 
                controller: _passwordController,
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ), 
              if (_isSignup()) 
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirmação de Senha'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
                    ? null 
                    : (_password) {
                    final password = _password ?? '';
                    if (password != _passwordController.text) {
                      return 'Senhas informadas nao conferem';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20,), 
              if (_isLoading) 
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit, 
                  child: Text(
                    _isLogin() ? 'ENTRAR' : 'REGISTRAR'
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
                ), 
              Spacer(), 
              TextButton(
                onPressed: _switchAuthMode, 
                child: Text(
                  _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'
                )
              )
            ],
          )
        ),
      ),
    );
  }
}