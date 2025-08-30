import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A production-ready send message button widget following Material Design 3 guidelines
/// with proper states, animations, accessibility, and customization options.
class SendMessageButton extends StatefulWidget {
  /// Callback when the send button is pressed
  final VoidCallback? onPressed;
  
  /// Whether the button is in loading state
  final bool isLoading;
  
  /// Whether the button is enabled
  final bool isEnabled;
  
  /// Custom icon for the send button (defaults to SVG from assets)
  final IconData? icon;
  
  /// Custom SVG asset path for the send button (defaults to 'assets/sendmessage.svg')
  final String? svgAssetPath;
  
  /// Whether to use SVG icon instead of IconData (defaults to true)
  final bool useSvgIcon;
  
  /// Size of the button (defaults to 48.0 for accessibility)
  final double size;
  
  /// Custom colors for different states
  final Color? enabledColor;
  final Color? disabledColor;
  final Color? loadingColor;
  final Color? iconColor;
  
  /// Tooltip text for accessibility
  final String? tooltip;
  
  /// Whether to use FloatingActionButton style (default) or IconButton style
  final bool useFloatingStyle;
  
  /// Animation duration for state transitions
  final Duration animationDuration;
  
  const SendMessageButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.svgAssetPath,
    this.useSvgIcon = true,
    this.size = 48.0,
    this.enabledColor,
    this.disabledColor,
    this.loadingColor,
    this.iconColor,
    this.tooltip,
    this.useFloatingStyle = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<SendMessageButton> createState() => _SendMessageButtonState();
}

class _SendMessageButtonState extends State<SendMessageButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    // Scale animation for press feedback
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    // Rotation animation for loading state
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    // Pulse animation for enabled state
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _updateAnimations();
  }

  @override
  void didUpdateWidget(SendMessageButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading ||
        oldWidget.isEnabled != widget.isEnabled) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    if (widget.isLoading) {
      _rotationController.repeat();
      _pulseController.stop();
    } else {
      _rotationController.stop();
      _rotationController.reset();
      
      if (widget.isEnabled && widget.onPressed != null) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (_canInteract) {
      setState(() => _isPressed = true);
      _scaleController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_canInteract) {
      setState(() => _isPressed = false);
      _scaleController.reverse();
    }
  }

  void _handleTapCancel() {
    if (_canInteract) {
      setState(() => _isPressed = false);
      _scaleController.reverse();
    }
  }

  void _handleHover(bool isHovered) {
    if (_canInteract) {
      setState(() => _isHovered = isHovered);
    }
  }

  bool get _canInteract => widget.isEnabled && !widget.isLoading && widget.onPressed != null;

  Color _getButtonColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (widget.isLoading) {
      return widget.loadingColor ?? colorScheme.primary.withValues(alpha: 0.7);
    }
    
    if (!widget.isEnabled || widget.onPressed == null) {
      return widget.disabledColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    }
    
    return widget.enabledColor ?? colorScheme.primary;
  }

  Color _getIconColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (widget.iconColor != null) {
      return widget.iconColor!;
    }
    
    if (!widget.isEnabled || widget.onPressed == null) {
      return colorScheme.onSurface.withValues(alpha: 0.38);
    }
    
    return colorScheme.onPrimary;
  }

  Widget _buildIcon(BuildContext context) {
    final iconColor = _getIconColor(context);
    final iconSize = widget.size * 0.5;
    
    if (widget.isLoading) {
      return AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Center ( child:  Icon(
              Icons.sync,
              color: iconColor,
              size: iconSize,
            ),
            ),
          );
        },
      );
    }
    
    // Use SVG icon if enabled and available
    if (widget.useSvgIcon) {
      final svgPath = widget.svgAssetPath ?? 'assets/sendmessage.svg';
      return Center(child:  SvgPicture.asset(
        svgPath,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(
          iconColor,
          BlendMode.srcIn,
        ),
      ),
      );
    }
    
    // Fallback to regular icon
    final iconData = widget.icon ?? Icons.send;
    return Icon(
      iconData,
      color: iconColor,
      size: iconSize,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getButtonColor(context),
              boxShadow: _canInteract && (_isHovered || _isPressed)
                  ? [
                      BoxShadow(
                        color: _getButtonColor(context).withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.size / 2),
                onTap: _canInteract ? widget.onPressed : null,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onHover: _handleHover,
                child: Center(
                  child: _buildIcon(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _getButtonColor(context),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _canInteract ? widget.onPressed : null,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onHover: _handleHover,
                child: Center(
                  child: _buildIcon(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSemanticLabel() {
    if (widget.isLoading) {
      return 'Sending message, please wait';
    }
    
    if (!widget.isEnabled || widget.onPressed == null) {
      return 'Send message button disabled';
    }
    
    return widget.tooltip ?? 'Send message';
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.useFloatingStyle
        ? _buildFloatingActionButton(context)
        : _buildIconButton(context);
    
    return Semantics(
      button: true,
      enabled: _canInteract,
      label: _getSemanticLabel(),
      hint: widget.isLoading ? 'Message is being sent' : 'Double tap to send message',
      child: Tooltip(
        message: _getSemanticLabel(),
        child: button,
      ),
    );
  }
}

/// Predefined send button styles for common use cases
class SendButtonStyles {
  /// WhatsApp-style send button
  static SendMessageButton whatsAppStyle({
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return SendMessageButton(
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      enabledColor: const Color(0xFF25D366),
      icon: Icons.send,
      size: 48.0,
      tooltip: 'Send message',
    );
  }
  
  /// Telegram-style send button
  static SendMessageButton telegramStyle({
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return SendMessageButton(
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      enabledColor: const Color(0xFF0088CC),
      icon: Icons.send,
      size: 44.0,
      useFloatingStyle: false,
      tooltip: 'Send message',
    );
  }
  
  /// Discord-style send button
  static SendMessageButton discordStyle({
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return SendMessageButton(
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      enabledColor: const Color(0xFF5865F2),
      icon: Icons.send,
      size: 40.0,
      useFloatingStyle: false,
      tooltip: 'Send message',
    );
  }
  
  /// Material Design 3 style send button
  static SendMessageButton material3Style({
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return SendMessageButton(
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      size: 56.0,
      tooltip: 'Send message',
    );
  }
}