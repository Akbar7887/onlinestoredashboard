import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlinestoredashboard/pages/catalogs/product_page.dart';
import 'package:onlinestoredashboard/pages/organization_page.dart';
import 'package:onlinestoredashboard/widgets/onlineAppBar.dart';
import 'package:onlinestoredashboard/widgets/onlineDrawer.dart';

import '../controller/Controller.dart';
import '../generated/l10n.dart';
import 'catalogs/catalog_page.dart';
import '../widgets/header.dart';

final Controller _controller = Get.put(Controller());

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(Controller());
  bool showDrawer = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: OnlineAppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [
              showDrawer ? Expanded(child: OnlineDrawer()) : Container(),
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                setState(() {
                                  showDrawer = !showDrawer;
                                });
                              },
                            ),
                            Header(selectPageName()),

                          ],
                        ),
                      ),
                      Expanded(child: selectPage())
                    ],
                  ))
            ],
          ),
        )));
  }

  selectPage() {
    switch (_controller.page.value) {
      case 0:
        {
          return OrganizationPage();
        }
        break;
      case 1:
        {
          return CatalogPage();
        }
        break;
      case 2:
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
  String selectPageName() {
    switch (_controller.page.value) {
      case 0:
        {
          return S.of(context).organization;
        }
        break;
      case 1:
        {
          return S.of(context).catalog_page_name;
        }
        break;
      case 2:
        {
          return S.of(context).product;
        }
        break;
      default:
        {
          return "";
        }
    }
  }
}
