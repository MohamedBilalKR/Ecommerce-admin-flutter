import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'responsive_screens/customer_details_desktop.dart';
import 'responsive_screens/customer_details_mobile.dart';
import 'responsive_screens/customer_details_tablet.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = Get.arguments;
    
    return SiteTemplate(
      desktop: CustomerDetailsDesktopScreen(customer: customer),
      tablet: CustomerDetailsTabletScreen(customer: customer),
      mobile: CustomerDetailsMobileScreen(customer: customer),
    );
  }
}
