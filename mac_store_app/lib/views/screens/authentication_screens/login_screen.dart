import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/vendor/views/auth/vendor_login_screen.dart';
import 'package:mac_store_app/vendor/views/auth/vendor_register_screen.dart';
import 'package:mac_store_app/views/screens/authentication_screens/register_screen.dart';
import 'package:mac_store_app/views/screens/authentication_screens/reset_password_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //It is for access to current situation of form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //For login
  final AuthController _authController = AuthController();

  //CircularProgress için
  bool _isLoading = false;

  // E-posta ve şifre için controller'lar
  late String email;

  late String password;

  bool _isObscure = true;

  // Formu kontrol etmek için bir fonksiyon
  void _submitForm(BuildContext context) async {
    BuildContext localContext = context;
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      // Form geçerli ise işlemi yap

      String res =
          await _authController.loginUser(email.trim(), password.trim());
      print(res);
      print("login user çalıştı");
      if (res == 'buyer_success') {
        //go to main screen
        Future.delayed(Duration.zero, () {
          Navigator.pushAndRemoveUntil(
            localContext,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (Route<dynamic> route) => false,
          );

          ScaffoldMessenger.of(localContext)
              .showSnackBar(SnackBar(content: Text('Logged in')));
        });
        print("Logged in");
      } else {
        print("Buradayım");
        print(res);
        setState(() {
          _isLoading = false;
        });
        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(localContext)
              .showSnackBar(SnackBar(content: Text(res)));
        });
      }
      print(email);
      print(password);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Form Geçerli')));
    } else {
      // Form geçerli değilse kullanıcıya hata mesajı göster
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Form Hatalı')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          //Scrollable
          child: Form(
            key: _formKey,
            child: Center(
              //horizontally centered
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login your account",
                    style: GoogleFonts.getFont(
                        //Font proporty as first parameter
                        'Lato',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                        fontSize: 23),
                  ),
                  Text(
                    "To explore the world exclusives",
                    style: GoogleFonts.getFont('Lato',
                        color: Colors.black, fontSize: 14, letterSpacing: 0.2),
                  ),
                  Image.asset(
                    "assets/images/Illustration.png",
                    width: 200,
                    height: 200,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Email",
                      style: GoogleFonts.getFont('Nunito Sans',
                          fontWeight: FontWeight.w600, letterSpacing: 0.2),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-posta boş olamaz';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Geçersiz e-posta adresi';
                      }
                      return null; // Geçerli
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9)),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: "Enter your email",
                        labelStyle: GoogleFonts.getFont('Nunito Sans',
                            fontSize: 14, letterSpacing: 0.1),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/icons/email.png",
                            width: 20,
                            height: 20,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Password",
                      style: GoogleFonts.getFont('Nunito Sans',
                          fontWeight: FontWeight.w600, letterSpacing: 0.2),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null; // Valid
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9)),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: "Enter your password",
                        labelStyle: GoogleFonts.getFont('Nunito Sans',
                            fontSize: 14, letterSpacing: 0.1),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/icons/password.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off))),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResetPasswordScreen()));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ))),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => _submitForm(context),
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.purple),
                      child: Center(
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Sign In",
                                  style: GoogleFonts.getFont('Lato',
                                      fontSize: 18,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an vendor account?",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500, letterSpacing: 1)),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VendorLoginScreen()));
                        },
                        child: Text("Sign In",
                            style: GoogleFonts.roboto(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Need an account?",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500, letterSpacing: 1)),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                        child: Text("Sign Up",
                            style: GoogleFonts.roboto(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Become a vendor?",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500, letterSpacing: 1)),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VendorRegisterScreen()));
                        },
                        child: Text("Sign Up",
                            style: GoogleFonts.roboto(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
