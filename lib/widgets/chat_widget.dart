import 'package:ai_chatbot/utils/app_colors.dart';
import 'package:ai_chatbot/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.index});
  final String msg;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: index == 0 ? AppColors.backgroundColor : AppColors.cardColor,
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                index == 0
                    ? "assets/images/profile.png"
                    : "assets/images/chat_logo.png",
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: index == 0
                      ? CustomTextWidget(label: msg)
                      : AnimatedTextKit(
                          repeatForever: false,
                          isRepeatingAnimation: false,
                          displayFullTextOnTap: true,
                          totalRepeatCount: 1,
                          animatedTexts: [
                              TyperAnimatedText(
                                msg.trim(),
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ])),
              index == 0
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.copy,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: msg.trim()))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: AppColors.buttonColor,
                                      content:
                                          Text('Copied to your clipboard !')));
                            });
                          },
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.thumb_down_outlined,
                          color: AppColors.textColorWhite,
                        )
                      ],
                    )
            ],
          ),
        )
      ],
    );
  }
}
