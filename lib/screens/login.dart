import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:safe_space/constants/palette.dart';

import 'package:safe_space/screens/home_screen.dart';
import 'package:safe_space/screens/sign_up.dart';

import '../services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 30.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Login to your account",
                      style:
                          TextStyle(fontSize: 15.sp, color: Colors.grey[700]),
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.h),
                    child: Column(
                      children: <Widget>[
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
                          controller: confirmPasswordController,
                          validator: (val) => val!.isEmpty || val.length < 8
                              ? "Enter a valid password"
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Container(
                    padding: EdgeInsets.only(top: 3.h, left: 3.w),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 40.h,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthService>().login(
                              emailController.text.trim(),
                              confirmPasswordController.text.trim(),
                              context);
                        }
                      },
                      color: Palette.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()));
                      },
                      child: Text(
                        " Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

// we will be creating a widget for text field
Widget inputFile({label, obscureText = false, controller, validator}) {
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
        controller: controller,
        validator: validator,
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
