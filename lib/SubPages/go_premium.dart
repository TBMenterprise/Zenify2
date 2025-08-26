import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mainproject/widgets/settings_bottom_sheet.dart';

void showGoPremiumBottomSheet(BuildContext context) {
  showSettingsBottomSheet(
    context,
    GoPremiumPage(),
  );
}

class GoPremiumPage extends StatefulWidget {
  const GoPremiumPage({Key? key}) : super(key: key);

  @override
  _GoPremiumPageState createState() => _GoPremiumPageState();
}

class _GoPremiumPageState extends State<GoPremiumPage> {
  bool isMonthlySelected = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Top bar with close button and title
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Go Premium',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF000000),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/GoPremiumcloseicon.svg',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Title section
            const Text(
              'Unlimited Access',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF000000),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Access the World\'s Most advanced AI Therapist',
                style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Color(0xFF666666),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 28),

            // Benefits list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildBenefitItem('Ads Free!', true),
                  const SizedBox(height: 16),
                  _buildBenefitItem('Smarter AI + Better Memory', true),
                  const SizedBox(height: 16),
                  _buildBenefitItem('Custom Background Image', false),
                  const SizedBox(height: 16),
                  _buildBenefitItem('Talk to your AI', true),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Pricing cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildPricingCard(
                      title: 'Monthly Pass',
                      price: '£19.99',
                      subtitle: 'Monthly',
                      isSelected: isMonthlySelected,
                      onTap: () => setState(() => isMonthlySelected = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPricingCard(
                      title: 'Yearly Access',
                      price: '£199.99',
                      subtitle: 'Yearly',
                      badge: 'Save ~£40',
                      isSelected: !isMonthlySelected,
                      onTap: () => setState(() => isMonthlySelected = false),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Unlock Access button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3DA9FC), Color(0xFF0077FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Unlock Access functionality coming soon!'),
                        backgroundColor: Colors.blueAccent,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          right: 20,
                          left: 20,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Unlock Access →',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Footer links
            const Text(
              'Terms of use | Privacy Policy | Restore',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text, bool isChecked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          isChecked
              ? 'assets/GoPremiumTickedBenifits.svg'
              : 'assets/GoPremiumUnticked.svg',
          width: 20,
          height: 20,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Helvetica Neue',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF000000),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String subtitle,
    String? badge,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          border: Border.all(
            color: isSelected ? const Color(0xFF0077FF) : const Color(0xFFDDDDDD),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF000000),
                  ),
                ),
                SvgPicture.asset(
                  isSelected
                      ? 'assets/GoPremiumTicked.svg'
                      : 'assets/GoPremiumUnticked.svg',
                  width: 20,
                  height: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF000000),
              ),
            ),
            if (badge != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.normal,
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}