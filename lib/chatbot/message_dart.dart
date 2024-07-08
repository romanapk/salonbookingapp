// import 'package:dialog_flowtter/dialog_flowtter.dart';
// import 'package:flutter/material.dart';
//
// import 'chat.dart';
//
// class DialogeChat extends StatefulWidget {
//   const DialogeChat({Key? key}) : super(key: key);
//
//   @override
//   _DialogeChatState createState() => _DialogeChatState();
// }
//
// class _DialogeChatState extends State<DialogeChat> {
//   late DialogFlowtter dialogFlowtter;
//   final TextEditingController _controller = TextEditingController();
//
//   List<Map<String, dynamic>> messages = [];
//
//   @override
//   void initState() {
//     DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         child: Column(
//           children: [
//             Expanded(child: MessagesScreen(messages: messages)),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                   colors: [
//                     Color.fromRGBO(210, 217, 223, 1),
//                     Color.fromRGBO(147, 187, 222, 1),
//                   ],
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                       child: TextField(
//                     controller: _controller,
//                     style: const TextStyle(color: Colors.white),
//                   )),
//                   IconButton(
//                       onPressed: () {
//                         sendMessage(_controller.text);
//                         _controller.clear();
//                       },
//                       icon: const Icon(
//                         Icons.send,
//                         color: Colors.white,
//                       ))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   sendMessage(String text) async {
//     if (text.isEmpty) {
//       print('Message is empty');
//     } else {
//       setState(() {
//         addMessage(Message(text: DialogText(text: [text])), true);
//       });
//
//       DetectIntentResponse response = await dialogFlowtter.detectIntent(
//           queryInput: QueryInput(text: TextInput(text: text)));
//       if (response.message == null) return;
//       setState(() {
//         addMessage(response.message!);
//       });
//     }
//   }
//
//   addMessage(Message message, [bool isUserMessage = false]) {
//     messages.add({'message': message, 'isUserMessage': isUserMessage});
//   }
// }
