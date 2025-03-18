import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';

import 'package:flutter/material.dart';

import 'responsive_screens/forget_password_desktop_tablet.dart';
import 'responsive_screens/forget_password_mobile.dart';

class ForgetPasswordSCreen extends StatelessWidget {
  const ForgetPasswordSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      useLayout: false,
      desktop: ForgetPasswordScreenDesktopTablet(),
      mobile: ForgetPasswordScreenMobile(),
    );
  }
}
