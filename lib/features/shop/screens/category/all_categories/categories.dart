import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:flutter/material.dart';

import 'responsive_screens/categories_desktop.dart';
import 'responsive_screens/categories_mobile.dart';
import 'responsive_screens/categories_tablet.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
        desktop: CategoriesDesktopScreen(),
        tablet: CategoriesTabletScreen(),
        mobile: CategoriesMobileScreen());
  }
}
