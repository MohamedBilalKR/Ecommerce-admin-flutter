import 'package:e_commerce_admin/common/widgets/icons/title_icon.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.stats,
    this.icon = Iconsax.arrow_up_3,
    this.color = TColors.success,
    this.onTap,
    this.titleIcon,
    this.titleIconColor,
  });

  final String title, subTitle;
  final IconData icon;
  final IconData? titleIcon;
  final Color color;
  final Color? titleIconColor;
  final int stats;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(TSizes.lg),
      child: Column(
        children: [
          //Heading
          Row(
            children: [
              TitleIcon(icon: titleIcon!, color: titleIconColor!),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              TSectionHeading(title: title, textColor: TColors.textSecondary),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subTitle, style: Theme.of(context).textTheme.headlineMedium),

              //Right Side Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Indicator
                  Row(
                    children: [
                      Icon(icon, color: color, size: TSizes.iconSm),
                      Text(
                        '$stats%',
                        style: Theme.of(context).textTheme.titleLarge!.apply(
                              color: color,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 135,
                    child: Text(
                      'Compared to Jan 2025',
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
