import 'package:flutter/material.dart';
import 'package:major_project/API/apis.dart';
import 'package:major_project/Uitlity/My_date_util.dart';
import 'package:major_project/model/messages.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.messages}) : super(key: key);
  final Messages messages;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIS.user.uid == widget.messages.fromID
        ? receiverMessage()
        : senderMessage();
  }

  Widget senderMessage() {
    if(widget.messages.read!.isEmpty){
      APIS.updateMessageReadStatus(widget.messages);
    }
    return Row(
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomRight: Radius.circular(30))),
            child: Text(
              widget.messages.msg.toString(),
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.messages.send.toString()),style: const TextStyle(fontSize: 11,color: Colors.black),),
        ),

        // double tick
        if(widget.messages.read!.isNotEmpty)
          const Icon(Icons.done_all_rounded,color: Colors.blue,),
      ],
    );
  }

  Widget receiverMessage() {


    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //double text
        if(widget.messages.read!.isNotEmpty)
        const Icon(Icons.done_all_rounded,color: Colors.blue,),
        // send timing
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.messages.send.toString()),style: const TextStyle(fontSize: 11,color: Colors.black),),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(30))),
            child: Text(
              widget.messages.msg.toString(),
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
