import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/user_model.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/shared/dialogs.dart';

import '../../locator.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  MyUser currentUser;
  Widget currentUserAvatar;

  _buildPlaceholderAvatar(User user) {
    final List<String> placeholderCharSources = <String>[
      user.displayName,
      user.email,
      '-',
    ];
    final String placeholderChar = placeholderCharSources
        .firstWhere((String str) => str != null && str.trimLeft().isNotEmpty)
        .trimLeft()[0]
        .toUpperCase();
    return CircleAvatar(
      child: Center(
        child: Text(placeholderChar, textAlign: TextAlign.center),
      ),
    );
  }

  MyUser setCurrentUser(User user) {
    if (user == null) return null;
    currentUser = MyUser(
      id: user.uid,
      name: user.displayName,
      email: user.email,
    );
    return currentUser;
  }

  Stream<MyUser> get user => _auth.authStateChanges().map((User user) {
        if (user == null) return null;
        currentUserAvatar = _googleSignIn.currentUser != null
            ? GoogleUserCircleAvatar(identity: _googleSignIn.currentUser)
            : _buildPlaceholderAvatar(user);
        return setCurrentUser(user);
      });

  Future signInWithGoogle() async {
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.disconnect();

    try {
      GoogleSignInAccount signedInAccount =
          await _googleSignIn.signInSilently();

      if (signedInAccount == null) {
        // Prompt the user to Sign in again.
        UserCredential userCredential;

        if (kIsWeb) {
          GoogleAuthProvider googleProvider = GoogleAuthProvider();
          userCredential =
              await FirebaseAuth.instance.signInWithPopup(googleProvider);
        } else {
          // Trigger the authentication flow
          final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

          // The SignIn-flow has been cancelled if the returned GoogleSignInAccount is null, stop here.
          if (googleUser == null) return null;

          // Obtain the auth details from the request
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          // Create a new credential
          final GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
        }

        // Once signed in, create MyUser object from userCredential
        setCurrentUser(userCredential.user);
      }

      locator<FirebaseFirestoreService>().createUserDocument(
        id: currentUser.id,
        name: currentUser.name,
        email: currentUser.email,
      );

      print('User \'${currentUser.toString()}\' signed in with Google');
    } on PlatformException catch (error) {
      print('Error signing in with Google: $error');

      if (error.code == 'network_error') {
        DialogResponse response =
            await locator<DialogService>().showCustomDialog(
          variant: DialogType.RETRY_LIGHT,
          title: 'No internet access',
          description: 'Google sign in failed due to no internet access.',
          barrierDismissible: true,
          showIconInMainButton: true,
          mainButtonTitle: 'Retry',
        );

        if (response != null && response.confirmed) await signInWithGoogle();
      }
    }
  }

  Future signOut() async {
    print('Signing out...');

    try {
      if (await _googleSignIn.isSignedIn()) {
        await signOutGoogle();
      }
    } catch (error) {
      print(error);
    }

    return await _auth.signOut();
  }

  Future<GoogleSignInAccount> signOutGoogle() async {
    print('Signing out from Google...');
    return await _googleSignIn.disconnect();
  }
}
