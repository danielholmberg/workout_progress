part of 'auth_view.dart';

class _AuthViewMobile extends StatelessWidget {
  const _AuthViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WORKOUT NOW',
                style: themeData.textTheme.headline1,
              ),
              SizedBox(height: 40),
              _googleSignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}
