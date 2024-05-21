import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MassegeResponseContainer extends StatelessWidget {
  final String text;
  final bool isUser;
  const MassegeResponseContainer(
      {super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: isUser ? Colors.indigo : Colors.grey[300],
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: MarkdownBody(
              data: text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: isUser ? Colors.white : Colors.black),
                strong: TextStyle(color: isUser ? Colors.white : Colors.black),
                em: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : Colors.black),
              ),
            ),
          ),
          isUser
              ? const SizedBox()
              : Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          //copy the text
                          Clipboard.setData(ClipboardData(text: text))
                              .then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Center(
                                child: Text('Copied to clipBoard'),
                              ),
                              duration: Duration(seconds: 1),
                            ));
                          });
                        },
                        child: const Icon(
                          Icons.copy,
                          size: 15,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.thumb_down_alt_outlined,
                      size: 15,
                    )
                  ],
                )
        ],
      ),
    );
  }
}
