part of 'workout_view.dart';

class _WorkoutViewDesktop extends StatelessWidget {
  const _WorkoutViewDesktop({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Center(
            child: Text('Todo'),
          ),
        ),
      ),
    );
  }
}
