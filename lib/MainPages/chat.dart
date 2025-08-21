import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  Future<DocumentSnapshot> _fetchUserDocWithBackoff() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('No Firebase user');
    int attempt = 0;
    Duration delay = const Duration(milliseconds: 500);
    final rand = Random();
    while (true) {
      attempt++;
      try {
        return await FirebaseFirestore.instance.collection('users').doc(uid).get();
      } on FirebaseException catch (e) {
        const retryable = {'unavailable', 'deadline-exceeded', 'aborted', 'internal', 'unknown'};
        if (attempt >= 5 || !retryable.contains(e.code)) rethrow;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: Builder(builder: (context) => IconButton(icon: const Icon(Icons.menu, color: Color(0xFF2D2D2D)), onPressed: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final Offset topLeft = button.localToGlobal(Offset.zero);
          final Size size = button.size;
          _showMainMenu(context, topLeft, size);
        })),
        title: const Text('Chat', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w700, fontSize: 28, color: Color(0xFF3A3A3C), height: 1.2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.settings, color: Color(0xFF2D2D2D)), onPressed: () => Navigator.pushNamed(context, '/settings'))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
                  child: Column(children: [
                    const SizedBox(height: 8),
                    FutureBuilder<DocumentSnapshot>(
                      future: _fetchUserDocWithBackoff(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()));
                        if (snapshot.hasError) return const Text('Welcome back!');
                        if (!snapshot.hasData || snapshot.data!.data() == null) return const Text('Welcome back!');
                        final userData = snapshot.data!.data() as Map<String, dynamic>;
                        final String userName = userData['name'] ?? 'User';
                        return Text('Welcome back, $userName!', textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w700, fontSize: 28, color: Color(0xFF212121)));
                      },
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (_, index) {
                        final reversed = _messages.reversed.toList();
                        return ChatBubble(message: reversed[index].text, isUser: reversed[index].isUser);
                      },
                    ),
                  ]),
                ),
              ),
            ),
            if (_isTyping) const LinearProgressIndicator(),
            Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Expanded(child: _chatTextField(context)), IconButton(icon: const Icon(Icons.send, color: Colors.blue), onPressed: _sendMessage)])),
            if (MediaQuery.of(context).viewInsets.bottom > 0) const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _chatTextField(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 60,
      child: TextField(
        cursorColor: theme.colorScheme.primary,
        controller: _controller,
        onSubmitted: (_) => _sendMessage(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Type away',
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0), borderRadius: const BorderRadius.all(Radius.circular(30.0))),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0), borderRadius: const BorderRadius.all(Radius.circular(30.0))),
        ),
      ),
    );
  }

  PopupMenuItem<int> _buildMenuItem({required BuildContext context, required IconData icon, required String text, required VoidCallback onTap, Color textColor = const Color(0xFF2D2D2D)}) {
    return PopupMenuItem<int>(
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: 240,
        height: 48,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(children: [Icon(icon, color: Colors.black), const SizedBox(width: 12), Expanded(child: Text(text, style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w500, fontSize: 16, color: textColor)))]),
          ),
        ),
      ),
    );
  }

  void _showMainMenu(BuildContext context, Offset anchor, Size anchorSize) async {
    final position = RelativeRect.fromLTRB(anchor.dx, anchor.dy + anchorSize.height, anchor.dx + anchorSize.width, anchor.dy);
    await showMenu<int>(
      context: context,
      position: position,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFEAEAEA), width: 1)),
      elevation: 4,
      items: [
        _buildMenuItem(context: context, icon: Icons.history, text: 'Conversations', onTap: () { Navigator.of(context).pop(); Navigator.pushNamed(context, '/conversations'); }),
        _buildMenuItem(context: context, icon: Icons.more_horiz, text: 'More', onTap: () { Navigator.of(context).pop(); _showSecondaryMenu(context, anchor + Offset(0, anchorSize.height + 8), anchorSize); }),
        _buildMenuItem(context: context, icon: Icons.logout, text: 'Logout', onTap: () { Navigator.of(context).pop(); _showLogoutConfirmationDialog(context); }, textColor: const Color(0xFFD32F2F)),
      ],
    );
  }

  void _showSecondaryMenu(BuildContext context, Offset anchor, Size anchorSize) async {
    final position = RelativeRect.fromLTRB(anchor.dx, anchor.dy, anchor.dx + anchorSize.width, anchor.dy);
    await showMenu<int>(
      context: context,
      position: position,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFEAEAEA), width: 1)),
      elevation: 4,
      items: [
        _buildMenuItem(context: context, icon: Icons.favorite, text: 'GoFundMe', onTap: () async {
          Navigator.of(context).pop();
          final url = Uri.parse('https://www.gofundme.com/your-campaign');
          final messenger = ScaffoldMessenger.of(context);
          final can = await canLaunchUrl(url);
          if (!can) {
            messenger.showSnackBar(const SnackBar(content: Text('Could not open GoFundMe')));
            return;
          }
          final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
          if (!launched) messenger.showSnackBar(const SnackBar(content: Text('Could not open GoFundMe')));
        }),
        _buildMenuItem(context: context, icon: Icons.upcoming, text: 'Upcoming Features', onTap: () { Navigator.of(context).pop(); _showUpcomingFeaturesDialog(context); }),
      ],
    );
  }

  void _showUpcomingFeaturesDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Upcoming Features', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF212121))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(leading: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.primary), title: const Text('AI Coach', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w600)), subtitle: const Text('Personal guidance 24/7')),
              ListTile(leading: Icon(Icons.bar_chart_rounded, color: theme.colorScheme.primary), title: const Text('Deep Analytics', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w600)), subtitle: const Text('Insights & trends')),
              ListTile(leading: Icon(Icons.groups_2_outlined, color: theme.colorScheme.primary), title: const Text('Community Challenges', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w600)), subtitle: const Text('Grow with others')),
            ],
          ),
          actions: [OutlinedButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close'))],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Logout', style: TextStyle(fontFamily: 'HelveticaNeue', fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF212121))),
          content: const Text('Are you sure you want to log out?', style: TextStyle(fontFamily: 'HelveticaNeue', fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF757575))),
          actions: <Widget>[
            OutlinedButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
            ElevatedButton(onPressed: () async { Navigator.of(dialogContext).pop(); await FirebaseAuth.instance.signOut(); Navigator.pushNamedAndRemoveUntil(context, '/start_page', (Route<dynamic> route) => false); }, child: const Text('Log Out')),
          ],
        );
      },
    );
  }
}
