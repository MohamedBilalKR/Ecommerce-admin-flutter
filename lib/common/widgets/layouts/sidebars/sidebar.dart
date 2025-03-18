import 'package:e_commerce_admin/features/personalization/controllers/settings_controller.dart';
import 'package:e_commerce_admin/routes/routes.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/t_circular_image.dart';
import 'menu/menu_item.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
            color: TColors.white,
            border: Border(right: BorderSide(color: TColors.grey, width: 1))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Image
              Row(
                children: [
                  Obx(
                    () => TCircularImage(
                      width: 60,
                      height: 60,
                      padding: 0,
                      margin: TSizes.sm,
                      imageType: SettingsController
                              .instance.settings.value.appLogo.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                      image: SettingsController
                              .instance.settings.value.appLogo.isNotEmpty
                          ? SettingsController.instance.settings.value.appLogo
                          : TImages.darkAppLogo,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        SettingsController.instance.settings.value.appName,
                        style: Theme.of(context).textTheme.headlineLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('MENU',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),

                    //Menu Items
                    const MenuItems(
                      icon: Iconsax.status,
                      itemName: 'Dashboard',
                      route: Routes.dashboard,
                    ),
                    const MenuItems(
                      icon: Iconsax.image,
                      itemName: 'Media',
                      route: Routes.media,
                    ),
                    const MenuItems(
                      icon: Iconsax.category_2,
                      itemName: 'Categories',
                      route: Routes.categories,
                    ),
                    const MenuItems(
                      icon: Iconsax.dcube,
                      itemName: 'Brands',
                      route: Routes.brands,
                    ),
                    const MenuItems(
                      icon: Iconsax.picture_frame,
                      itemName: 'Banners',
                      route: Routes.banners,
                    ),
                    const MenuItems(
                      icon: Iconsax.shopping_bag,
                      itemName: 'Products',
                      route: Routes.products,
                    ),
                    const MenuItems(
                      icon: Iconsax.profile_2user,
                      itemName: 'Customers',
                      route: Routes.customers,
                    ),
                    const MenuItems(
                      icon: Iconsax.box,
                      itemName: 'Orders',
                      route: Routes.orders,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),

                    //Other Menu Items
                    Text('OTHERS',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),

                    //Menu Items
                    const MenuItems(
                      icon: Iconsax.user,
                      itemName: 'Profile',
                      route: Routes.profile,
                    ),
                    const MenuItems(
                      icon: Iconsax.setting_2,
                      itemName: 'Settings',
                      route: Routes.settings,
                    ),
                    const MenuItems(
                      icon: Iconsax.logout,
                      itemName: 'Logout',
                      route: Routes.logout,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
