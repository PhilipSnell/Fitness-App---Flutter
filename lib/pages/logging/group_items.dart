import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xcell/database/tracking_data.dart';
import 'package:xcell/models/group.dart';
import 'package:xcell/theme/style.dart';

class groupPage extends StatefulWidget {
  final DateTime day;
  final dynamic item;
  final Function(bool) valueChanged;
  const groupPage({
    Key key,
    this.item,
    this.day,
    this.valueChanged
  }) : super(key: key);

  @override
  _groupPageState createState() => _groupPageState();
}

class _groupPageState extends State<groupPage> {
  final tracking_db = TrackingDatabase.instance;
  List<String> _values = [];
  Future<Null> loadList() async{
    var field_ids = [];
    for (final textfield in widget.item.textfields) {
      field_ids.add(textfield.id);
    }
    List<TextValue> tmp_list = await tracking_db.queryID(field_ids,widget.day);
    List<String> tmp_list_expanded = [];
    for (final textField in widget.item.textfields){
      var valFlag = 0;
      for (final val in tmp_list){
        if (val.id == textField.id){
          tmp_list_expanded.add(val.value);
          valFlag = 1;
        }

      }
      if (valFlag == 0){
        tmp_list_expanded.add("");
      }
      else{
        valFlag = 0;
      }
    }
    print(tmp_list_expanded);
    setState(() {
      _values = tmp_list_expanded;
    });

  }
  @override
  void initState(){
    loadList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: background,
          centerTitle: true,
          title: Text('${widget.item.name}')
      ),
      body: Column(
        children: [

          GridView.count(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            crossAxisCount: 1,
            childAspectRatio: (6 / 1),
            children: List.generate(widget.item.textfields.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 30,
                    color: cardBack,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left:15),
                            child: Text("${widget.item.textfields[index].name}",
                                style: TextStyle(
                                  color: cardText,
                                  fontSize: 18,
                                )),

                          ),
                        ),
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  color: groupItemInput,
                                  child: !widget.item.textfields[index].type
                                      ? TextFormField(
                                    //
                                    textAlign: TextAlign.center,
                                    initialValue: _values.isNotEmpty
                                              ?_values[index]
                                              :getBlank,
                                    onChanged: (val) {
                                      saveVals(val, widget.item.textfields[index].id);
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Enter Value"
                                    ),
                                  )
                                      : TextFormField(
                                    textAlign: TextAlign.center,
                                    initialValue: _values.isNotEmpty
                                        ?_values[index]
                                        :getBlank,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    onChanged: (val) {
                                      saveVals(val, widget.item.textfields[index].id);
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Enter Value"
                                    ),
                                  ),
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void saveVals(String value, int fieldId) async{
    widget.valueChanged(true);
    Map<String, dynamic> row;
    row = {
      'field_id': fieldId,
      'date': widget.day.toString(),
      'value': value,
    };
    var result = await tracking_db.update(row);
    if(result==null){
      print("failed to save field value");

    }
    else{
      print("succesfully saved field value");
    }
  }

  getBlank() async{
    setState(() {

    });
    return "";
  }

}
