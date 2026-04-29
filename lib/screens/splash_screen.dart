import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../services/llm_service.dart';
import '../services/model_manager.dart';
import '../services/chat_storage_service.dart';
import '../services/local_api_server_service.dart';
import '../services/wakelock_service.dart';
import '../services/log_service.dart';
import '../services/background_optimizer_service.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _status = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      // Initialize logging first
      final log = Get.find<LogService>()..init();

      setState(() => _status = 'Setting up storage...');
      log.info('Initializing storage...', source: 'Splash');
      await Get.find<ChatStorageService>().init();

      setState(() => _status = 'Loading model catalog...');
      log.info('Loading model catalog...', source: 'Splash');
      await Get.find<ModelManager>().init();

      setState(() => _status = 'Preparing AI engine...');
      log.info('Preparing AI engine...', source: 'Splash');
      await Get.find<LlmService>().init();

      setState(() => _status = 'Preparing local API...');
      log.info('Preparing local API...', source: 'Splash');
      await Get.find<LocalApiServerService>().init();

      setState(() => _status = 'Setting up background services...');
      log.info('Setting up background services...', source: 'Splash');
      await Get.find<WakelockService>().init();

      setState(() => _status = 'Ready!');
      log.info('All services initialized successfully', source: 'Splash');
      await Future.delayed(const Duration(milliseconds: 500));

      // Prompt for battery optimization on Android (first launch only)
      if (mounted) {
        await BackgroundOptimizerService.checkAndPrompt(context);
      }

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      setState(() => _status = 'Error: $e');
      try {
        Get.find<LogService>().error('Init failed: $e', source: 'Splash');
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Subtle background gradient glow
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.12),
                    AppColors.accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 1200.ms),
          Positioned(
            bottom: -100,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.neonCyan.withValues(alpha: 0.08),
                    AppColors.neonCyan.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 1200.ms),

          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo with aurora glow
                Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.35),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: AppColors.neonCyan.withValues(alpha: 0.15),
                            blurRadius: 60,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/aurora_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack),
                const SizedBox(height: 28),
                // App name with gradient effect
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.accentGradient
                      .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: const Text(
                    'Aurora',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                const SizedBox(height: 8),
                Text(
                  'Run local LLMs natively on any device ✨',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.darkTextM,
                    letterSpacing: 0.2,
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                const SizedBox(height: 48),
                // Loading indicator with cyan glow
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: const AlwaysStoppedAnimation(AppColors.neonCyan),
                    backgroundColor: AppColors.darkBorder,
                  ),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),
                Text(
                  _status,
                  style: TextStyle(fontSize: 12, color: AppColors.darkTextD),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
