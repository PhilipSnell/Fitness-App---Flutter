import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xcell/login/sbloc/signup_bloc.dart';
import 'package:xcell/theme/style.dart';
import 'dart:convert';

class SignupForm extends StatefulWidget {
  const SignupForm({Key key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onSignupButtonPressed() {
      BlocProvider.of<SignupBloc>(context).add(SignupButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,

      ));

    }
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
           print("message");
           String error = state.error.replaceAll("Exception: ", "");
           String errorMessage;
           if (error.contains("username") && error.contains("email")){
             errorMessage = "Username and email address already in use";
           }else if (error.contains("username")){
             errorMessage = "Username already in use";
           }else if (error.contains("email")){
             errorMessage = "Email address already in use";
           }else{
             errorMessage= "Account could not be created";
           }
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              errorMessage,
              textAlign: TextAlign.center,
              ),
            backgroundColor: Colors.red,
          ));
        }
        if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Sign up was successful',
              textAlign: TextAlign.center,
            ),
            backgroundColor: featureColor,
          ));
          DefaultTabController.of(context).animateTo(0);
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return Container(

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(40.0,40,40,0) ,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(40.0,10,0,0) ,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Hi there! Enter your details to create an account",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                            ),
                            controller: _emailController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                            controller: _usernameController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'First Name',
                            ),
                            controller: _firstNameController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                            ),
                            controller: _lastNameController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            controller: _passwordController,
                            obscureText: true,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.width * 0.22,
                            child: Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: ElevatedButton(
                                onPressed: state is! SignupLoading
                                    ? _onSignupButtonPressed
                                    : null,
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: state is SignupLoading
                                ? CircularProgressIndicator()
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
