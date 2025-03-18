import 'package:e_commerce_admin/common/widgets/layouts/template/login_template.dart';
import 'package:flutter/material.dart';

import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginTemplate(
      child: Column(
        children: [
          //Header
          LoginHeader(),

          //Form
          LoginForm(),
        ],
      ),
    );
  }
}
