import 'dart:async';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../constant/images/demo.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final ScrollController scrollController = ScrollController();
  final chatController = TextEditingController();
  final String profileImageUrl = 'https://example.com/profile.jpg';

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(hotelImage[0]),
          ),
          title: const Text(
            "1929 Way",
            style: TextStyle(color: Colors.black),
          ),
          subtitle: const Text(
            "Mzdcom....",
            style: TextStyle(color: kBlack, fontSize: 12),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: controller.messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: index % 2 == 0
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.grey[300]
                                      : Colors.blue[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(messages[index]),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(27.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController,
                    onChanged: (value) =>
                        controller.messageController.value = value,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.sendMessage();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (scrollController.hasClients) {
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent);
                      }
                    });
                    chatController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatController extends GetxController {
  final _messageStreamController = StreamController<List<String>>.broadcast();
  final _messages = <String>[].obs;
  final _timestamps = <DateTime>[].obs;

  Stream<List<String>> get messageStream => _messageStreamController.stream;

  var messageController = ''.obs;

  ChatController() {
    _messageStreamController.add(_messages);
  }

  void sendMessage() {
    if (messageController.value.trim().isNotEmpty) {
      _messages.add(messageController.value);
      _timestamps.add(DateTime.now());
      _messageStreamController.add(_messages);
      messageController.value = '';
    }
  }

  @override
  void onClose() {
    _messageStreamController.close();
    super.onClose();
  }
}
