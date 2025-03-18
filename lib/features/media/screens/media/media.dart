import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/template/site_template.dart';
import 'responsive_screens/media_desktop.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(desktop: MediaDesktopScreen());
  }
}