import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCustoms {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static User initAuth() {
    User toReturnUser;
    auth.authStateChanges().listen((User user) {
      if (user != null) {
        print("${user.email} logged in.");
        toReturnUser = user;
      } else
        print('No user logged in.');
    });
    return toReturnUser;
  }

  static Future<int> requestRegistration(String email, String password, int category) async {
    ///   [toReturnRegistration]
    ///
    ///   0    =>   Registration Unprocessed (Local Error).
    ///   0    =>   Invalid Email Id Format..
    int toReturnRegistration = 0;

    try {
      // UserCredential registeredUserCredentials =
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      /// photoURL
      ///
      /// category  =>  User Category
      /// 0/1       =>  Authentication Status
      await auth.currentUser.updateProfile(photoURL: "${category}0");

      /// [toReturnRegistration] == 1  =>    Registration Successful.
      toReturnRegistration = 1;
      print('User Registered');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        /// [toReturnRegistration] == -1  =>    Weak Password.
        toReturnRegistration = -1;
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        /// [toReturnRegistration] == -2  =>    Email already in use.
        toReturnRegistration = -2;
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      /// [toReturnRegistration] == -3  =>    Unknown Error.
      toReturnRegistration = -3;
    }

    return toReturnRegistration;
  }

  static Future<int> logIn(String email, String password) async {
    ///   [toReturnLogin]
    ///
    ///   0    =>   Registration Unprocessed (Local Error).
    ///        =>   Invalid Email Id Format.
    int toReturnLogin = 0;

    try {
      // UserCredential loggedInUserCredentials =
      await auth
          .signInWithEmailAndPassword(email: email, password: password);

      /// [toReturnLogin] == 1  =>    Registration Successful.
      toReturnLogin = 1;
      print('User Logged In');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        /// [toReturnLogin] == -1  =>    'user-not-found'.
        toReturnLogin = -1;
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        /// [toReturnLogin] == -2  =>    wrong-password.
        toReturnLogin = -2;
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }

    return toReturnLogin;
  }

  static Future<bool> logOut() async {
    bool toReturnLogOut = false;

    try {
      auth.signOut();
      print('Logged Out');
      toReturnLogOut = true;
    } catch (e) {
      print(e);
    }

    return toReturnLogOut;
  }

  static Future<int> resetPassword(String email) async {
    int toReturnReset = 0;

    try {
      await auth.fetchSignInMethodsForEmail(email).then((methods) async {
        if(methods.isEmpty)
          toReturnReset = -1;
        else {
          await auth.sendPasswordResetEmail(email: email).then((value) {print("Sent");});
          toReturnReset = 1;
        }
      });
    }
    catch (error) {
      print(error);
      toReturnReset = -2;
    }

    return toReturnReset;
  }

}
