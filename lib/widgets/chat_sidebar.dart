import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../controllers/chat_controller.dart';

class ChatSidebar extends StatelessWidget {
  final VoidCallback onNewChat;
  final ValueChanged<String> onSelectChat;
  final ValueChanged<String> onDeleteChat;
  final bool showNewChatButton;

  const ChatSidebar({
    super.key,
    required this.onNewChat,
    required this.onSelectChat,
    required this.onDeleteChat,
    this.showNewChatButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ChatController>();

    return Column(
      children: [
        // New chat button — gradient pill
        if (showNewChatButton)
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onNewChat,
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'New Chat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Chat list
        Expanded(
          child: Obx(() {
            final chats = ctrl.chats;
            if (chats.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 36, color: context.textD),
                    const SizedBox(height: 12),
                    Text(
                      'No chats yet',
                      style: TextStyle(fontSize: 13, color: context.textD),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final isActive = chat.id == ctrl.activeChatId.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isActive ? context.bgHover : Colors.transparent,
                      border: isActive
                          ? Border(
                              left: BorderSide(
                                color: AppColors.neonCyan,
                                width: 2.5,
                              ),
                            )
                          : null,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.neonCyan.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(-2, 0),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => onSelectChat(chat.id),
                        borderRadius: BorderRadius.circular(10),
                        hoverColor: context.bgHover,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 15,
                                color: isActive ? AppColors.neonCyan : context.textD,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  chat.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                    color: isActive ? context.text : context.textM,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Delete button with confirmation
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: IconButton(
                                  onPressed: () => _confirmDelete(context, chat.id, chat.title),
                                  icon: Icon(Icons.close_rounded, size: 14, color: context.textD),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),

        // Footer
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.borderFaint)),
          ),
          child: Row(
            children: [
              Icon(Icons.save_outlined, size: 14, color: context.textD),
              const SizedBox(width: 8),
              Text(
                'Chats saved locally',
                style: TextStyle(fontSize: 11, color: context.textD),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, String chatId, String chatTitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.bgPanel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Chat',
          style: TextStyle(
            color: context.text,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Delete "$chatTitle"?\nThis action cannot be undone.',
          style: TextStyle(color: context.textM, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.textD)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.red, Color(0xFFFF6B8A)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  onDeleteChat(chatId);
                },
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
