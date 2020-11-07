import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:workout_progress/models/base_exercise_model.dart';
import 'package:workout_progress/models/exercise_model.dart';
import 'package:workout_progress/models/exercise_set_model.dart';
import 'package:workout_progress/services/firebase/firestore.dart';
import 'package:workout_progress/services/util_service.dart';
import 'package:workout_progress/shared/constants.dart';
import 'package:workout_progress/shared/widgets/custom_awesome_icon.dart';

import '../../../../locator.dart';

class ExerciseItem extends StatefulWidget {
  final BaseExercise baseExercise;
  final Exercise exercise;
  final bool active;
  ExerciseItem({
    Key key,
    @required this.baseExercise,
    @required this.exercise,
    this.active = false,
  }) : super(key: key);

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  List<ExerciseSet> existingExerciseSets;
  List<ExerciseSet> addedExerciseSets;

  final FirebaseFirestoreService dbService =
      locator<FirebaseFirestoreService>();
  final NavigationService navigationService = locator<NavigationService>();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final DialogService dialogService = locator<DialogService>();
  final UtilService utilService = locator<UtilService>();

  @override
  void initState() {
    super.initState();
    existingExerciseSets = widget.active ? dbService.getAllExerciseSets(widget.exercise.id) : [];
    addedExerciseSets = [];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    _addExerciseSet() {
      ExerciseSet newSet = ExerciseSet.emptySet(
        dbService.newExerciseSetId,
        widget.exercise.id,
        existingExerciseSets.length + addedExerciseSets.length,
      );
      widget.exercise.setsToCreate.update(newSet.id, (es) => newSet, ifAbsent: () => newSet);
      print('setToCreate After: ' + widget.exercise.setsToCreate.toString());
      widget.exercise.sets.add(newSet.id);
      addedExerciseSets.add(newSet);
      setState(() {});
    }

    _removeExerciseSet(int index, ExerciseSet setItem) {
      widget.exercise.sets.removeAt(index);
      widget.exercise.setsToCreate.remove(setItem.id);
      addedExerciseSets.removeAt(index);
      setState(() {});
    }

    _toggleCompletedExerciseSet(ExerciseSet completedSet) {
      completedSet.toggleCompleted();
      setState(() {});
    }

    return Container(
      color: themeData.primaryColor,
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          right: widget.exercise.selected ? 10 : 0,
        ),
        duration: Duration(milliseconds: 200),
        child: Container(
          color: themeData.backgroundColor,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.baseExercise.name,
                  style: themeData.textTheme.headline2,
                ),
              ),
              ExpansionTile(
                title: Text(
                  'Instructions',
                  style: themeData.textTheme.headline3,
                ),
                childrenPadding: const EdgeInsets.only(bottom: defaultPadding),
                children: List.generate(
                  widget.baseExercise.instructions.length,
                  (index) {
                    return ListTile(
                      enabled: false,
                      title: Text(
                        widget.baseExercise.instructions[index],
                        style: themeData.textTheme.subtitle2,
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: DataTable(
                      showCheckboxColumn: true,
                      columns: [
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'SET',
                              textAlign: TextAlign.center,
                              style: themeData.textTheme.subtitle1,
                            ),
                          ),
                        ),
                        if (widget.active)
                          DataColumn(
                            numeric: true,
                            label: Expanded(
                              child: Text(
                                'PREVIOUS',
                                textAlign: TextAlign.center,
                                style: themeData.textTheme.subtitle1,
                              ),
                            ),
                          ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'KG',
                              textAlign: TextAlign.center,
                              style: themeData.textTheme.subtitle1,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'REPS',
                              textAlign: TextAlign.center,
                              style: themeData.textTheme.subtitle1,
                            ),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Expanded(
                            child: Text(
                              widget.active ? 'COMPLETED' : 'REMOVE',
                              textAlign: TextAlign.center,
                              style: themeData.textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ],
                      rows: List.generate(
                        existingExerciseSets.length + addedExerciseSets.length,
                        (index) {
                          ExerciseSet setItem = index < existingExerciseSets.length
                              ? existingExerciseSets[index]
                              : addedExerciseSets[index - existingExerciseSets.length];

                          return DataRow(
                            key: ValueKey(setItem.id),
                            color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (setItem.completed) {
                                return Colors.green.withOpacity(0.6);
                              } else {
                                // Even rows will have a grey color.
                                if (index % 2 == 0) {
                                  return themeData.primaryColor
                                      .withOpacity(0.1);
                                }
                              }

                              return null; // Use default value for other states and odd rows.
                            }),
                            cells: [
                              DataCell(
                                Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: themeData.textTheme.headline3,
                                  ),
                                ),
                              ),
                              if (widget.active)
                                DataCell(
                                  Center(
                                    child: Text(
                                      setItem.previous.toString(),
                                      style: themeData.textTheme.bodyText1
                                          .copyWith(
                                              fontSize: 16,
                                              color: themeData.hintColor),
                                    ),
                                  ),
                                ),
                              DataCell(
                                Center(
                                  child: TextFormField(
                                    key: ValueKey('volume'),
                                    initialValue: widget.active
                                        ? setItem.volume.toString()
                                        : '',
                                    decoration: InputDecoration(
                                        hintText: '0.0',
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        hintStyle: themeData.textTheme.bodyText1
                                            .copyWith(
                                          color: themeData.hintColor,
                                        ),
                                        counterText: ''),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 5,
                                    onChanged: (value) =>
                                        setItem.volume = double.parse(value),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: TextFormField(
                                    key: ValueKey('reps'),
                                    initialValue: widget.active
                                        ? setItem.reps.toString()
                                        : '',
                                    decoration: InputDecoration(
                                        hintText: '0',
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        hintStyle: themeData.textTheme.bodyText1
                                            .copyWith(
                                          color: themeData.hintColor,
                                        ),
                                        counterText: ''),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
                                    onChanged: (value) =>
                                        setItem.reps = int.parse(value),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: widget.active
                                      ? IconButton(
                                          onPressed: () =>
                                              _toggleCompletedExerciseSet(
                                                  setItem),
                                          icon: CustomAwesomeIcon(
                                            icon: FontAwesomeIcons.checkSquare,
                                            color: setItem.completed
                                                ? Colors.green
                                                : themeData.hintColor,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () =>
                                              _removeExerciseSet(index, setItem),
                                          icon: CustomAwesomeIcon(
                                            icon: FontAwesomeIcons.timesCircle,
                                            color: themeData.errorColor,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(defaultPadding),
                width: MediaQuery.of(context).size.width,
                child: FlatButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: themeData.buttonColor,
                  onPressed: _addExerciseSet,
                  icon: CustomAwesomeIcon(
                    icon: FontAwesomeIcons.plus,
                    size: 14,
                  ),
                  label: Text(
                    'Add set',
                    style: themeData.textTheme.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
