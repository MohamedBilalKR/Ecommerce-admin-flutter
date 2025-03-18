import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_brand_form.dart';

class CreateBrandTabletScreen extends StatelessWidget {
  const CreateBrandTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //breadcrumbs
              BreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Add Brand',
                  breadcrumbItems: [Routes.brands, 'Add Brand']),
              SizedBox(height: TSizes.spaceBtwSections),

              //Form
              CreateBrandForm(),
            ],
          ),
        ),
      ),
    );
  }
}
