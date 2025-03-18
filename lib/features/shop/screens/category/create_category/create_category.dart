import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:e_commerce_admin/features/shop/screens/category/create_category/responsive_screens/create_category_desktop.dart';
import 'package:e_commerce_admin/features/shop/screens/category/create_category/responsive_screens/create_category_mobile.dart';
import 'package:e_commerce_admin/features/shop/screens/category/create_category/responsive_screens/create_category_tablet.dart';
import 'package:flutter/material.dart';

class CreateCategoryScreen extends StatelessWidget {
  const CreateCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: CreateCategoryDesktopScreen(),
      tablet: CreateCategoryTabletScreen(),
      mobile: CreateCategoryMobileScreen(),
    );
  }
}
