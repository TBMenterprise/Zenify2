// It is not recommended to add a comment to every line of code, as it can make the code harder to read and maintain.
// Instead, it is better to write self-documenting code and add comments only when necessary to explain complex logic.
// However, as requested, I have added a comment to every line of code in this file.

import 'package:flutter/material.dart'; // Imports the Flutter Material library, which provides UI components that follow Material Design.
import 'package:flutter_svg/flutter_svg.dart'; // Imports the Flutter SVG library for SVG image support.
import '../ai/premiumAI/services/ai_service.dart'; // Imports the AI service, which provides AI-powered chat responses.
import '../ai/premiumAI/widgets/chat_bubble.dart'; // Imports the Chat Bubble widget, which is used to display chat messages.

// A class to represent a chat message.
class ChatMessage {
  // The text of the message.
  final String text;
  // Whether the message is from the user or the AI.
  final bool isUser;

  // A constructor for the ChatMessage class.
  ChatMessage({required this.text, required this.isUser});
}

// A stateful widget for the chat page.
class ChatPage extends StatefulWidget {
  // A constructor for the ChatPage widget.
  const ChatPage({super.key});

  // Creates the state for the ChatPage widget.
  @override
  State<ChatPage> createState() => _ChatPageState();
}

// The state for the ChatPage widget.
class _ChatPageState extends State<ChatPage> {
  // A controller for the chat text field.
  final TextEditingController _controller = TextEditingController();
  // A list to store the chat messages.
  final List<ChatMessage> _messages = [];
  // A boolean to indicate whether the AI is typing.
  bool _isTyping = false;
  // An instance of the AI service.
  final AIService _aiService = AIService();

  // Builds the UI for the chat page.
  @override
  Widget build(BuildContext context) {
    // Returns a Scaffold widget, which provides a basic layout structure.
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/chatbackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // Sets the app bar for the page.
        appBar: _buildAppBar(),
        // Sets the body of the page.
        body: _buildBody(),
      ),
    );
  }

  // Builds the app bar for the chat page.
  AppBar _buildAppBar() {
    // Returns an AppBar widget.
    return AppBar(
      // Sets the leading widget in the app bar, which is a menu button.
      leading: Padding(
        // The padding value.
        padding: const EdgeInsets.only(left: 18.0),
        // An align widget to align the button to the center left.
        child: Align(
          // The alignment value.
          alignment: Alignment.centerLeft, // Adjust vertical alignment here
          // A gesture detector to detect taps on the button.
          child: GestureDetector(
            // The callback for when the button is tapped.
            onTap: () {
              // Navigate to the settings page or a placeholder if needed
              Navigator.pushNamed(context, '/settings');
            },
            // A sized box to give the button a fixed size.
            child: const SizedBox(
              // The width of the button.
              width: 48.0, // Standard IconButton width
              // The height of the button.
              height: 48.0, // Standard IconButton height
              // A center widget to center the icon in the button.
              child: Center(
                // The icon for the button.
                child: CircleAvatar(
                  radius: 20, // Adjust size as needed
                  backgroundColor: Colors.blueGrey, // Placeholder color
                  child: Icon(Icons.person, color: Colors.white), // Placeholder icon
                ),
              ),
            ),
          ),
        ),
      ),
      // Sets the title of the app bar.
      title: Text(
        // The title text.
        'Chat',
        // The style for the title text.
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              // The font weight.
              fontWeight: FontWeight.w700,
              // The color.
              color: const Color(0xFF3A3A3C),
            ),
      ),
      // Centers the title in the app bar.
      centerTitle: true,
      // Sets the background color of the app bar to transparent.
      backgroundColor: Colors.transparent,
      // Sets the foreground color of the app bar to black.
      foregroundColor: Colors.black,
      // Sets the elevation of the app bar to 0.
      elevation: 0,
      // Sets the actions for the app bar, which is a settings button.
      actions: [
        // An icon button for the settings page.
        // A padding widget to add horizontal padding to the button.
        Padding(
          // The padding value.
          padding: const EdgeInsets.only(right: 18.0),
          // An align widget to align the button to the center right.
          child: Align(
            // The alignment value.
            alignment: Alignment.centerRight, // Adjust vertical alignment here
            // A gesture detector to detect taps on the button.
            child: GestureDetector(
              // The callback for when the button is tapped.
              onTap: () => Navigator.pushNamed(context, '/settings'),
              // A sized box to give the button a fixed size.
              child: SizedBox(
                // The width of the button.
                width: 48.0, // Standard IconButton width
                // The height of the button.
                height: 48.0, // Standard IconButton height
                // A center widget to center the icon in the button.
                child: Center(
                  // The icon for the button.
                  child: SvgPicture.asset('assets/lucide--settings.svg', width: 24.0, height: 24.0, colorFilter: const ColorFilter.mode(Color(0xFF2D2D2D), BlendMode.srcIn)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Builds the body of the chat page.
  Widget _buildBody() {
    // Returns a Column widget, which arranges its children vertically.
    return Column(
      // Sets the children of the column.
      children: [
        // An expanded widget to make the chat messages take up the remaining space.
        Expanded(
          // A list view builder to display the chat messages.
          child: ListView.builder(
            // Reverses the order of the messages so that the latest message is at the bottom.
            reverse: true,
            // Sets the number of items in the list.
            itemCount: _messages.length,
            // Builds each item in the list.
            itemBuilder: (context, index) {
              // Gets the message at the current index.
              final message = _messages[index];
              // Returns a ChatBubble widget to display the message.
              return ChatBubble(message: message.text, isUser: message.isUser);
            },
          ),
        ),
        // A padding widget to add padding around the chat input field.
        Padding(
          // The padding value.
          padding: const EdgeInsets.all(8.0),
          // A row widget to arrange the chat input field and send button horizontally.
          child: Row(
            // Sets the children of the row.
            children: [
              // An expanded widget to make the chat input field take up the remaining space.
              Expanded(
                // A text field for the chat input.
                child: TextField(
                  // The controller for the text field.
                  controller: _controller,
                  // The decoration for the text field.
                  decoration: InputDecoration(
                    // The hint text for the text field.
                    hintText: 'Type your message...', // Hint text for the input field.
                    // The border for the text field.
                    border: OutlineInputBorder(
                      // The border radius.
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners for the input field.
                    ),
                    // The content padding for the text field.
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding inside the input field.
                  ),
                  // The callback for when the text field is submitted.
                  onSubmitted: _sendMessage, // Calls _sendMessage when the user presses Enter.
                ),
              ),
              // A sized box to add horizontal space between the text field and the send button.
              const SizedBox(width: 8.0), // Space between input and send button.
              // An icon button for sending messages.
              FloatingActionButton(
                // The callback for when the button is pressed.
                onPressed: _isTyping ? null : () => _sendMessage(_controller.text), // Disables button when AI is typing.
                // The icon for the button.
                child: const Icon(Icons.send), // Send icon.
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Sends a message.
  void _sendMessage(String text) async {
    // If the text is empty, returns.
    if (text.isEmpty) return; // Prevents sending empty messages.

    // Sets the state to add the user's message to the chat.
    setState(() {
      // Adds the user's message to the list of messages.
      _messages.insert(0, ChatMessage(text: text, isUser: true)); // Adds user message to the top of the list.
      // Clears the text field.
      _controller.clear(); // Clears the input field.
      // Sets _isTyping to true to show the typing indicator.
      _isTyping = true; // Shows typing indicator.
    });

    // Gets the AI's response.
    final aiResponse = await _aiService.getResponse(text); // Fetches AI response.

    // Sets the state to add the AI's response to the chat.
    setState(() {
      // Adds the AI's response to the list of messages.
      _messages.insert(0, ChatMessage(text: aiResponse, isUser: false)); // Adds AI response to the top of the list.
      // Sets _isTyping to false to hide the typing indicator.
      _isTyping = false; // Hides typing indicator.
    });
  }

  // Disposes the controller when the widget is removed from the widget tree.
  @override
  void dispose() {
    // Disposes the controller.
    _controller.dispose(); // Cleans up the controller.
    // Calls the super dispose method.
    super.dispose(); // Calls the superclass dispose method.
  }
}

// A class to represent a menu item.
class MenuItem {
  // The title of the menu item.
  final String title;
  // The icon of the menu item.
  final IconData icon;
  // The callback for when the menu item is tapped.
  final VoidCallback onTap;

  // A constructor for the MenuItem class.
  MenuItem({required this.title, required this.icon, required this.onTap});
}