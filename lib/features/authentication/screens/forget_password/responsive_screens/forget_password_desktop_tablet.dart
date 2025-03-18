import 'package:flutter/material.dart';

import '../../../../../common/widgets/layouts/template/login_template.dart';
import '../widgets/header_form.dart';

class ForgetPasswordScreenDesktopTablet extends StatelessWidget {
  const ForgetPasswordScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginTemplate(
      child: HeaderAndForm(),
    );
  }
}
