import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/all_banners/responsive_screens/banners_desktop.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/all_banners/responsive_screens/banners_mobile.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/all_banners/responsive_screens/banners_tablet.dart';
import 'package:flutter/material.dart';

class BannersScreen extends StatelessWidget {
  const BannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: BannersDesktopScreen(),
      tablet: BannersTabletScreen(),
      mobile: BannersMobileScreen(),
    );
  }
}
