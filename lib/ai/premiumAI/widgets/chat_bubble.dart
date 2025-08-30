import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context, ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4.0,
          bottom: 0,
          left: isUser ? screenWidth * 0.15 : 16.0,
          right: isUser ? 16.0 : screenWidth * 0.15,
        ),
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.75,
          minWidth: 60.0,
          maxHeight: screenWidth > 600  ? 100:70  ,
        ),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: isUser 
              ? const Color(0xFF6366F1)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: Radius.circular(isUser ? 20.0 : 4.0),
            bottomRight: Radius.circular(isUser ? 4.0 : 20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser 
                ? Colors.white 
                : colorScheme.onSurfaceVariant,
            fontSize: screenWidth > 600 ? 25.0 : 16.0,
            fontWeight: FontWeight.w400,
            height: 1.3,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}