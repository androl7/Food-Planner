import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_planner/services/database.dart';
import 'package:intl/intl.dart';

class HomeScreenList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenListState();
}

class HomeScreenListState extends State<HomeScreenList> {
  Stream mealsStream;
  HomeScreenScale scale;

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  getMeals() async {
    DateTime actualDate = DateTime.now().subtract(const Duration(days: 5));
    DateTime endDate = actualDate.add(const Duration(days: 7));
    mealsStream = await DatabaseMethods().getMealsByCustomerAndStartEndDate(
        "znrvDUXYJpEu8ocXtUuu", actualDate, endDate);
    setState(() {});
  }

  onScreenLoaded() async {
    //await getMyInfoFromSharedPreference();
    await getMeals();
  }

  @override
  Widget build(BuildContext context) {
    scale = HomeScreenScale(context);
    DateFormat dayNameFormatter = DateFormat("EEEE");
    DateFormat dateFormatter = DateFormat("dd-MM-yyyy");
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation:0,
        leading: Icon(Icons.menu_book, color: Colors.black),
        backgroundColor: Colors.transparent,
        title: const Text("Kalendarz"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: mealsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    DateTime dateTime = (ds["date"] as Timestamp).toDate();
                    bool isTheSameDayAsPrevious = false;
                    if (index != 0) {
                      DateTime dateTimeOfPrevious =
                          (snapshot.data.docs[index - 1]["date"] as Timestamp)
                              .toDate();
                      if (dateTime.year == dateTimeOfPrevious.year &&
                          dateTime.month == dateTimeOfPrevious.month &&
                          dateTime.day == dateTimeOfPrevious.day) {
                        isTheSameDayAsPrevious = true;
                      }
                    }
                    bool isTheSameDayAsNext = false;
                    if (index != snapshot.data.docs.length - 1) {
                      DateTime dateTimeOfPrevious =
                          (snapshot.data.docs[index + 1]["date"] as Timestamp)
                              .toDate();
                      if (dateTime.year == dateTimeOfPrevious.year &&
                          dateTime.month == dateTimeOfPrevious.month &&
                          dateTime.day == dateTimeOfPrevious.day) {
                        isTheSameDayAsNext = true;
                      }
                    }
                    return chatMessageTile(
                        ds["name"],
                        dateFormatter.format(dateTime),
                        dayNameFormatter.format(dateTime),
                        isTheSameDayAsPrevious,
                        isTheSameDayAsNext);
                  })
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget chatMessageTile(String name, String date, String dayName,
      bool isTheSameDayAsPrevious, bool isTheSameDayAsNext) {
    if (isMiddleElement(isTheSameDayAsPrevious, isTheSameDayAsNext)) {
      return Container(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(89, 148, 156, 0.8)),
            child: rowWithIconAndMealNameWidget(name),
          ),
          dividerBetweenMealsListWidget()
        ]),
      );
    } else if (isJustOneElement(isTheSameDayAsPrevious, isTheSameDayAsNext)) {
      return Container(
        child: Column(children: [
          rowWithDayNameAndDateWidget(dayName, date),
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(89, 148, 156, 0.8),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24))),
            child: rowWithIconAndMealNameWidget(name),
          ),
          Container(
              width: 50,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(89, 148, 156, 0.8),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Icon(Icons.add_box_outlined, color: Colors.white)),
          SizedBox(height: 50)
        ]),
      );
    } else if (isFirstElement(isTheSameDayAsPrevious, isTheSameDayAsNext)) {
      return Container(
        child: Column(children: [
          rowWithDayNameAndDateWidget(dayName, date),
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(89, 148, 156, 0.8),
                borderRadius: BorderRadius.only(topRight: Radius.circular(24))),
            child: Container(
              child: rowWithIconAndMealNameWidget(name),
            ),
          ),
          dividerBetweenMealsListWidget()
        ]),
      );
    } else if (isLastElement(isTheSameDayAsPrevious, isTheSameDayAsNext)) {
      return Container(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(89, 148, 156, 0.8),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24))),
            child: rowWithIconAndMealNameWidget(name),
          ),
          plusIconWidgetOnBottonOfListWidget(),
          SizedBox(height: 50)
        ]),
      );
    }
  }

  bool isMiddleElement(bool isTheSameDayAsPrevious, bool isTheSameDayAsNext) {
    return isTheSameDayAsNext && isTheSameDayAsPrevious;
  }

  bool isJustOneElement(bool isTheSameDayAsPrevious, bool isTheSameDayAsNext) {
    return !isTheSameDayAsPrevious && !isTheSameDayAsNext;
  }

  bool isFirstElement(bool isTheSameDayAsPrevious, bool isTheSameDayAsNext) {
    return !isTheSameDayAsPrevious && isTheSameDayAsNext;
  }

  bool isLastElement(bool isTheSameDayAsPrevious, bool isTheSameDayAsNext) {
    return isTheSameDayAsPrevious && !isTheSameDayAsNext;
  }

  Widget rowWithDayNameAndDateWidget(String dayName, String date) {
    return Row(children: [
      Container(
          width: 100,
          decoration: BoxDecoration(
              color: Color.fromRGBO(89, 148, 156, 0.8),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24), topLeft: Radius.circular(24))),
          child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(dayName,
                  style: TextStyle(
                      fontSize: scale.fontSize, color: Colors.white)))),
      SizedBox(width: 30),
      Text(date,
          style: TextStyle(
              fontSize: scale.fontSize,
              color: Color.fromRGBO(89, 148, 156, 0.8)))
    ]);
  }

  Widget dividerBetweenMealsListWidget() {
    return Container(
        color: Color.fromRGBO(89, 148, 156, 0.8),
        height: 2,
        child: Divider(
          thickness: 1.8,
          height: 1.8,
          color: Color.fromRGBO(210, 239, 235, 0.8),
          endIndent: 10,
          indent: 10,
        ));
  }

  Widget rowWithIconAndMealNameWidget(String name) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.access_alarm_outlined, color: Colors.white),
      title: Text(
        name,
        style: TextStyle(fontSize: scale.fontSize, color: Colors.white),
      ),
    );
  }

  Widget plusIconWidgetOnBottonOfListWidget() {
    return Container(
        width: 50,
        decoration: BoxDecoration(
            color: Color.fromRGBO(89, 148, 156, 0.8),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Icon(Icons.add_box_outlined, color: Colors.white));
  }
}

class HomeScreenScale {
  final BuildContext _ctxt;

  HomeScreenScale(this._ctxt);

  double get listRowMealsSize => scaledHeight(.05);

  double get listMealsPaddingSize => scaledHeight(.01);

  double get iconSize => scaledHeight(.03);

  double get fontSize => scaledHeight(.02);

  double get spaceBetweenElementsInTheWrap => scaledHeight(.01);

  double scaledWidth(double widthScale) {
    return MediaQuery.of(_ctxt).size.width * widthScale;
  }

  double scaledHeight(double heightScale) {
    return MediaQuery.of(_ctxt).size.height * heightScale;
  }
}
