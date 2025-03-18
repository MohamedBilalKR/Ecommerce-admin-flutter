import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:e_commerce_admin/features/authentication/screens/reset_password/responsive_screens/reset_password_desktop_tablet.dart';
import 'package:e_commerce_admin/features/authentication/screens/reset_password/responsive_screens/reset_password_mobile.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      useLayout: false,
      desktop: ResetPasswordScreenDesktopTablet(),
      mobile: ResetPasswordScreenMobile(),
    );
  }
}
