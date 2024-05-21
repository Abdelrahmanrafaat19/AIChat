import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gemini_ai/components/massege_response_container.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../components/text_field.dart';
import '../const/constatnt.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apikey);
  //for storing the responses
  List<Map<String, dynamic>> aiChat = [];

  //scrolling controller
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Gemini AI',
          style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
                child: ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          MassegeResponseContainer(
                              text: aiChat[index].keys.first, isUser: true),

                          const SizedBox(
                            height: 10,
                          ),
                          MassegeResponseContainer(
                              text: aiChat[index].values.first, isUser: false),

                          //regenerate response if loading is false
                          (isLoading == true || index != aiChat.length - 1)
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 78.0),
                                  child: InkWell(
                                    onTap: () {
                                      isLoading = true;
                                      aiResponse(
                                          aiChat[aiChat.length - 1].keys.first);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      color: Colors.indigo,
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.refresh,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Regenerate Response',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: aiChat.length)),

            //displaying loading
            isLoading
                ? const SpinKitThreeBounce(
                    color: Colors.indigo,
                  )
                : const SizedBox(),

            const SizedBox(
              height: 16,
            ),

            //text field and button
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[200],
                        ),
                        child: HomeTextField(controller: controller),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    isLoading
                        ? const SizedBox()
                        : CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 72, 193, 76),
                            child: IconButton(
                              icon: isLoading
                                  ? const SizedBox()
                                  : const Icon(Icons.send),
                              onPressed: () {
                                if (controller.text.isEmpty) {
                                  //do nothing
                                  debugPrint('please write inside text field');
                                } else {
                                  //Hide the keyboard
                                  FocusScope.of(context).unfocus();
                                  isLoading = true;
                                  aiResponse(controller.text);
                                  setState(() {});
                                }
                              },
                              color: Colors.indigo,
                            ),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //function for AI response
  void aiResponse(String promptText) async {
    try {
      final response = await model.generateContent([Content.text(promptText)]);
      setState(() {
        aiChat.add({promptText: response.text});
        controller.clear();

        //automatically scroll down when new response is added
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        isLoading = false;
      });
    } catch (error) {
      isLoading = false;
    }
  }

  //dispose the controllers
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _scrollController.dispose();
  }
}
