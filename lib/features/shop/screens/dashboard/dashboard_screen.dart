import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:e_commerce_admin/features/shop/screens/dashboard/responsive_screens/dashboard_desktop.dart';
import 'package:e_commerce_admin/features/shop/screens/dashboard/responsive_screens/dashboard_mobile.dart';
import 'package:e_commerce_admin/features/shop/screens/dashboard/responsive_screens/dashboard_tablet.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: DashboardScreenDesktop(),
      tablet: DashboardScreenTablet(),
      mobile: DashboardScreenMobile(),
    );
  }
}
