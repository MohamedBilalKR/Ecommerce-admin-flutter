import 'package:e_commerce_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:e_commerce_admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoutesMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated ? null : const RouteSettings(name: Routes.login);
  }
}
