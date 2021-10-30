import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:xcell/api_connection/set_feedback.dart';
import 'package:xcell/theme/style.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class CommentPopup extends StatefulWidget {

  final String name;
  final String comment;
  final int t_id;
  const CommentPopup({
    Key key,
    this.comment,
    this.name,
    this.t_id
  }) : super(key: key);

  @override
  _CommentPopupState createState() => _CommentPopupState();
}

class _CommentPopupState extends State<CommentPopup> {

  final _user = const types.User(id: '0');
  List<types.Message> _messages = [];

  void _handleSendPressed(types.PartialText message) {
    print("id == ${_user.id}");
    final feedback = types.TextMessage(
      authorId: _user.id,
      id: "0",
      text: message.text,

    );
    _addMessage(feedback);
    String combinedFeedback = "";
    for (final message in _messages){
      if (message.authorId == "0") {
        combinedFeedback = message.toJson()['text']+", "+combinedFeedback;
      }

    }
    combinedFeedback=combinedFeedback.substring(0, combinedFeedback.length - 2);
    SetFeedback(widget.t_id, combinedFeedback);

  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0,message);
    });
  }
  Future<String> _getCurrentFeedback() async {
    List setFeedback = await getSetFeedback(widget.t_id);
    return setFeedback[0];
  }
  Future<void> _useCurrentFeedback() async{
    var combinedFeedback = await _getCurrentFeedback();
    var splitFeedback = combinedFeedback.split(', ');
    for (final feedback in splitFeedback){
      final feedbackMessage = types.TextMessage(
        authorId:  "0",
        // authorId: "${entry["sender"]}",
        id: "0",
        text: feedback,
      );
      _messages.insert(0,feedbackMessage);
    }

    setState(() {
      _messages=_messages;
    });
  }
  void _initialiseComment(){

    final commentMessage = types.TextMessage(
      authorId:  "1",
      // authorId: "${entry["sender"]}",
      id: "0",
      text: widget.comment,
    );
    setState(() {
      _messages.add(commentMessage);
    });
    _useCurrentFeedback();


  }

  @override
  void initState() {
    _initialiseComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      backgroundColor: cardBack,
      title: Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            color: background,
            padding: EdgeInsets.all(5),
            // height:31,
            child:Center(
              child: Text("${widget.name}",
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),


      content: SizedBox(
        height:300,
        child: Chat(
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user
        )
      ),
    );
  }

}