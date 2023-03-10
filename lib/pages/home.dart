import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlinestoredashboard/controller/UniversalController.dart';
import 'package:onlinestoredashboard/pages/catalogs/product_page.dart';
import 'package:onlinestoredashboard/widgets/onlineAppBar.dart';
import 'package:onlinestoredashboard/widgets/onlineDrawer.dart';

import '../controller/Controller.dart';
import 'catalogs/catalog_page.dart';

final UniversalController _universalController = Get.put(UniversalController());

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(Controller());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OnlineAppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Expanded(child: OnlineDrawer()),
            // VerticalDivider(),
            Expanded(flex: 4, child: selectPage())
          ],
        ),
      ),
    );
  }

  selectPage() {
    switch (_universalController.page.value) {
      case 1:
        {
          return CatalogPage();
        }
        break;
      case 0:
        {
          return ProductPage();
        }
        break;
      default:
        {
          return Container();
        }
    }
  }
}
