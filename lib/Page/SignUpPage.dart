// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print, library_private_types_in_public_api, recursive_getters
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/components/EmailVerif.dart';
import 'package:project/services/googleService.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpPage({super.key, required this.showLoginPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();

  static final GlobalKey<_SignUpPageState> globalKey =
      GlobalKey<_SignUpPageState>();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final alergyController = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    alergyController.dispose();
    super.dispose();
  }

  String get email => emailController.text;
  String get password => passwordController.text;

  final LinearGradient _gradient = LinearGradient(
    colors: <Color>[
      Color.fromRGBO(63, 142, 233, 1),
      Color.fromRGBO(69, 117, 171, 1),
    ],
  );

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  String get birthDate => dateController.text;

  Future<void> signUp() async {
    final name = nameController.text;
    final date = dateController.text;
    final email = emailController.text;
    final phoneNumber = phoneNumberController.text;
    final password = passwordController.text;
    final passwordConfimation = passwordConfirmationController.text;
    final alergy = alergyController.text;

    if (name.isEmpty ||
        date.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        passwordConfimation.isEmpty || alergy.isEmpty) {
      showErrorDialog('Please fill in all the required data');
      return;
    }

    try {
      if (passwordController.text == passwordConfirmationController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          'password': password,
          'birthDate': birthDate,
          'phoneNumber': phoneNumber,
          'alamat': '-',
          'alergi': alergy,
          'role': 'user',
          'uid': userCredential.user!.uid
        });

        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyEmailPage(),
            ));
      } else {
        showErrorDialog('Password don\'t match');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorDialog('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog('The account already exists for that email.');
      }
    }
  }

  Future<void> createUserWithoutVerification() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text,
        'email': email,
        'password': password,
        'birthDate': birthDate,
        'phoneNumber': phoneNumberController.text,
        'uid': userCredential.user!.uid
      });
    } catch (e) {
      print("Error creating user: $e");
      // Handle error
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Center(
          child: Text(message,
              style: TextStyle(
                  fontFamily: 'Kadwa',
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 70),

              //! Alergy Diary
              ShaderMask(
                  shaderCallback: (Rect rect) {
                    return _gradient.createShader(rect);
                  },
                  child: Text('Allergy Diary',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 50,
                              fontFamily: 'Leckerli'))),

              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //! Name TextBox
                  Text('Name',
                      style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
                  TextField(
                    controller: nameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      fillColor: Color.fromRGBO(243, 246, 250, 1),
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),

                  SizedBox(height: 20),

                  //! Birth Date TextBox
                  Text('Birth Date',
                      style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      fillColor: Color.fromRGBO(243, 246, 250, 1),
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),

                  const SizedBox(height: 20),

                  //! Email TextBox
                  Text('Email',
                      style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
                  TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      fillColor: Color.fromRGBO(243, 246, 250, 1),
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //! Phone Number TextBox
                  Text('Phone Number',
                      style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
                  TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Use Your Country Code',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      fillColor: Color.fromRGBO(243, 246, 250, 1),
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text('Alergy',
                      style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
                  TextField(
                    controller: alergyController,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      fillColor: Color.fromRGBO(243, 246, 250, 1),
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //! Password TextBox
                  Text('Password',
                      style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
                  TextField(
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        fillColor: Color.fromRGBO(243, 246, 250, 1),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: GestureDetector(
                          onTap: togglePasswordVisibility,
                          child: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        )),
                  ),

                  const SizedBox(height: 20),

                  //! Password Confirmation TextBox
                  Text('Password Confirmation',
                      style: TextStyle(fontSize: 17, fontFamily: 'Outfit')),
                  TextField(
                    controller: passwordConfirmationController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        fillColor: Color.fromRGBO(243, 246, 250, 1),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: GestureDetector(
                          onTap: togglePasswordVisibility,
                          child: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        )),
                  ),

                  const SizedBox(height: 40),

                  //! Sign Up Button
                  GestureDetector(
                    onTap: () => signUp(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(143, 173, 222, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  //! Or continue with google
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or',
                            style: TextStyle(
                                color: Colors.grey[700], fontFamily: 'Outfit'),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //! Google
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => AuthService().signInWithGoogle(),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: [
                              Image.asset('image/Google.png', height: 20),
                              Text('Continue with Google',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Outfit')),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 40),

                  //! already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                            color: Colors.grey[700], fontFamily: 'Kadwa'),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.grey[700],
                            decoration: TextDecoration.underline,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AuthController {
  static final AuthController _instance = AuthController._internal();

  factory AuthController() => _instance;

  AuthController._internal();

  String get email =>
      SignUpPage.globalKey.currentState?.emailController.text ?? '';
  String get pass =>
      SignUpPage.globalKey.currentState?.passwordController.text ?? '';
}
