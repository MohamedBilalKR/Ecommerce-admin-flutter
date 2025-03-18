import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../widgets/header_form.dart';

class ForgetPasswordScreenMobile extends StatelessWidget {
  const ForgetPasswordScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: HeaderAndForm(),
      )),
    );
  }
}
