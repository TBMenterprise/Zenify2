import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authentication/auth_services.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF2D2D2D)),
            onPressed: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final Offset topLeft = button.localToGlobal(Offset.zero);
              final Size size = button.size;
              _showMainMenu(context, topLeft, size);
            },
          ),
        ),
        title: const Text(
          'Chat',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: Color(0xFF3A3A3C),
            height: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF2D2D2D)),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      // Using SafeArea to avoid UI elements being obscured by system notches.
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical:24.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 6),
                  const SizedBox(height: 112),
                  welcomemessage(context),
                  const SizedBox(height: 124),
                  // Additional chat-related widgets will go here.
                  chatContent(context),
                ]),
              ),
            ),
          ),
          chatTextField(context),
          if (MediaQuery.of(context).viewInsets.bottom > 0)
            const SizedBox(height: 10),
        ]),
      ),
    );
     
  }
  
  
  Widget toprow(BuildContext context){
    return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu icon now anchors the dropdown menu (replaces drawer)
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black),
                          onPressed: () {
                            final RenderBox button = context.findRenderObject() as RenderBox;
                            final Offset topLeft = button.localToGlobal(Offset.zero);
                            final Size size = button.size;
                            _showMainMenu(context, topLeft, size);
                          },
                        ),
                      ),
                      // Settings button restored to original behavior
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.black),
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  );
    }

  // Shows the main dropdown menu anchored to the provided position/size.
  void _showMainMenu(BuildContext context, Offset anchor, Size anchorSize) async {
    final RelativeRect position = RelativeRect.fromLTRB(
      anchor.dx,
      anchor.dy + anchorSize.height,
      anchor.dx + anchorSize.width,
      anchor.dy,
    );

    await showMenu<int>(
      context: context,
      position: position,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEAEAEA), width: 1),
      ),
      elevation: 4,
      items: [
        PopupMenuItem<int>(
          value: 1,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 240,
            height: 48,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                // Assumption: route name for conversations
                Navigator.pushNamed(context, '/conversations');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.history, color: Colors.black),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Conversations',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 240,
            height: 48,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                // open the secondary menu anchored slightly below
                _showSecondaryMenu(context, anchor + Offset(0, anchorSize.height + 8), anchorSize);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.more_horiz, color: Colors.black),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'More',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 240,
            height: 48,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                _showLogoutConfirmationDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFFD32F2F), // red for logout text
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
    // selected unused but kept for future use
  }

  // Secondary menu shown when "More" is tapped
  void _showSecondaryMenu(BuildContext context, Offset anchor, Size anchorSize) async {
    final RelativeRect position = RelativeRect.fromLTRB(
      anchor.dx,
      anchor.dy,
      anchor.dx + anchorSize.width,
      anchor.dy,
    );

    await showMenu<int>(
      context: context,
      position: position,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEAEAEA), width: 1),
      ),
      elevation: 4,
      items: [
        PopupMenuItem<int>(
          value: 1,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 240,
            height: 48,
            child: InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                final url = Uri.parse('https://www.gofundme.com/your-campaign');
                final messenger = ScaffoldMessenger.of(context);
                final can = await canLaunchUrl(url);
                if (!can) {
                  messenger.showSnackBar(const SnackBar(content: Text('Could not open GoFundMe')));
                  return;
                }
                final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
                if (!launched) {
                  messenger.showSnackBar(const SnackBar(content: Text('Could not open GoFundMe')));
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(children: const [
                  Icon(Icons.favorite, color: Colors.black),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('GoFundMe', style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF2D2D2D),
                    )),
                  ),
                ]),
              ),
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 240,
            height: 48,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                _showUpcomingFeaturesDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(children: const [
                  Icon(Icons.upcoming, color: Colors.black),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Upcoming Features', style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF2D2D2D),
                    )),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Small dialog listing upcoming features (matches drawer content style)
  void _showUpcomingFeaturesDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Upcoming Features', style: TextStyle(
            fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF212121),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.primary),
                title: const Text('AI Coach', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w600)),
                subtitle: const Text('Personal guidance 24/7'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('SOON', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w700, fontSize: 12, color: theme.colorScheme.primary)),
                ),
              ),
              ListTile(
                leading: Icon(Icons.bar_chart_rounded, color: theme.colorScheme.primary),
                title: const Text('Deep Analytics', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w600)),
                subtitle: const Text('Insights & trends'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('SOON', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w700, fontSize: 12, color: theme.colorScheme.primary)),
                ),
              ),
              ListTile(
                leading: Icon(Icons.groups_2_outlined, color: theme.colorScheme.primary),
                title: const Text('Community Challenges', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w600)),
                subtitle: const Text('Grow with others'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('SOON', style: TextStyle(fontFamily: 'HelveticaNeue', fontWeight: FontWeight.w700, fontSize: 12, color: theme.colorScheme.primary)),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: OutlinedButton.styleFrom(side: BorderSide(color: theme.colorScheme.primary)),
              child: const Text('Close', style: TextStyle(fontFamily: 'HelveticaNeue')),
            ),
          ],
        );
      },
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
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Type away',
              // By default, your theme's input decoration has an invisible border.
              // To make it visible, you need to define the border for each state.
              // This is the border when the field is enabled but not focused.
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              // This is the border when the field has focus (is being typed in).
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100.0),
                  topRight: Radius.circular(100.0),
                  bottomLeft: Radius.circular(100.0),
                  bottomRight: Radius.circular(100.0),

                ),
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

