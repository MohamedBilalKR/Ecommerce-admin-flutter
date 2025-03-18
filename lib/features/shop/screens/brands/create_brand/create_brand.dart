import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:flutter/material.dart';

import 'responsive_screens/create_brand_desktop.dart';
import 'responsive_screens/create_brand_mobile.dart';
import 'responsive_screens/create_brand_tablet.dart';

class CreateBrandScreen extends StatelessWidget {
  const CreateBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: CreateBrandDesktopScreen(),
      tablet: CreateBrandTabletScreen(),
      mobile: CreateBrandMobileScreen(),
    );
  }
}
