import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../ai/premiumAI/services/ai_service.dart';
import '../ai/premiumAI/widgets/chat_bubble.dart';
import '../widgets/send_message_button.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  final AIService _aiService = AIService();
  bool _isDropdownOpen = false;
  bool _showWelcomeCard = true;
  late AnimationController _animationController;
  late AnimationController _welcomeCardController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _welcomeCardAnimation;
  final GlobalKey _hamburgerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _welcomeCardController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _welcomeCardAnimation = CurvedAnimation(
      parent: _welcomeCardController,
      curve: Curves.easeInOut,
    );
    
    // Start with welcome card visible
    _welcomeCardController.forward();
    
    // Listen to text changes to auto-dismiss welcome card
    _controller.addListener(_onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/chatbackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            _buildBody(),
            if (_isDropdownOpen) _buildDropdownOverlay(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            key: _hamburgerKey,
            onTap: _toggleDropdown,
            child: Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: _isDropdownOpen ? const Color(0xFF6366F1).withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12.0),
                border: _isDropdownOpen ? Border.all(color: const Color(0xFF6366F1), width: 1.5) : null,
              ),
              child: Center(
                child: AnimatedRotation(
                  turns: _isDropdownOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(
                    'assets/lucide--align-left.svg',
                    width: 24.0,
                    height: 24.0,
                    colorFilter: ColorFilter.mode(
                      _isDropdownOpen ? const Color(0xFF6366F1) : Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'Chat',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 22.0,
              letterSpacing: 0.15,
              height: 1.2,
            ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/settings'),
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/lucide--settings.svg', 
                    width: 24.0, 
                    height: 24.0, 
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface, 
                      BlendMode.srcIn
                    )
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        if (_showWelcomeCard)
          FadeTransition(
            opacity: _welcomeCardAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.3),
                end: Offset.zero,
              ).animate(_welcomeCardAnimation),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.waving_hand,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        const Expanded(
                          child: Text(
                            'Welcome to Zenify Chat!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _dismissWelcomeCard,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Hello there! I\'m your AI assistant, ready to help you with anything you need. Feel free to ask me questions, get recommendations, or just have a friendly chat!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == 0 ? 8.0 : 12.0,
                ),
                child: ChatBubble(
                  message: message.text, 
                  isUser: message.isUser
                ),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width > 600 ? 24.0 : 20.0,
            16.0,
            MediaQuery.of(context).size.width > 600 ? 24.0 : 20.0,
            20.0,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 52.0,
                      maxHeight: MediaQuery.of(context).size.height * 0.25,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(28.0),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Semantics(
                         label: 'Message input field',
                         hint: 'Type your message to Zenify AI',
                         textField: true,
                         child: TextField(
                           controller: _controller,
                           maxLines: null,
                           minLines: 1,
                           textCapitalization: TextCapitalization.sentences,
                           style: TextStyle(
                             fontSize: 16.0,
                             fontWeight: FontWeight.w400,
                             color: Theme.of(context).colorScheme.onSurface,
                             height: 1.4,
                           ),
                           decoration: InputDecoration(
                             hintText: 'Message Zenify AI...',
                             hintStyle: TextStyle(
                               color: Theme.of(context).colorScheme.onSurfaceVariant,
                               fontSize: 16.0,
                               fontWeight: FontWeight.w400,
                             ),
                             border: InputBorder.none,
                             contentPadding: const EdgeInsets.symmetric(
                               horizontal: 24.0,
                               vertical: 16.0,
                             ),
                             suffixIcon: _controller.text.isNotEmpty
                                 ? Padding(
                                     padding: const EdgeInsets.only(right: 8.0),
                                     child: AnimatedScale(
                                       scale: _controller.text.isNotEmpty ? 1.0 : 0.0,
                                       duration: const Duration(milliseconds: 200),
                                       child: Semantics(
                                         label: 'Clear message',
                                         hint: 'Clear the current message',
                                         button: true,
                                         child: IconButton(
                                           icon: Icon(
                                             Icons.clear_rounded,
                                             color: Theme.of(context).colorScheme.onSurfaceVariant,
                                             size: 22.0,
                                           ),
                                           onPressed: () {
                                             setState(() {
                                               _controller.clear();
                                             });
                                           },
                                           tooltip: 'Clear message',
                                           splashRadius: 20.0,
                                         ),
                                       ),
                                     ),
                                   )
                                 : null,
                           ),
                           onChanged: (text) {
                             setState(() {}); // Rebuild to show/hide clear button
                           },
                           onSubmitted: _sendMessage,
                         ),
                       ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width > 600 ? 16.0 : 12.0),
                SendMessageButton(
                  onPressed: _controller.text.trim().isNotEmpty && !_isTyping
                      ? () => _sendMessage(_controller.text)
                      : null,
                  isLoading: _isTyping,
                  isEnabled: _controller.text.trim().isNotEmpty,
                  size: MediaQuery.of(context).size.width > 600 ? 56.0 : 52.0,
                  tooltip: 'Send message',
                  enabledColor: const Color(0xFF6366F1),
                  disabledColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  animationDuration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      _controller.clear();
      _isTyping = true;
    });

    final aiResponse = await _aiService.getResponse(text);

    setState(() {
      _messages.insert(0, ChatMessage(text: aiResponse, isUser: false));
      _isTyping = false;
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
    
    if (_isDropdownOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _closeDropdown() {
    if (_isDropdownOpen) {
      setState(() {
        _isDropdownOpen = false;
      });
      _animationController.reverse();
    }
  }

  Widget _buildDropdownOverlay() {
    // Get the RenderBox of the hamburger menu for precise positioning
    final RenderBox? renderBox = _hamburgerKey.currentContext?.findRenderObject() as RenderBox?;
    
    // Default fallback position
    double top = kToolbarHeight + MediaQuery.of(context).padding.top + 8;
    double left = 16.0;
    
    if (renderBox != null) {
      // Get the global position and size of the hamburger button
      final Offset buttonPosition = renderBox.localToGlobal(Offset.zero);
      final Size buttonSize = renderBox.size;
      
      // Calculate position relative to the body (subtract AppBar height and safe area)
      final double appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
      top = buttonPosition.dy - appBarHeight + buttonSize.height + 8.0;
      left = buttonPosition.dx;
      
      // Ensure dropdown doesn't go off-screen horizontally
      final double screenWidth = MediaQuery.of(context).size.width;
      const double dropdownWidth = 280.0;
      if (left + dropdownWidth > screenWidth) {
        left = screenWidth - dropdownWidth - 16.0; // 16px margin from right edge
      }
    }
    
    return GestureDetector(
      onTap: _closeDropdown,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Blurred background overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            // Dropdown menu
            Positioned(
              top: top,
              left: left,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Material(
                    elevation: 24.0,
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: 280.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 30.0,
                            offset: const Offset(0, 12),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDropdownHeader(),
                          const Divider(height: 1, color: Color(0xFFE5E7EB)),
                          _buildDropdownItems(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Zenify User',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItems() {
    final menuItems = [
      DropdownMenuItem(
        icon: Icons.chat_bubble_outline,
        title: 'Conversations',
        subtitle: 'View your chat history',
        onTap: () {
          _closeDropdown();
          // TODO: Navigate to conversations
        },
      ),
      DropdownMenuItem(
        icon: Icons.favorite_outline,
        title: 'Support Us',
        subtitle: 'Help us improve Zenify',
        onTap: () {
          _closeDropdown();
          // TODO: Navigate to support
        },
      ),
      DropdownMenuItem(
        icon: Icons.upcoming_outlined,
        title: 'Upcoming Features',
        subtitle: 'See what\'s coming next',
        onTap: () {
          _closeDropdown();
          // TODO: Navigate to upcoming features
        },
      ),
      DropdownMenuItem(
        icon: Icons.logout_outlined,
        title: 'Log Out',
        subtitle: 'Sign out of your account',
        onTap: () {
          _closeDropdown();
          // TODO: Implement logout
        },
        isDestructive: true,
      ),
    ];

    return Column(
      children: menuItems.map((item) => _buildMenuItem(item)).toList(),
    );
  }

  Widget _buildMenuItem(DropdownMenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: item.isDestructive 
                      ? const Color(0xFFFEF2F2) 
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(
                  item.icon,
                  size: 20.0,
                  color: item.isDestructive 
                      ? const Color(0xFFDC2626) 
                      : const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: item.isDestructive 
                            ? const Color(0xFFDC2626) 
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        item.subtitle!,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14.0,
                color: item.isDestructive 
                    ? const Color(0xFFDC2626) 
                    : const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTextChanged() {
    if (_controller.text.isNotEmpty && _showWelcomeCard) {
      _dismissWelcomeCard();
    }
  }

  void _dismissWelcomeCard() {
    if (_showWelcomeCard) {
      setState(() {
        _showWelcomeCard = false;
      });
      _welcomeCardController.reverse();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _animationController.dispose();
    _welcomeCardController.dispose();
    super.dispose();
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class DropdownMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  DropdownMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}