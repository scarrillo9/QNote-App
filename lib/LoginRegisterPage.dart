import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BaseAuth.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => _LoginRegisterPage();
}

class _LoginRegisterPage extends State<LoginRegisterPage> {
  final _formKey = new GlobalKey<FormState>();

  String _username;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("QNote"),
      ),
      body: Stack(
        children: <Widget>[
          _buildForm(),
          _showCircularProgress(),
        ],
      )
    );
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if(_validateAndSave()) {
      String userId = "";
      try {
        if(_isLoginForm) {
          userId = await widget.auth.signIn(_username, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_username, _password);
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if(userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch(e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void _toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildLogo(),
            _buildUsernameField(),
            _buildPasswordField(),
            _buildLoginButton(),
            _buildRegisterButton(),
            _showErrorMessage(),
          ],
        )
      )
    );
  }

  Widget _buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Username',
          icon: Icon(
              Icons.mail,
              color: Colors.grey
          )
        ),
        validator: (value) => value.isEmpty ? "Email can't be empty" : null,
        onSaved: (value) => _username = value.trim(),
      )
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.grey
          )
        ),
        validator: (value) => value.isEmpty ? "Password can't be empty" : null,
        onSaved: (value) => _password = value.trim(),
      )
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: SizedBox(
        height: 40,
        child: RaisedButton(
          elevation: 5,
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          color: Colors.blue,
          child: Text(_isLoginForm ? 'Login' : 'Create account',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white
            ),
          ),
          onPressed: _validateAndSubmit,
        )
      )
    );
  }

  Widget _buildRegisterButton() {
    return FlatButton(
      child: Text(
        _isLoginForm ? 'Register' : 'Have an account? Sign in',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)
      ),
      onPressed: _toggleFormMode,
    );
  }

  Widget _showCircularProgress() {
    if(_isLoading) {
      return Center(
        child: CircularProgressIndicator()
      );
    }
    return Container(
        height: 0,
        width: 0
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13,
          color: Colors.red,
          height: 1,
          fontWeight: FontWeight.w300
        )
      );
    } else {
      return Container(
        height: 0
      );
    }
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48,
          child: Icon(Icons.airplay)
        )
      )
    );
  }
}