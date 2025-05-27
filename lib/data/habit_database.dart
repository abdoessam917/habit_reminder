import 'package:hive/hive.dart';

import '../datetime/date_time.dart';

// reference our box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};



  //crate initial defaul data
  void createDefaultData() {
    todaysHabitList = [
      ["Run", false],
      ["Read", false],
    ];
    _myBox.put("START_DATE", todaysDateFormatted());
  }
  // load data if it already exists
  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    }
    // IF NNOT A NEW DAY LOAD TODAYS LISTT
    else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }
  // update database
  void updateDatabase() {
    // update today's entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    calculateHabitPercentages();

    loadHeatMap();
  }
  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }
    String percent = todaysHabitList.isEmpty ? "0.0" :
    (countCompleted/ todaysHabitList.length).toStringAsFixed(1);

    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);

  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    int daysinBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysinBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int> {
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}

