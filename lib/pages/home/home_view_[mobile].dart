part of 'home_view.dart';

class _HomeViewMobile extends HookViewModelWidget<HomeViewModel> {
  const _HomeViewMobile({Key key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, HomeViewModel model) {
    final ThemeData themeData = Theme.of(context);

    final AnimationController _hideFabAnimation =
        useAnimationController(duration: kThemeAnimationDuration, initialValue: 1.0);

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
                            model.today,
                            style: themeData.textTheme.caption,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => model.navigateToSettings(),
                            child: model.currentUserAvatar,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //color: Colors.red,
                      child: Text(
                        '${model.greeting} ${model.currentUser.firstName}',
                        style: themeData.textTheme.headline1,
                      ),
                    ),
                  ],
                ),
              ),
              ViewModelBuilder<WorkoutsViewModel>.reactive(
                viewModelBuilder: () => WorkoutsViewModel(),
                builder: (context, model, child) {
                  return WorkoutList().withPadding(
                    const EdgeInsets.all(defaultPadding),
                  );
                }
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
            onPressed: () => model.navigateToNewWorkout(),
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
