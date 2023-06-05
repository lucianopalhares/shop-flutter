import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exception.dart';
import '../models/auth.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
  with SingleTickerProviderStateMixin {

  AuthMode _authMode = AuthMode.Login;
  
  Map<String, String> _authData = {
    'email': '', 
    'password': ''
  };

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this, 
      duration: Duration(
        milliseconds: 300
      )
    );

    _opacityAnimation = Tween(
      begin: 0.0, //reverse
      end: 1.0//forward
    ).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.linear
      )
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5), //reverse
      end: Offset(0, 0)//forward
    ).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.linear
      )
    );

    /*_heightAnimation.addListener(() => 
      setState(() {})
    );*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  bool _isLogin() => _authMode == AuthMode.Login;
  //bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
        _controller.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller.reverse();
      }
    });
  }

  Future<void> _submit() async {
    //se o formulario esta validado
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    // pega os dados do form
    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);
    
    void _showErrorDialog(String msg) {
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro'),
          content: Text(msg), 
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Fechar')
            )
          ],
        )
      );
    }

    try {
      if (_isLogin()) {
        await auth.login(
          _authData['email']!, 
          _authData['password']!
        );
      } else {
        await auth.signup(
          _authData['email']!, 
          _authData['password']!
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        //height: _isLogin() ? 310 : 400, 
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
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 100, 
                  maxHeight: _isLogin() ? 0 : 150,
                ),
                duration: Duration(microseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
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
                  ),
                ),
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