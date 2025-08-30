import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final PageController _pageController = PageController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isPhoneFocused = false;
  
  int _currentStep = 0;
  final int _totalSteps = 3;
  String _profileImagePath = '';
  
  final List<String> _stepTitles = [
    'Enter Your Phone\nNumber',
    'Choose Your\nUsername',
    'Add Profile\nPicture'
  ];
  
  final List<String> _stepSubtitles = [
    'We need your phone number to verify your account',
    'Pick a unique username that represents you',
    'Add a profile picture to personalize your account'
  ];
  
  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      setState(() {
        // Username focus state handling can be added here if needed
      });

    });
    _phoneFocusNode.addListener(() {
      setState(() {
        _isPhoneFocused = _phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _usernameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveProfile();
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }
  
  bool _canProceedFromCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _phoneController.text.isNotEmpty;
      case 1:
        return _usernameController.text.isNotEmpty;
      case 2:
        return true; // Profile picture is optional
      default:
        return false;
    }
  }

  void _selectProfileImage() {
    // Static implementation - simulate image selection
    setState(() {
      _profileImagePath = 'assets/default_profile.png';
    });
  }

  Future<void> _saveProfile() async {
    if (formKey.currentState!.validate()) {
      // Static implementation - simulate saving
      HapticFeedback.lightImpact();
      Navigator.of(context).pushReplacementNamed('/chat');
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and progress
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _backArrow(),
                      _logoutButton(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _progressBar(),
                ],
              ),
            ),
            // PageView for steps
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPhoneStep(),
                  _buildUsernameStep(),
                  _buildProfilePictureStep(),
                ],
              ),
            ),
            // Bottom navigation
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: 24,
              ),
              child: Column(
                children: [
                  _continueButton(),
                  const SizedBox(height: 16),
                  _skipButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backArrow() {
    return GestureDetector(
      onTap: _previousStep,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF333333),
          size: 18,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              content: const Text(
                'Are you sure you want to logout? Your progress will be saved.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFFF3B30),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.logout_rounded,
          color: Color(0xFFFF3B30),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildStepTitle() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Center(
      child: Column(
        children: [
          Text(
            _stepTitles[_currentStep],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.5,
              color: const Color(0xFF2D2D2D),
            ),
          ),

          Text(
            _stepSubtitles[_currentStep],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar() {
    final progress = (_currentStep + 1) / _totalSteps;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${_currentStep + 1} of $_totalSteps',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2D2D),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF007AFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildModernStepper(),
      ],
    );
  }

  Widget _buildModernStepper() {
    return Row(
      children: List.generate(_totalSteps, (index) {
        final isCompleted = index < _currentStep;
        final isActive = index == _currentStep;

        
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isCompleted || isActive
                        ? const Color(0xFF007AFF)
                        : const Color(0xFFE5E5E5),
                  ),
                  child: isActive
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF007AFF),
                                Color(0xFF0056CC),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              if (index < _totalSteps - 1)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? const Color(0xFF007AFF)
                        : isActive
                            ? const Color(0xFF007AFF)
                            : const Color(0xFFE5E5E5),
                    border: isActive
                        ? Border.all(
                            color: const Color(0xFF007AFF),
                            width: 2,
                          )
                        : null,
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 6,
                          color: Colors.white,
                        )
                      : null,
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPhoneStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildStepTitle(),
          const SizedBox(height: 48),
          _buildStepCard(
            child: _phoneFormField(),
            icon: Icons.phone_outlined,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildUsernameStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildStepTitle(),
          const SizedBox(height: 48),
          _buildStepCard(
            child: _usernameFormField(),
            icon: Icons.person_outline,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildProfilePictureStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 4),
          _buildStepTitle(),
          
          _buildStepCard(
            child: _profileImageSection(),
            icon: Icons.camera_alt_outlined,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildStepCard({required Widget child, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF007AFF),
              size: 28,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _profileImageSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _selectProfileImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF007AFF),
                  width: 3,
                ),
                color: const Color(0xFFF8F9FA),
                boxShadow: [
                  BoxShadow(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                ],
              ),
              child: _profileImagePath.isEmpty
                  ? const Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Color(0xFF007AFF),
                    )
                  : ClipOval(
                      child: Container(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _profileImagePath.isEmpty ? 'Add Profile Photo' : 'Change Photo',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF007AFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _usernameFormField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextFormField(
        controller: _usernameController,
        focusNode: _usernameFocusNode,
        onChanged: (value) {
          setState(() {});
        },
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        decoration: InputDecoration(
          labelText: 'Username',
          hintText: 'Enter your username',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF007AFF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF007AFF),
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a username';
          }
          if (value.length < 3) {
            return 'Username must be at least 3 characters';
          }
          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
            return 'Username can only contain letters, numbers, and underscores';
          }
          return null;
        },
      ),
    );
  }

  Widget _phoneFormField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _isPhoneFocused || _phoneController.text.isNotEmpty
              ? const Color(0xFF007AFF)
              : const Color(0xFFE5E5E5),
          width: 1.5,
        ),
        boxShadow: _isPhoneFocused || _phoneController.text.isNotEmpty
            ? [
                BoxShadow(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: _phoneController,
        focusNode: _phoneFocusNode,
        onChanged: (value) {
          setState(() {});
        },
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D2D2D),
        ),
        decoration: InputDecoration(
          hintText: 'Enter Phone Number',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFC2C3CB),
            letterSpacing: -0.32,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.phone_outlined,
              size: 20,
              color: _isPhoneFocused || _phoneController.text.isNotEmpty
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFC2C3CB),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }
          if (value.length < 10) {
            return 'Please enter a valid phone number';
          }
          return null;
        },
      ),
    );
  }

  Widget _continueButton() {
    final canProceed = _canProceedFromCurrentStep();
    final isLastStep = _currentStep == _totalSteps - 1;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: canProceed
            ? const LinearGradient(
                colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              ),
        boxShadow: canProceed
            ? [
                BoxShadow(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: canProceed ? () {
            // Add haptic feedback
            HapticFeedback.lightImpact();
            _nextStep();
          } : null,
          child: Container(
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Row(
                key: ValueKey(isLastStep),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastStep ? 'Complete Profile' : 'Continue',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: canProceed ? Colors.white : Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (canProceed) ...[
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isLastStep ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isLastStep ? Icons.check_circle_outline : Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _skipButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/chat');
        },
        child: const Text(
          'SKIP FOR NOW',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9E9E9E),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}