import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username = '', _password = '';

  Widget _buildUsername() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Username'),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Username is Required';
        }
        return null;
      },
      onSaved: (String? value) {
        _username = value!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Password is Required';
        }
        return null;
      },
      onSaved: (String? value) {
        _password = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loginaa'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildUsername(),
                      _buildPassword(),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (MediaQuery.of(context).size.width < 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text(
                  'LoginMobile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  print('Username: $_username');
                  print('Password: $_password');
                },
              ),
            )
          else
            ElevatedButton(
              child: Text(
                'LoginWeb',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                print('Username: $_username');
                print('Password: $_password');
              },
            ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}