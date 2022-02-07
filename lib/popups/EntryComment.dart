import 'package:flutter/material.dart';
import 'package:xcell/api_connection/set_feedback.dart';
import 'package:xcell/database/set_database.dart';
import 'package:xcell/theme/style.dart';

import '../chat/chat.dart';
import '../models/text_message.dart';

class CommentPopup extends StatefulWidget {

  final String name;
  final String comment;
  final int t_id;
  final Function(bool) setSubmitAllowed;

  const CommentPopup({
    Key key,
    this.comment,
    this.name,
    this.t_id,
    this.setSubmitAllowed
  }) : super(key: key);

  @override
  _CommentPopupState createState() => _CommentPopupState();
}

class _CommentPopupState extends State<CommentPopup> {
  final set_db = SetDatabase.instance;
  bool setsHasData = false;
  List<TextMessage> _messages = [];

  void _handleSendPressed(TextMessage message) {
    Map<String, dynamic> row;
    final feedback = TextMessage(
      author_id: 0,
      message: message.message,

    );
    _addMessage(feedback);
    String combinedFeedback = "";
    for (final message in _messages){
      if (message.author_id == 0) {
        combinedFeedback = message.toJson()['message']+", "+combinedFeedback;
      }

    }
    combinedFeedback=combinedFeedback.substring(0, combinedFeedback.length - 2);
    if (setsHasData){
      set_db.updateComment(widget.t_id, combinedFeedback);
    }
    else{
      row = {
        't_id': widget.t_id,
        'sets': -1,
        'reps': "-1",
        'weights': "-1",
        'difficulty': 0,
        'comment':combinedFeedback,
        'e_id': 0,
      };
      set_db.insert(row);
    }
    widget.setSubmitAllowed(true);
  }

  void _addMessage(TextMessage message) {
    setState(() {
      _messages.insert(_messages.length,message);
    });
  }
  Future<String> _getCurrentFeedback() async {
    List setFeedback = await getSetFeedback(widget.t_id);
    return setFeedback[0];
  }
  Future<void> _useCurrentFeedback() async{
    var sets = await set_db.queryID(widget.t_id);
    var combinedFeedback;
    if (sets.length > 0){
      setsHasData = true;
      combinedFeedback = sets[0].comment;
      if (combinedFeedback == '###' || combinedFeedback == null){
        combinedFeedback = "";
      }
    }
    else{
      setsHasData = false;
      combinedFeedback = "";
    }
    print(combinedFeedback);
    var splitFeedback = combinedFeedback.split(', ');
    // print("split: $splitFeedback");
    for (final feedback in splitFeedback){
      if (feedback != "dif" && feedback != "") {
        final feedbackMessage = TextMessage(
          author_id: 0,
          message: feedback,
        );
        _messages.insert(0, feedbackMessage);
      }
    }
    setState(() {
      _messages=_messages.reversed.toList();
    });
  }
  void _initialiseComment(){
    print(widget.comment);
    if (widget.comment != "") {
      final commentMessage = TextMessage(
        author_id: 1,
        // authorId: "${entry["sender"]}",
        message: widget.comment,
      );
      setState(() {
        _messages.add(commentMessage);
      });
    }
    _useCurrentFeedback();

  }

  @override
  void initState() {
    _initialiseComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return AlertDialog(
      backgroundColor: cardBack,
      insetPadding: EdgeInsets.fromLTRB(0,150,0,50),
      title: Padding(
        padding: EdgeInsets.fromLTRB(0,5,0,5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            color: background,
            padding: EdgeInsets.all(5),
            // height:31,
            child:Center(
              child: Text("${widget.name}",
                  textAlign: TextAlign.center,
                style: TextStyle(),
              ),
            ),
          ),
        ),
      ),


      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 400,
              width: 300,

              // heightFactor: 0.1,
              // widthFactor: 0.8,
              child: Chat(
                  messages: _messages,
                  onSendPressed: _handleSendPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

}