import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitama/core/config/assets/app_images.dart';
import 'package:sitama/core/config/assets/app_vectors.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sitama/features/auth/data/models/signin_google_req_params.dart';
import 'package:sitama/features/auth/domain/usecases/signin_google.dart';
import 'package:sitama/features/auth/ui/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/shared/widgets/alert/custom_snackbar.dart';
import '../../../../service_locator.dart';
import '../../../lecturer/ui/home/pages/lecturer_home.dart';
import '../../../student/ui/home/pages/home.dart';

class WelcomePages extends StatefulWidget {
  WelcomePages({super.key});

  @override
  _WelcomePagesState createState() => _WelcomePagesState();
}

class _WelcomePagesState extends State<WelcomePages> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false; // State untuk loading

  void _showErrorSnackbar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade800,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Login ke Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return; // Login dibatalkan
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Kredensial Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Ambil ID Token
      final idToken = await userCredential.user?.getIdToken();
      await _sendTokenToBackend(idToken!, context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> _sendTokenToBackend(String idToken, BuildContext context) async {
    try {
      var response = await sl<SigninGoogleUseCase>().call(param: SigninGoogleReqParams(token: idToken));

      response.fold((error) {
        _showErrorSnackbar('Email anda tidak terdaftar', context);
        print(error);
      }, (data) async {
        print(data.toString());

        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('token', data.data['data']['token']);
        sharedPreferences.setString('role', data.data['data']['role']);

        var role = data.data['data']['role'];

        if (role == 'Student') {
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
          );
        } else {
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LecturerHomePage(),
            ),
          );
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.pattern),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.logo,
                  width: 200,
                  height: 150,
                ),
                SizedBox(height: 10),
                Text(
                  'SITAMA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Selamat Datang di SITAMA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Bantu kegiatan magang dan bimbingan jadi lebih mudah!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.lightGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 70),
                _loginButton(context),
                SizedBox(height: 16),
                Text(
                  'Or continue with',
                  style: TextStyle(
                    color: AppColors.lightGray,
                  ),
                ),
                SizedBox(height: 16),
                _signInWithGoogleButton(context),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white,),
              ),
            ),
        ],
      ),
    );
  }

  ElevatedButton _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(55),
        ),
        minimumSize: Size.fromHeight(50),
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          color: AppColors.lightWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  OutlinedButton _signInWithGoogleButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _signInWithGoogle(context);
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.lightGray),
        minimumSize: const Size(324, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(55),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectors.google),
          SizedBox(width: 10),
          Text(
            'Lanjut Dengan Google',
            style: TextStyle(
              color: AppColors.lightGray,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
