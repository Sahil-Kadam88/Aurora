import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../theme/app_colors.dart';
import '../models/ai_model_info.dart';
import '../models/download_state.dart';

class ModelCard extends StatelessWidget {
  final AiModelInfo model;
  final bool isDownloaded;
  final bool isCurrentlyDownloading;
  final DownloadState? downloadState;
  final bool isLoaded;
  final bool isLoadingModel;
  final String loadingStatusMsg;
  final double loadingProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancelDownload;
  final VoidCallback onLoad;
  final VoidCallback onDelete;
  final VoidCallback? onRemoveCustom;
  final VoidCallback? onCancelLoad;
  final VoidCallback? onUnload;

  const ModelCard({
    super.key,
    required this.model,
    required this.isDownloaded,
    required this.isCurrentlyDownloading,
    this.downloadState,
    required this.isLoaded,
    required this.isLoadingModel,
    this.loadingStatusMsg = '',
    this.loadingProgress = 0.0,
    required this.onDownload,
    required this.onCancelDownload,
    required this.onLoad,
    required this.onDelete,
    this.onRemoveCustom,
    this.onCancelLoad,
    this.onUnload,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isLoaded
        ? AppColors.neonCyan.withValues(alpha: 0.5)
        : isLoadingModel
            ? AppColors.orange.withValues(alpha: 0.4)
            : isCurrentlyDownloading
                ? AppColors.accent.withValues(alpha: 0.3)
                : context.border;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.bgPanel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (isLoaded)
            BoxShadow(
              color: AppColors.neonCyan.withValues(alpha: 0.08),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ────────────────────────────────────────
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _labelBadge(model.label, model.isUncensored),
                if (model.badge.isNotEmpty)
                  _accentBadge(model.badge),
                if (isLoaded) _statusBadge('LOADED', AppColors.green, Icons.check_circle),
                if (isLoadingModel)
                  _statusBadge('LOADING', AppColors.orange, Icons.hourglass_top_rounded),
                if (isCurrentlyDownloading)
                  _statusBadge('DOWNLOADING', AppColors.accent, Icons.downloading_rounded),
              ],
            ),

            const SizedBox(height: 12),

            // ── Model name ────────────────────────────────────────
            Text(
              model.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.text,
              ),
            ),

            const SizedBox(height: 8),

            // ── Size and RAM ──────────────────────────────────────
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                _infoChip(context, Icons.storage_rounded, '${model.sizeGb} GB'),
                _infoChip(context, Icons.memory_rounded, 'Min ${model.minRamGb} GB RAM'),
                if (isDownloaded && !isCurrentlyDownloading)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.green),
                      const SizedBox(width: 4),
                      const Text('Downloaded',
                          style: TextStyle(fontSize: 12, color: AppColors.green)),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Loading progress ──────────────────────────────────
            if (isLoadingModel) ...[
              _buildLoadingProgress(context),
              const SizedBox(height: 16),
            ],

            // ── Download progress with realtime stats ─────────────
            if (isCurrentlyDownloading && downloadState != null) ...[
              _buildDownloadProgress(context, downloadState!),
              const SizedBox(height: 16),
            ],

            // ── Action buttons ────────────────────────────────────
            if (!isCurrentlyDownloading && !isLoadingModel) _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.textD),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: context.textM)),
      ],
    );
  }

  Widget _buildLoadingProgress(BuildContext context) {
    final percent = (loadingProgress * 100).clamp(0, 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient progress bar
        LinearPercentIndicator(
          lineHeight: 6,
          percent: loadingProgress.clamp(0.0, 1.0),
          backgroundColor: context.border,
          linearGradient: const LinearGradient(
            colors: [AppColors.orange, AppColors.accent],
          ),
          barRadius: const Radius.circular(3),
          padding: EdgeInsets.zero,
          animation: false,
        ),
        const SizedBox(height: 10),

        // Status row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.orange,
                ),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Text(
                loadingStatusMsg.isNotEmpty ? loadingStatusMsg : 'Loading...',
                style: TextStyle(fontSize: 12, color: context.textM),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (onCancelLoad != null)
              TextButton.icon(
                onPressed: onCancelLoad,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.stop_circle_outlined, size: 16),
                label: const Text('Stop', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDownloadProgress(BuildContext context, DownloadState ds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient progress bar
        LinearPercentIndicator(
          lineHeight: 6,
          percent: ds.progress,
          backgroundColor: context.border,
          linearGradient: AppColors.accentGradient,
          barRadius: const Radius.circular(3),
          padding: EdgeInsets.zero,
          animation: false,
        ),
        const SizedBox(height: 8),

        // Stats row
        Row(
          children: [
            Text(
              '${ds.percent.toStringAsFixed(1)}%',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.neonCyan),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '⚡ ${ds.speedStr}',
                style: const TextStyle(fontSize: 11, color: AppColors.neonCyan),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: onCancelDownload,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.red,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.close_rounded, size: 14),
              label: const Text('Cancel', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Stats detail row
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            Text(
              '${ds.downloadedStr} / ${ds.totalStr}',
              style: TextStyle(fontSize: 11, color: context.textM),
            ),
            Text(
              '${ds.remainingStr} left',
              style: TextStyle(fontSize: 11, color: context.textD),
            ),
            if (ds.speedBytesPerSec > 0)
              Text(
                'ETA: ${ds.etaStr}',
                style: TextStyle(fontSize: 11, color: context.textD),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final Widget removeIcon = IconButton(
      onPressed: onRemoveCustom,
      icon: const Icon(Icons.remove_circle_outline, size: 20),
      color: AppColors.red,
      tooltip: 'Remove from library',
    );

    return Row(
      children: [
        if (!isDownloaded) ...[
          Expanded(
            child: _GradientButton(
              onTap: onDownload,
              icon: Icons.download_rounded,
              label: 'Download (${model.sizeGb} GB)',
            ),
          ),
          if (model.isCustom && onRemoveCustom != null) ...[
            const SizedBox(width: 8),
            removeIcon,
          ],
        ],

        if (isDownloaded && !isLoaded) ...[
          Expanded(
            child: _GradientButton(
              onTap: onLoad,
              icon: Icons.play_arrow_rounded,
              label: 'Load Model',
              gradient: const LinearGradient(
                colors: [AppColors.green, Color(0xFF10B981)],
              ),
              glowColor: AppColors.green,
            ),
          ),
          const SizedBox(width: 8),
          if (model.isCustom && onRemoveCustom != null)
            removeIcon
          else
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              color: context.textD,
              tooltip: 'Delete model file',
            ),
        ],

        if (isDownloaded && isLoaded) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.5)),
                color: AppColors.neonCyan.withValues(alpha: 0.08),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, size: 16, color: AppColors.neonCyan),
                  SizedBox(width: 6),
                  Text('Active', style: TextStyle(
                    color: AppColors.neonCyan,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (onUnload != null)
            Tooltip(
              message: 'Unload model from memory',
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: onUnload,
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.eject_rounded, size: 20, color: AppColors.orange),
                    ),
                  ),
                ),
              ),
            ),
          if (model.isCustom && onRemoveCustom != null) ...[
            const SizedBox(width: 8),
            removeIcon,
          ],
        ],
      ],
    );
  }

  Widget _labelBadge(String label, bool isUncensored) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isUncensored
            ? AppColors.uncensored.withValues(alpha: 0.12)
            : AppColors.standard.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isUncensored ? AppColors.uncensored : AppColors.standard,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _accentBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.accentHi,
        ),
      ),
    );
  }

  Widget _statusBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

/// Reusable gradient button used in model cards.
class _GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Gradient? gradient;
  final Color? glowColor;

  const _GradientButton({
    required this.onTap,
    required this.icon,
    required this.label,
    this.gradient,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final grad = gradient ?? AppColors.buttonGradient;
    final glow = glowColor ?? AppColors.accent;

    return Container(
      decoration: BoxDecoration(
        gradient: grad,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
