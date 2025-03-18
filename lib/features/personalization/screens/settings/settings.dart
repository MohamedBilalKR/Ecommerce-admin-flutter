import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/template/site_template.dart';
import 'responsive_screens/settings_desktop.dart';
import 'responsive_screens/settings_mobile.dart';
import 'responsive_screens/settings_tablet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: SettingsDesktopScreen(),
      tablet: SettingsTabletScreen(),
      mobile: SettingsMobileScreen(),
    );
  }
}
