import 'package:flutter/material.dart';
import 'package:xcell/models/text_message.dart';
import 'package:xcell/theme/style.dart';

class Chat extends StatefulWidget {
  final List<TextMessage> messages;
  final Function(TextMessage) onSendPressed;

  const Chat({Key key, this.messages, this.onSendPressed}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool hasText = false;
  String message;
  TextMessage sendMessage;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              return widget.messages[index].author_id == 1
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 0, 30, 10),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "${widget.messages[index].message}",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: userMessage,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(30, 10, 10, 0),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "${widget.messages[index].message}",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: userMessage,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: "Give feedback on this exercise...",
                        hintStyle: TextStyle(color: hintMessage),
                        border: InputBorder.none),
                    onChanged: (text) {
                      print(text);
                      if (text != null && text != "") {
                        setState(() {
                          hasText = true;
                        });
                      } else {
                        setState(() {
                          hasText = false;
                        });
                      }
                      setState(() {
                        message = text;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Visibility(
                  visible: hasText,
                  child: FloatingActionButton(
                    onPressed: () {
                      sendMessage = TextMessage(
                        message: message,
                        author_id: 0,
                      );
                      _messageController.clear();
                      hasText = false;
                      widget.onSendPressed(sendMessage);
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16,
                    ),
                    backgroundColor: featureColor,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
