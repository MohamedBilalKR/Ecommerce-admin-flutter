import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:e_commerce_admin/features/personalization/screens/profile/responsive_screens/profile_desktop.dart';
import 'package:e_commerce_admin/features/personalization/screens/profile/responsive_screens/profile_mobile.dart';
import 'package:e_commerce_admin/features/personalization/screens/profile/responsive_screens/profile_tablet.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: ProfileDesktopScreen(),
      tablet: ProfileTabletScreen(),
      mobile: ProfileMobileScreen(),
    );
  }
}
