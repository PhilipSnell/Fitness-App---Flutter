
import 'package:flutter/material.dart';
import 'package:xcell/database/exercise_database.dart';
import 'package:xcell/database/set_database.dart';
import 'package:xcell/models/training_set.dart';
import 'package:xcell/theme/style.dart';

class CardDropDown extends StatefulWidget {
  final String reps;
  final String weight;
  final int t_id;
  final int e_id;
  final bool display;
  final Function(bool) setSubmitAllowed;

  CardDropDown({
    Key key,
    this.display,
    this.reps,
    this.weight,
    this.t_id,
    this.e_id,
    this.setSubmitAllowed,
  }) : super(key: key);

  @override
  _CardDropDownState createState() => _CardDropDownState();
}

class _CardDropDownState extends State<CardDropDown> {
  // need to load the itemList from db
  final set_db = SetDatabase.instance;
  final db = ExerciseDatabase.instance;
  String comment_before_set = "";
  String repsDefault;
  String weightDefault;

  //Map<String, String> reps = {};

  void takeReps(String text, int index,List<TrainingSet> list) {
    try {
      print("Before: ${list[index].reps}");
      list[index].reps = text;
      print("After: ${list[index].reps}");
    } on FormatException {}
    saveList(list);
    widget.setSubmitAllowed(true);
  }
  void takeWeight(String text, int index, List<TrainingSet> list){
    try {
      print("Before: ${list[index].weights}");
      list[index].weights = text;
      print("After: ${list[index].weights}");
    } on FormatException {}
    saveList(list);
    widget.setSubmitAllowed(true);
  }
  void getDefaults(List<TrainingSet> list){
    if (list.length == 0){
      repsDefault = widget.reps;
      weightDefault = widget.weight;
    }
    else{
      repsDefault = list.last.reps;
      weightDefault = list.last.weights;
    }
  }
  Future<List<TrainingSet>> loadList() async{
    var sets = await set_db.queryID(widget.t_id);
    if (sets.length > 0) {
      if (sets[0].sets == -1) {
        comment_before_set = sets[0].comment;
        sets.clear();
      }
      else if (sets[0].comment == '###'){
        sets[0].comment = null;
      }
    }
    return sets;
  }

  void saveList(List<TrainingSet> list) async{
    String reps ="";
    String weights = "";
    Map<String, dynamic> row;
    if(list.isEmpty){
      if(comment_before_set == "") {
        await set_db.delete(widget.t_id);
        print("Removing last set");
      }else{
        await set_db.delete(widget.t_id);
        print("Removing last set");
        row = {
          't_id': widget.t_id,
          'sets': -1,
          'reps': "",
          'weights': "",
          'difficulty': 0,
          'comment':comment_before_set,
          'e_id': 0,
        };
        set_db.insert(row);
      }
      loadList();
    }else {

      //combining reps and weights into one string separating each item with comma
      for (TrainingSet item in list) {
        reps = "$reps${item.reps},";
        weights = "$weights${item.weights},";
      }
      //remove comma from end of string
      if (reps != null && reps.length > 0) {
        reps = reps.substring(0, reps.length - 1);
        weights = weights.substring(0, weights.length - 1);
      }
      print("-----Comment------");
      print(list[0].comment);
      if(list[0].comment == null){
        list[0].comment = '###';
      }
      if (1 <= list[0].difficulty && list[0].difficulty <= 10 ){
        row = {
          't_id': list[0].t_id,
          'sets': list.length,
          'reps': reps,
          'weights': weights,
          'difficulty':list[0].difficulty,
          'comment':list[0].comment,
          'e_id': list[0].e_id,
        };
      }else{
        row = {
          't_id': list[0].t_id,
          'sets': list.length,
          'reps': reps,
          'weights': weights,
          'difficulty': 0,
          'comment':list[0].comment,
          'e_id': list[0].e_id,
        };
      }

      print("INSERTING :$row");

      var result = await set_db.insert(row);
      if(result==null){
        print("Set already existed ... updating");
        await set_db.update(row);
      }
      else{
        print("Successfully added $row");
      }

    }
    setState(() {
      print("save completed");
    });
  }
  void initialiseDefaults(){
    repsDefault = widget.reps;
    weightDefault = widget.weight;
  }
  @override
  void initState() {
    super.initState();
    initialiseDefaults();
  }

  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: widget.display,
      child: Container(
        color: cardDropDown,
        child: FutureBuilder<List<TrainingSet>>(
          future: loadList(),
          builder: (context, listOfSets) {

            if(listOfSets.hasData){

              return Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: listOfSets.data.length > 0 ? true : false,

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,5,0,5),
                      child: Row(

                        children: [

                          Container(

                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 25),
                              child: Text(
                                "Difficulty",
                                style: TextStyle(
                                  color: difficulty,

                                ),
                                textAlign: TextAlign.left
                              ),
                            ),
                          ),
                          Container(
                            width: 242,

                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 6,

                                overlayShape: SliderComponentShape.noThumb,
                                trackShape: CustomTrackShape(),
                              ),
                              child: Slider(

                                min: 0,
                                max: 10,
                                value: listOfSets.data.length > 0
                                    ? listOfSets.data[0].difficulty.toDouble()
                                    : 0,
                                divisions: 10,
                                label: listOfSets.data.length > 0
                                  ? '${listOfSets.data[0].difficulty.round()}'
                                  : '${0}',
                                onChanged: (value) {
                                  setState(() {
                                    listOfSets.data[0].difficulty = value.toInt();
                                    saveList(listOfSets.data);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listOfSets.data.length,
                      itemBuilder: (BuildContext context, int index) {

                        return TrainSet(listOfSets.data,index);
                      }
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          maintainSize: false,
                          visible: listOfSets.data.length > 0 ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.only(right:100),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17.5),
                              child: Container(
                                height: 35,
                                width: 35,
                                color: setButton,
                                child: IconButton(
                                    padding: EdgeInsets.fromLTRB(0,1,0,3),
                                    icon: Icon(
                                      Icons.remove,
                                      color: cardAddIcon,
                                      size: 30,
                                    ),
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      // if ladder to avoid removal of last set if it has a comment
                                      if(listOfSets.data.length == 1){
                                        if(listOfSets.data[0].comment==null || listOfSets.data[0].comment.isNotEmpty){
                                          comment_before_set = listOfSets.data[0].comment;
                                          listOfSets.data.clear();
                                        }else{
                                          listOfSets.data.removeLast();
                                        }
                                      }else{
                                        listOfSets.data.removeLast();
                                      }

                                      saveList(listOfSets.data);
                                      widget.setSubmitAllowed(true);
                                    }
                                ),
                              ),
                            ),
                          ),
                        ),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(17.5),
                          child: Container(
                            height: 35,
                            width: 35,
                            // margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            color: setButton,
                            child: IconButton(
                                padding: EdgeInsets.fromLTRB(0,2,0,4),
                                icon: Icon(
                                  Icons.add,
                                  color: cardAddIcon,
                                  size: 30,
                                ),
                                // padding: listOfSets.data.length > 0 ? EdgeInsets.only(left: 15) : EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  getDefaults(listOfSets.data);
                                  if (comment_before_set != ""){
                                    listOfSets.data.add(TrainingSet(t_id: widget.t_id, sets: 1, reps: repsDefault, weights: weightDefault, difficulty: 0, comment: comment_before_set, e_id: widget.e_id));
                                    comment_before_set = "";
                                  }
                                  else{
                                    listOfSets.data.add(TrainingSet(t_id: widget.t_id, sets: 1, reps: repsDefault, weights: weightDefault, difficulty: 0, e_id: widget.e_id));
                                  }
                                  saveList(listOfSets.data);
                                  widget.setSubmitAllowed(true);
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
  }

  Widget TrainSet(List<TrainingSet> list, int index) {

    if (index ==list.length){
      list.add(TrainingSet(t_id: widget.t_id, sets: 1, reps: widget.reps, weights: widget.weight, e_id: widget.e_id));
    }

    TrainingSet item = list[index];

    return Container(
      color: index.isOdd ? Color(0xff6D6D6D) : cardDropDown,

      child: Padding(
        padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                color: background,
                height: 27,
                //margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Text(
                        "Set ${index + 1}", textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                height: 27,
                color: background,
                child: Row(
                  children: [
                    Container(
                      height: 27,
                      color: cardBack,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: Text("reps",
                              style: TextStyle(color: cardDropText)
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 27,
                      width: 70,
                      color: background,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: TextFormField(
                            maxLines: 1,
                            decoration: new InputDecoration(
                              isDense: true,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                            ),
                            initialValue: item.reps,
                            onChanged: (text) {
                              takeReps(text, index, list);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                height: 27,
                color: background,
                child: Row(
                  children: [
                    Container(
                      height: 27,
                      color: cardBack,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: Text("weight",
                              style: TextStyle(color: cardDropText)
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 27,
                      width: 70,
                      color: background,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: TextFormField(

                            maxLines: 1,
                            decoration: new InputDecoration(
                              isDense: true,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                            ),
                            initialValue: item.weights,
                            onChanged: (text) {
                              // _weightController.text = text;
                              takeWeight(text, index, list);
                            },

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0,40);
    path.lineTo(30,0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}


