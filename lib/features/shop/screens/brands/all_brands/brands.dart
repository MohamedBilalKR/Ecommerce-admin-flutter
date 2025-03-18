import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:flutter/material.dart';

import 'responsive_screens/brand_desktop.dart';
import 'responsive_screens/brand_mobile.dart';
import 'responsive_screens/brand_tablet.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
        desktop: BrandsDesktopScreen(),
        tablet: BrandsTabletScreen(),
        mobile: BrandsMobileScreen());
  }
}
