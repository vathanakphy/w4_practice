import 'package:flutter/material.dart';
import 'package:w4_practice/2_download_app/ui/theme/theme.dart';

import 'download_controler.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;

  // TODO

  IconData get iconButton {
    switch (controller.status) {
      case DownloadStatus.downloading:
        return Icons.downloading;
      case DownloadStatus.downloaded:
        return Icons.folder;
      case DownloadStatus.notDownloaded:
        return Icons.download;
    }
  }

  String get textSubTitle {
    switch (controller.status) {
      case DownloadStatus.downloading:
        return '${(controller.progress * 100).toStringAsFixed(1)}% downloading '
            '${(controller.progress * controller.ressource.size).toStringAsFixed(1)} '
            'of ${controller.ressource.size} MB';

      case DownloadStatus.downloaded:
        return '${(controller.progress * 100).toStringAsFixed(1)}% complete '
            '${(controller.progress * controller.ressource.size).toStringAsFixed(1)} '
            'of ${controller.ressource.size} MB';
      case DownloadStatus.notDownloaded:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(controller.ressource.name),
      subtitle: Text(
        textSubTitle,
        style: AppTextStyles.label.copyWith(
          color: AppColors.neutral,
          fontSize: 14,
        ),
      ),
      trailing: IconButton(
        onPressed: controller.startDownload,
        icon: Icon(iconButton),
      ),
    );
    // TODO
  }
}
