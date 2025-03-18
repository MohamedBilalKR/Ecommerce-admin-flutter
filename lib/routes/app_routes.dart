import 'package:e_commerce_admin/features/personalization/screens/profile/profile.dart';
import 'package:e_commerce_admin/features/personalization/screens/settings/settings.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/all_banners/banners.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/create_banner/create_banner.dart';
import 'package:e_commerce_admin/features/shop/screens/banner/edit_banner/edit_banner.dart';
import 'package:e_commerce_admin/features/shop/screens/customer/all_customer/customers.dart';
import 'package:e_commerce_admin/features/shop/screens/order/all_orders/orders.dart';
import 'package:e_commerce_admin/features/shop/screens/order/orders_details/order.dart';
import 'package:e_commerce_admin/features/shop/screens/product/all_product/products.dart';
import 'package:e_commerce_admin/routes/routes.dart';
import 'package:e_commerce_admin/routes/routes_middleware.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../features/authentication/screens/forget_password/forget_password.dart';
import '../features/authentication/screens/login/login.dart';
import '../features/authentication/screens/reset_password/reset_password.dart';
import '../features/media/screens/media/media.dart';
import '../features/shop/screens/brands/all_brands/brands.dart';
import '../features/shop/screens/brands/create_brand/create_brand.dart';
import '../features/shop/screens/brands/edit_brand/edit_brand.dart';
import '../features/shop/screens/category/all_categories/categories.dart';
import '../features/shop/screens/category/create_category/create_category.dart';
import '../features/shop/screens/category/edit_category/edit_category.dart';
import '../features/shop/screens/customer/customer_details/customer.dart';
import '../features/shop/screens/dashboard/dashboard_screen.dart';
import '../features/shop/screens/product/create_product/create_product.dart';
import '../features/shop/screens/product/edit_product/edit_product.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(
        name: Routes.forgetPassword, page: () => const ForgetPasswordSCreen()),
    GetPage(
        name: Routes.resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(
        name: Routes.dashboard,
        page: () => const DashboardScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.media,
        page: () => const MediaScreen(),
        middlewares: [RoutesMiddleware()]),

    //Categories
    GetPage(
        name: Routes.categories,
        page: () => const CategoriesScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.createCategory,
        page: () => const CreateCategoryScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.editCategory,
        page: () => const EditCategoryScreen(),
        middlewares: [RoutesMiddleware()]),

    //Brands
    GetPage(
        name: Routes.brands,
        page: () => const BrandsScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.createBrand,
        page: () => const CreateBrandScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.editBrand,
        page: () => const EditBrandScreen(),
        middlewares: [RoutesMiddleware()]),

    //Banners
    GetPage(
        name: Routes.banners,
        page: () => const BannersScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.createBanner,
        page: () => const CreateBannerScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.editBanner,
        page: () => const EditBannerScreen(),
        middlewares: [RoutesMiddleware()]),

    //Products
    GetPage(
        name: Routes.products,
        page: () => const ProductsScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.createProduct,
        page: () => const CreateProductScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.editProduct,
        page: () => const EditProductScreen(),
        middlewares: [RoutesMiddleware()]),

    //Customers
    GetPage(
        name: Routes.customers,
        page: () => const CustomersScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.customerDetails,
        page: () => const CustomerDetailsScreen(),
        middlewares: [RoutesMiddleware()]),

    //Orders
    GetPage(
        name: Routes.orders,
        page: () => const OrdersScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.orderDetails,
        page: () => const OrderDetailsScreen(),
        middlewares: [RoutesMiddleware()]),

    //Others
    GetPage(
        name: Routes.profile,
        page: () => const ProfileScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.settings,
        page: () => const SettingsScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.logout,
        page: () => const LoginScreen(),
        middlewares: [RoutesMiddleware()]),
  ];
}
