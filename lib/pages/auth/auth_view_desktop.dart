part of 'auth_view.dart';

class _AuthViewDesktop extends StatelessWidget {
  const _AuthViewDesktop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    _googleSignInButton() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonTheme(
            height: defaultButtonHeight,
            child: CustomRaisedButton(
              icon: CustomAwesomeIcon(
                icon: FontAwesomeIcons.google, 
                color: buttonIconColorLight,
              ),
              text: 'Sign in with Google',
              onPressed: () async {
                await locator<FirebaseAuthService>().signInWithGoogle();
              },
            ),
          ),
        ],
      );
    }
    
    return Scaffold(
      body: Container(
        child: Center(
          child: _googleSignInButton(),
        ),
      ),
    );
  }
}