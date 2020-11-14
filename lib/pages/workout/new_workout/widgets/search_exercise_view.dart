import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/pages/workout/new_workout/widgets/search_exercise_view_model.dart';
import 'package:workout_progress/shared/constants.dart';
import 'package:workout_progress/shared/extensions.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

class SearchExerciseView extends HookWidget {
  final Function(List<BaseExercise>) addBaseExercisesToWorkout;
  SearchExerciseView({
    Key key,
    this.addBaseExercisesToWorkout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextEditingController searchController = useTextEditingController();

    _buildSearchExerciseItem(
      SearchExerciseViewModel model,
      int index,
      BaseExercise baseExercise,
    ) {
      return CheckboxListTile(
        activeColor: themeData.buttonColor,
        value: baseExercise.selected,
        onChanged: (selected) =>
            model.onBaseExerciseSelected(selected, baseExercise),
        title: Text(
          baseExercise.name,
          style: themeData.textTheme.headline3,
        ),
        subtitle: Text('Equipment: ' + baseExercise.equipment()),
      );
    }

    return ViewModelBuilder<SearchExerciseViewModel>.reactive(
      viewModelBuilder: () => SearchExerciseViewModel(),
      onModelReady: (model) => model.initialise(
        searchController,
        addBaseExercisesToWorkout,
      ),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async => await model.onWillPop(isActionButton: false),
          child: Stack(
            children: [
              ListView(
                physics: ScrollPhysics(),
                children: [
                  Container(
                    //color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: model.searchController,
                            autofocus: false,
                            decoration: InputDecoration(
                              icon: CustomAwesomeIcon(
                                icon: FontAwesomeIcons.search,
                                color: themeData.buttonColor,
                              ),
                              hintText: 'Search for an exercise',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: themeData.hintColor,
                              ),
                            ),
                            onChanged: model.onSearchTextChanged,
                          ).withPadding(
                              const EdgeInsets.only(left: defaultPadding)),
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.solidTimesCircle,
                            color: themeData.buttonColor,
                          ),
                          onPressed: model.resetSearch,
                        ).isVisible(model.searchController.text.isNotEmpty),
                      ],
                    ),
                  ),
                  ListView.separated(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.resultsCount,
                    itemBuilder: (context, index) {
                      return _buildSearchExerciseItem(
                        model,
                        index,
                        model.getBaseExerciseItem(index),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: addActionBar(
                  title: Container(
                    margin: const EdgeInsets.all(defaultPadding),
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: themeData.buttonColor,
                      onPressed: () => model.onWillPop(isActionButton: true),
                      icon: CustomAwesomeIcon(
                        icon: FontAwesomeIcons.check,
                        color: themeData.accentColor,
                      ),
                      label: Text(
                        'Add to workout',
                        style: themeData.textTheme.button,
                      ),
                    ),
                  ).isVisible(model.hasSelectedBaseExercises),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
