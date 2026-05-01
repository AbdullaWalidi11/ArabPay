import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SplashOnboardingView extends StatelessWidget {
  const SplashOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) => const Icon(
                  LucideIcons.star,
                  size: 80,
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Top Shield Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B132B),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0B132B).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 24),
                  
                  // Brand Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ArabPay',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ID',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF0F172A).withOpacity(0.5),
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'SECURE BANKING LAYER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Main Illustration
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Central Image Card
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B132B),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              // Simulated abstract burst/pattern
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        const Color(0xFF0D9488).withOpacity(0.4),
                                        Colors.transparent,
                                      ],
                                      radius: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                              const Center(
                                child: Icon(
                                  LucideIcons.fingerprint,
                                  color: Color(0xFF2DD4BF),
                                  size: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Floating Icon Card - Left (Globe)
                        Positioned(
                          top: 20,
                          left: 20,
                          child: _buildFloatingCard(
                            LucideIcons.globe,
                            const Color(0xFF0F172A),
                            80,
                            Colors.white,
                          ),
                        ),
                        
                        // Floating Icon Card - Right (Wallet)
                        Positioned(
                          top: 40,
                          right: 60,
                          child: _buildFloatingCard(
                            LucideIcons.wallet,
                            Colors.white,
                            50,
                            const Color(0xFF0B132B),
                          ),
                        ),
                        
                        // Floating Icon Card - Bottom Right (Shield)
                        Positioned(
                          bottom: 40,
                          right: 20,
                          child: _buildFloatingCard(
                            LucideIcons.shieldCheck,
                            const Color(0xFF10B981),
                            90,
                            Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Bottom Content
                  const Text(
                    'Your Global Arab\nPayment Identity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'A unified digital identity for seamless cross-border transactions and institutional security across the MENA region and beyond.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () => context.go('/claim-identity'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B132B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 10,
                        shadowColor: const Color(0xFF0B132B).withOpacity(0.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(LucideIcons.arrowRight, size: 20),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  // Footer
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.lock, size: 14, color: Color(0xFF94A3B8)),
                      SizedBox(width: 8),
                      Text(
                        'Institutional Grade Encryption',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard(IconData icon, Color iconColor, double size, Color bgColor) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: size * 0.45),
    );
  }
}
