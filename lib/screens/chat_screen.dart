import 'dart:developer';
import 'package:ai_chatbot/provider/chat_provider.dart';
import 'package:ai_chatbot/provider/models_provider.dart';
import 'package:ai_chatbot/utils/app_colors.dart';
import 'package:ai_chatbot/widgets/chat_widget.dart';
import 'package:ai_chatbot/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController _textEditingController;
  late ScrollController scrollController;

  late FocusNode focusNode;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    focusNode = FocusNode();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ModelProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("AI CHATBOT",
            style: TextStyle(color: AppColors.textColorWhite)),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: chatProvider.getchatList.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                return ChatWidget(
                  msg: chatProvider.getchatList[index].msg,
                  index: chatProvider.getchatList[index].chatIndex,
                );
              },
            ),
          ),
          if (_isTyping) ...[
            const SpinKitThreeBounce(
              color: AppColors.textColorWhite,
              size: 18,
            ),
          ],
          const SizedBox(height: 15),
          Container(
            color: AppColors.cardColor,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: _textEditingController,
                    style: const TextStyle(
                      color: AppColors.textColorWhite,
                    ),
                    onSubmitted: (value) async {
                      await sendMessages(
                          provider: provider, chatProvider: chatProvider);
                    },
                    decoration: const InputDecoration.collapsed(
                        hintText: "How can i help you?",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sendMessages(
                          provider: provider, chatProvider: chatProvider);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.textColorWhite,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessages({
    required ModelProvider provider,
    required ChatProvider chatProvider,
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: CustomTextWidget(
              label: "You can't send multiple messages.",
            ),
            backgroundColor: AppColors.redColor),
      );
      return;
    }
    if (_textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomTextWidget(
            label: "Please type a message",
          ),
          backgroundColor: AppColors.redColor,
        ),
      );
      return;
    }
    try {
      String sendMsg = _textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: sendMsg);
        _textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.botMessage(
        msg: sendMsg,
        modelID: provider.currentModel,
      );
      setState(() {});
    } catch (e) {
      log("error is: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomTextWidget(
          label: e.toString(),
        ),
        backgroundColor: AppColors.redColor,
      ));
    } finally {
      setState(() {
        scrollToEnd();
        _isTyping = false;
      });
    }
  }
}
