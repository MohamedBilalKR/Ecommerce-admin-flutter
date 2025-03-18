import 'package:e_commerce_admin/common/widgets/layouts/headers/header.dart';
import 'package:e_commerce_admin/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  MobileLayout({super.key, this.body});

  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const SideBar(),
      appBar: Header(scaffoldKey: scaffoldKey),
      body: body ?? const SizedBox(),
    );
  }
}
