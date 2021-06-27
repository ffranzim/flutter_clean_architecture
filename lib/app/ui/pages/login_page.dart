import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            child: Image(image: AssetImage('lib/app/ui/assets/logo.png')),
          ),
          Text('login'.toUpperCase()),
          Form(
              child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  icon: Icon(Icons.lock),
                ),
                // obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              ElevatedButton(
                onPressed: () => print('ElevatedButton'),
                child: Text('Entrar'.toUpperCase()),
              ),
              TextButton.icon(onPressed: () => print('TextButton'),
                icon:  Icon(Icons.person),
                label: Text('Criar Conta'),
              )
            ],
          ))
        ],
      )),
    );
  }
}
