import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/create_banner/responsive_screens/create_banner_desktop.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/create_banner/responsive_screens/create_banner_mobile.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/create_banner/responsive_screens/create_banner_tablet.dart';
import 'package:flutter/material.dart';

class CreateBannerScreen extends StatelessWidget {
  const CreateBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: CreateBannerDesktopScreen(),
      tablet: CreateBannerTabletScreen(),
      mobile: CreateBannerMobileScreen(),
    );
  }
}
