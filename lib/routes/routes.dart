class Routes {
  static const login = '/login';
  static const forgetPassword = '/forget-password';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const media = '/media';

  //Category
  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory';

  //Brands
  static const brands = '/brands';
  static const createBrand = '/createBrand';
  static const editBrand = '/editBrand';

  //Banners
  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner';

  //Products
  static const products = '/products';
  static const createProduct = '/createProduct';
  static const editProduct = '/editProduct';

  //Customers
  static const customers = '/customers';
  static const customerDetails = '/customerDetails';

  //Orders
  static const orders = '/orders';
  static const orderDetails = '/orderDetails';

  //Others
  static const coupons = '/coupons';
  static const profile = '/profile';
  static const settings = '/settings';
  static const logout = '/logout';

  static List sidebarMenuItems = [
    dashboard,
    media,
    categories,
    brands,
    banners,
    products,
    customers,
    orders,
    profile,
    settings,
  ];
}
