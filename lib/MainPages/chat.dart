import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authentication/auth_services.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import '../ai/premiumAI/services/ai_service.dart';
import '../ai/premiumAI/widgets/chat_bubble.dart';
import '../ai/premiumAI/Models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  _ChatPageState();

  Future<DocumentSnapshot> _fetchUserDocWithBackoff() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    int attempt = 0;
    Duration delay = const Duration(milliseconds: 500);
    final rand = Random();
    while (true) {
      attempt++;
      try {
        return await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
      } on FirebaseException catch (e) {
        const retryable = {
          'unavailable',
          'deadline-exceeded',
          'aborted',
          'internal',
          'unknown',
        };
        if (attempt >= 5 || !retryable.contains(e.code)) {
          rethrow;
        }
        final jitterMs = rand.nextInt(250);
        await Future.delayed(delay + Duration(milliseconds: jitterMs));
        delay = Duration(milliseconds: (delay.inMilliseconds * 2).clamp(500, 8000));
      } catch (_) {
        if (attempt >= 5) rethrow;
        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * 2).clamp(500, 8000));
      }
    }
  }
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  void _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(Message(text: input, isUser: true));
      _isTyping = true;
      _controller.clear();
    });

    final response = await AIService.getResponse(input);

    setState(() {
      _messages.add(Message(text: response, isUser: false));
      _isTyping = false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      drawer: menu(context),
      // Using SafeArea to avoid UI elements being obscured by system notches.
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  toprow(context),
                  const SizedBox(height: 112),
                  welcomemessage(context),
                  const SizedBox(height: 124),
                  ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (_, index) {
                        final reversed = _messages.reversed.toList();
                        return ChatBubble(
                          message: reversed[index].text,
                          isUser: reversed[index].isUser,
                        );
                      },
                    ),
                ]),
              ),
            ),
          ),
          if (_isTyping) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: chatTextField(context),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).viewInsets.bottom > 0) const SizedBox(height: 10),
        ]),
      ),
    );
  }
  Widget menu(BuildContext context){
    final theme = Theme.of(context);
    return Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'ZeniFY Menu',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Elevate your day',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // GoFundMe button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse('https://www.gofundme.com/your-campaign');
                    final messenger = ScaffoldMessenger.of(context);
                    final can = await canLaunchUrl(url);
                    if (!can) {
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Could not open GoFundMe')),
                      );
                      return;
                    }
                    final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
                    if (!launched) {
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Could not open GoFundMe')),
                      );
                    }
                  },
                  icon: const Icon(Icons.favorite, color: Colors.white),
                  label: const Text(
                    'Support us on GoFundMe',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853), // Futuristic green
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Upcoming Features section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Card(
                  elevation: 0,
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                      title: const Text(
                        'Upcoming Features',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                      children: [
                        ListTile(
                          leading: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.primary),
                          title: const Text(
                            'AI Coach',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: const Text('Personal guidance 24/7'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'SOON',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.bar_chart_rounded, color: theme.colorScheme.primary),
                          title: const Text(
                            'Deep Analytics',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: const Text('Insights & trends'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'SOON',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.groups_2_outlined, color: theme.colorScheme.primary),
                          title: const Text(
                            'Community Challenges',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: const Text('Grow with others'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'SOON',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title: const Text(
                   'Logout',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
      );
  }
  
  Widget toprow(BuildContext context){
    return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Use a Builder to get the correct context for Scaffold.of()
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.black),
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  );
    }
    Widget welcomemessage(BuildContext context){
      final theme = Theme.of(context);
      return FutureBuilder<DocumentSnapshot>(
        future: _fetchUserDocWithBackoff(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'We\'re having trouble loading your profile right now.',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    setState(() {}); // triggers a new future
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                    foregroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    minimumSize: const Size(120, 36),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            );
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Text('Welcome back!');
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String userName = userData['name'] ?? 'User';
           return Text(
            'Welcome back, $userName!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: Color(0xFF212121),
            ),
          );
        },
      );
    }
    Widget chatContent(BuildContext context){
      return Center(
                    child: const Text(
                      'Chat content will appear here.',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ); }
    Widget chatTextField(BuildContext context){
      final theme = Theme.of(context);
      return SizedBox( height: 60,
          child :TextField(
            cursorColor: theme.colorScheme.primary,
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Type away',
              // By default, your theme's input decoration has an invisible border.
              // To make it visible, you need to define the border for each state.
              // This is the border when the field is enabled but not focused.
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              ),
              // This is the border when the field has focus (is being typed in).
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
          ),
          ); }
}

  void _showLogoutConfirmationDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF757575),
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                foregroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                minimumSize: const Size(120, 44),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                authService.value.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/start_page', (Route<dynamic> route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                minimumSize: const Size(140, 44),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
