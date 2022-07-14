import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:safe_space/screens/login.dart';
import 'package:safe_space/screens/home_screen.dart';
import 'package:safe_space/services/auth_services.dart';
import 'package:safe_space/widgets/radio_button.dart';

import '../constants/palette.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int _value = 1;
  String _selectedDate = 'Tap to select date';
  String? date;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Palette.primaryColor,
            colorScheme: ColorScheme.light(
              primary: Palette.primaryColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
        date = _selectedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Create an account, It's free ",
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey[700]),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(
                            child: inputFile(
                          label: "First name",
                          controller: firstNameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z]+|\s"),
                            )
                          ],
                          validator: (value) {
                            // add your custom validation here.
                            if (value!.isEmpty) {
                              return 'Enter Firstname';
                            }
                          },
                        )),
                        SizedBox(
                          width: 10.w,
                        ),
                        Flexible(
                            child: inputFile(
                          label: "Surname",
                          controller: surNameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z]+|\s"),
                            )
                          ],
                          validator: (value) {
                            // add your custom validation here.
                            if (value!.isEmpty) {
                              return 'Enter Surname';
                            }
                          },
                        )),
                      ],
                    ),
                    inputFile(
                      label: "Email",
                      controller: emailController,
                      validator: (val) => val!.isEmpty || !val.contains("@")
                          ? "Enter a valid email"
                          : null,
                    ),
                    inputFile(
                      label: "Password",
                      obscureText: true,
                      controller: passwordController,
                      validator: (val) => val!.isEmpty || val.length < 8
                          ? "Enter a valid password"
                          : null,
                    ),
                    inputFile(
                      label: "Confirm Password ",
                      obscureText: true,
                      controller: confirmPasswordController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        // add your custom validation here.
                        if (value!.isEmpty || value.length < 8) {
                          return 'Enter a valid password';
                        } else if (value != passwordController.text) {
                          return 'Password doesnot match';
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0.w, color: Colors.grey),
                          left: BorderSide(width: 1.0.w, color: Colors.grey),
                          right: BorderSide(width: 1.0.w, color: Colors.grey),
                          bottom: BorderSide(width: 1.0.w, color: Colors.grey),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.r))),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(_selectedDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))),
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            tooltip: 'Tap to open date picker',
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyRadioListTile<int>(
                    value: 1,
                    groupValue: _value,
                    leading: 'M',
                    title: Text('Male'),
                    onChanged: (value) => setState(() => _value = value!),
                  ),
                  MyRadioListTile<int>(
                    value: 2,
                    groupValue: _value,
                    leading: 'F',
                    title: Text('Female'),
                    onChanged: (value) => setState(() => _value = value!),
                  ),
                  MyRadioListTile<int>(
                    value: 3,
                    groupValue: _value,
                    leading: 'O',
                    title: Text('Others'),
                    onChanged: (value) => setState(() => _value = value!),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.only(top: 3.h, left: 3.w),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 40.h,
                  onPressed: () {
                    if (_formKey.currentState!.validate() && date != null) {
                      context
                          .read<AuthService>()
                          .signUp(emailController.text.trim(),
                              confirmPasswordController.text.trim(), context)
                          .then((value) async {
                        User? user = FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(user?.uid)
                            .set({
                          'uid': user?.uid,
                          'firstName': firstNameController.text.trim(),
                          'surName': surNameController.text.trim(),
                          'email': emailController.text.trim(),
                          'passowrd': passwordController.text.trim(),
                          'dob': date,
                          'gender': _value == 1
                              ? 'Male'
                              : _value == 2
                                  ? 'Female'
                                  : 'Others',
                        });
                      });
                    } else {}
                  },
                  color: Palette.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      " Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18.sp),
                    ),
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

// we will be creating a widget for text field
Widget inputFile(
    {label,
    obscureText = false,
    controller,
    final List<TextInputFormatter>? inputFormatters,
    final String? Function(String?)? validator}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black87),
      ),
      SizedBox(
        height: 5.h,
      ),
      TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
      ),
      SizedBox(
        height: 10.h,
      )
    ],
  );
}
