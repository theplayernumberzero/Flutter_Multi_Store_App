import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/views/screens/authentication_screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
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
              Container(
                width: 319,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.purple),
                child: Center(
                    child: Text(
                  "Sign In",
                  style: GoogleFonts.getFont('Lato',
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
              SizedBox(
                height: 20,
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
            ],
          ),
        ),
      ),
    );
  }
}
