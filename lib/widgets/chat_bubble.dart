import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../models/message_model.dart';
import '../services/llm_service.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  /// If true, this is the last AI message and we show speed info
  final bool showSpeed;

  const ChatBubble({super.key, required this.message, this.showSpeed = false});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isSmall = MediaQuery.of(context).size.width < 600;
    final hPad = isSmall ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isUser ? Colors.transparent : context.bgMsgAi,
        border: isUser
            ? null
            : Border(
                bottom: BorderSide(
                  color: context.borderFaint,
                  width: 0.5,
                ),
              ),
      ),
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with gradient
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: isUser
                  ? const LinearGradient(
                      colors: [AppColors.pinkAccent, Color(0xFFFF7EB3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : AppColors.accentGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: (isUser ? AppColors.pinkAccent : AppColors.accent)
                      .withValues(alpha: 0.25),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(
              isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: _buildContent(context, isUser),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isUser) {
    if (isUser) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: context.text,
            height: 1.6,
          ),
        ),
      );
    }

    // AI: render markdown
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: MarkdownBody(
            data: message.content,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(fontSize: 15, color: context.text, height: 1.7),
              h1: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.text),
              h2: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.text),
              h3: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.text),
              code: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: AppColors.neonCyan,
                backgroundColor: context.isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.06),
              ),
              codeblockDecoration: BoxDecoration(
                color: const Color(0xFF0A0E18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.15),
                ),
              ),
              codeblockPadding: const EdgeInsets.all(16),
              blockquoteDecoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.06),
                border: const Border(
                  left: BorderSide(color: AppColors.accent, width: 3),
                ),
              ),
              blockquotePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              listBullet: TextStyle(color: context.text),
              tableHead: TextStyle(fontWeight: FontWeight.w600, color: context.text, fontSize: 14),
              tableBody: TextStyle(color: context.text, fontSize: 14),
              tableBorder: TableBorder.all(color: context.border),
              tableCellsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              horizontalRuleDecoration: BoxDecoration(
                border: Border(top: BorderSide(color: context.border)),
              ),
            ),
          ),
        ),

        // Action row: Copy + Speed
        if (message.content.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              children: [
                // Copy button with glass style
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: message.content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? AppColors.glassWhite
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy_rounded, size: 13, color: context.textD),
                        const SizedBox(width: 4),
                        Text('Copy', style: TextStyle(fontSize: 11, color: context.textD)),
                      ],
                    ),
                  ),
                ),

                // Speed indicator (on the last AI message)
                if (showSpeed) ...[
                  const SizedBox(width: 10),
                  Obx(() {
                    final llm = Get.find<LlmService>();
                    final speed = llm.isGenerating.value
                        ? llm.tokensPerSecond.value
                        : llm.lastGenerationSpeed.value;
                    if (speed <= 0) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.speed_rounded, size: 13, color: AppColors.neonCyan.withValues(alpha: 0.7)),
                          const SizedBox(width: 4),
                          Text(
                            '${speed.toStringAsFixed(1)} t/s',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.neonCyan.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
