import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/form.dart';
import '../widgets/image_meta.dart';

class SettingsTabletScreen extends StatelessWidget {
  const SettingsTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //BreadCrumbs
              BreadcrumbsWithHeading(
                  heading: 'Settings', breadcrumbItems: ['Settings']),
              SizedBox(height: TSizes.spaceBtwSections),

              //Body
              Column(
                children: [
                  //Profile Pic and Meta
                  ImageAndMetaSettings(),
                  SizedBox(height: TSizes.spaceBtwSections),

                  //Form
                  SettingsForm(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}