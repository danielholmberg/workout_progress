import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/locator.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/shared/constants.dart';
import 'package:workout_progress/shared/extensions.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

class SearchExerciseModal extends StatefulWidget {
  final List<BaseExercise> baseExercises;
  final Function(List<BaseExercise>) addBaseExercisesToWorkout;
  SearchExerciseModal({
    Key key,
    this.baseExercises,
    this.addBaseExercisesToWorkout,
  }) : super(key: key);

  @override
  _SearchExerciseModalState createState() => _SearchExerciseModalState();
}

class _SearchExerciseModalState extends State<SearchExerciseModal> {
  TextEditingController searchController;
  List<BaseExercise> searchResult;
  List<BaseExercise> selectedBaseExercises;

  final NavigationService navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    searchController = new TextEditingController();
    searchResult = List.from(widget.baseExercises);
    selectedBaseExercises = [];
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    _onSearchTextChanged(String text) async {
      if (text.isEmpty) {
        searchResult.addAll(widget.baseExercises);
      } else {
        searchResult.clear();
        searchResult.addAll(widget.baseExercises);

        widget.baseExercises.forEach((BaseExercise baseExercise) {
          if (baseExercise.name.toLowerCase().contains(text.toLowerCase())) {
            if (!searchResult.contains(baseExercise)) {
              searchResult.add(baseExercise);
            }
          } else {
            if (searchResult.contains(baseExercise)) {
              searchResult.remove(baseExercise);
            }
          }
        });
      }

      setState(() {});
    }

    _resetSearch() {
      searchController.clear();
      _onSearchTextChanged('');
    }

    _buildSearchExerciseItem(int index, BaseExercise baseExercise) {
      return CheckboxListTile(
        activeColor: themeData.buttonColor,
        value: baseExercise.selected,
        onChanged: (selected) {
          baseExercise.setSelected(selected);
          widget.baseExercises
              .firstWhere((BaseExercise e) => e.id.compareTo(baseExercise.id) == 0)
              .setSelected(selected);
          if (selected) {
            if (!selectedBaseExercises.contains(baseExercise)) {
              selectedBaseExercises.add(baseExercise);
            }
          } else {
            if (selectedBaseExercises.contains(baseExercise)) {
              selectedBaseExercises.remove(baseExercise);
            }
          }
          setState(() {});
        },
        title: Text(
          baseExercise.name,
          style: themeData.textTheme.headline3,
        ),
        subtitle: Text('Equipment: ' + baseExercise.equipment()),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await widget.addBaseExercisesToWorkout(selectedBaseExercises);
        return true;
      },
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
                        controller: searchController,
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
                        onChanged: _onSearchTextChanged,
                      ).withPadding(
                          const EdgeInsets.only(left: defaultPadding)),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.solidTimesCircle,
                        color: themeData.buttonColor,
                      ),
                      onPressed: _resetSearch,
                    ).isVisible(searchController.text.isNotEmpty),
                  ],
                ),
              ),
              ListView.separated(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchResult.length,
                itemBuilder: (context, index) {
                  return _buildSearchExerciseItem(
                    index,
                    searchResult[index],
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
                  onPressed: () async {
                    await widget.addBaseExercisesToWorkout(selectedBaseExercises);
                    navigationService.back();
                  },
                  icon: CustomAwesomeIcon(
                    icon: FontAwesomeIcons.check,
                    color: themeData.accentColor,
                  ),
                  label: Text(
                    'Add to workout',
                    style: themeData.textTheme.button,
                  ),
                ),
              ).isVisible(selectedBaseExercises.isNotEmpty),
            ),
          ),
        ],
      ),
    );
  }
}
