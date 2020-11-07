part of 'home_view.dart';

class _HomeViewMobile extends StatefulWidget {
  const _HomeViewMobile({Key key}) : super(key: key);

  @override
  __HomeViewMobileState createState() => __HomeViewMobileState();
}

class __HomeViewMobileState extends State<_HomeViewMobile>
    with TickerProviderStateMixin<_HomeViewMobile> {
  AnimationController _hideFabAnimation;

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirebaseFirestoreService dbService =
      locator<FirebaseFirestoreService>();
  final NavigationService navigationService = locator<NavigationService>();
  final UtilService utilService = locator<UtilService>();

  @override
  initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            utilService.today,
                            style: themeData.textTheme.caption,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => navigationService
                                .navigateTo(Router.settingsRoute),
                            child: authService.currentUserAvatar,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //color: Colors.red,
                      child: Text(
                        '${utilService.greeting} ${authService.currentUser.firstName}',
                        style: themeData.textTheme.headline1,
                      ),
                    ),
                  ],
                ),
              ),
              WorkoutsList().withPadding(
                const EdgeInsets.all(defaultPadding),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ScaleTransition(
          scale: _hideFabAnimation,
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            backgroundColor: themeData.buttonColor,
            onPressed: () =>
                navigationService.navigateTo(Router.newWorkoutRoute),
            icon: CustomAwesomeIcon(
              icon: FontAwesomeIcons.plus,
              color: themeData.accentColor,
            ),
            label: Text(
              'New workout',
              style: themeData.textTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}
