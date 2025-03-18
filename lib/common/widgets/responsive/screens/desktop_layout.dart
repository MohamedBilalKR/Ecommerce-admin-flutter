import 'package:e_commerce_admin/common/widgets/layouts/headers/header.dart';
import 'package:e_commerce_admin/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: SideBar()),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                //Header
                const Header(),

                //Body
                Expanded(child: body ?? const SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
