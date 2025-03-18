import 'package:e_commerce_admin/common/widgets/layouts/sidebars/sidebar_controller.dart';
import 'package:e_commerce_admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteObserver extends GetObserver {
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sidebarController = Get.put(SidebarController());

    if (previousRoute != null) {
      for (var routeName in Routes.sidebarMenuItems) {
        if (previousRoute.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
          break;
        }
      }
    }
  }
}
