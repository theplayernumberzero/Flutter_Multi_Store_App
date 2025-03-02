import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/views/screens/authentication_screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //It is for access to current situation of form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //For register
  final AuthController _authController = AuthController();

  // E-posta ve şifre için controller'lar
  late String email;

  late String fullName;

  late String password;

  // Formu kontrol etmek için bir fonksiyon
  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Form geçerli ise işlemi yap
      BuildContext localContext = context;

      String res =
          await _authController.registerNewUser(email, fullName, password);
      if (res == 'Success') {
        Future.delayed(Duration.zero, () {
          Navigator.push(localContext, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));

          ScaffoldMessenger.of(localContext)
              .showSnackBar(SnackBar(content: Text('Account created')));
        });
      }
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
        child: Center(
          //horizontally centered
          child: SingleChildScrollView(
            //For making widget scrollable
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create your account",
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
                      "Full Name",
                      style: GoogleFonts.getFont('Nunito Sans',
                          fontWeight: FontWeight.w600, letterSpacing: 0.2),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      fullName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your full name';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9)),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: "Enter your full name",
                        labelStyle: GoogleFonts.getFont('Nunito Sans',
                            fontSize: 14, letterSpacing: 0.1),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/icons/user.jpeg",
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
                        suffixIcon: Icon(Icons.visibility)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _submitForm(context);
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.purple),
                      child: Center(
                          child: Text(
                        "Sign Up",
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
                      Text("Already have an account?",
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
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text("Sign In",
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
