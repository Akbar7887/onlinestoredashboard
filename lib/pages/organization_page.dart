import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import 'package:onlinestoredashboard/models/Organization.dart';
import 'package:onlinestoredashboard/models/constants/main_constant.dart';

import '../widgets/onlineAppBar.dart';

TextEditingController? _nameController = TextEditingController();
TextEditingController? _adressController = TextEditingController();
TextEditingController? _emailController = TextEditingController();
TextEditingController? _facebookController = TextEditingController();
TextEditingController? _instagramController = TextEditingController();
TextEditingController? _regionController = TextEditingController();
TextEditingController? _telegramController = TextEditingController();
TextEditingController? _telephonController = TextEditingController();
final _keyForm = GlobalKey<FormState>();
Organization? _organization;
Controller _controller = Get.put(Controller());

class OrganizationPage extends StatelessWidget {
  const OrganizationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _organization = _controller.organization;
    if (_controller.organization != null) {
      _nameController!.text = _organization!.name!;
      _adressController!.text = _organization!.adress!;
      _emailController!.text = _organization!.email!;
      _facebookController!.text = _organization!.facebook!;
      _instagramController!.text = _organization!.instagram!;
      _regionController!.text = _organization!.region!;
      _telegramController!.text = _organization!.telegram!;
      _telephonController!.text = _organization!.telephon!;
    }

    return SafeArea(
        child: Scaffold(
            appBar: OnlineAppBar(),
            body: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _keyForm,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Организация",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextFormField(
                                            controller: _nameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Просим заплнить поля";
                                              }
                                            },
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.black),
                                            decoration: MainConstant.decoration(
                                                "Наименование"))),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextFormField(
                                            controller: _telephonController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Просим заплнить поля";
                                              }
                                            },
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.black),
                                            decoration: MainConstant.decoration(
                                                "Телефон"))),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextFormField(
                                            controller: _regionController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Просим заплнить поля";
                                              }
                                            },
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.black),
                                            decoration: MainConstant.decoration(
                                                "Регион"))),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextFormField(
                                            controller: _adressController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Просим заплнить поля";
                                              }
                                            },
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.black),
                                            decoration: MainConstant.decoration(
                                                "Адрес"))),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextFormField(
                                            controller: _emailController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Просим заплнить поля";
                                              }
                                            },
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.black),
                                            decoration: MainConstant.decoration(
                                                "e-mail"))),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextFormField(
                                            controller: _facebookController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Просим заплнить поля";
                                              }
                                            },
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.black),
                                            decoration: MainConstant.decoration(
                                                "Facebook"))),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextFormField(
                                            controller: _instagramController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Просим заплнить поля";
                                              }
                                            },
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.black),
                                            decoration: MainConstant.decoration(
                                                "Instagram"))),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextFormField(
                                            controller: _telegramController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Просим заплнить поля";
                                              }
                                            },
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.black),
                                            decoration: MainConstant.decoration(
                                                "Telegram"))),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    if (!_keyForm.currentState!.validate()) {
                                      return;
                                    }

                                    if (_organization == null) {
                                      _organization = Organization();
                                    }
                                    _organization!.name = _nameController!.text;
                                    _organization!.adress =
                                        _adressController!.text;
                                    _organization!.email =
                                        _emailController!.text;
                                    _organization!.facebook =
                                        _facebookController!.text;
                                    _organization!.instagram =
                                        _instagramController!.text;
                                    _organization!.region =
                                        _regionController!.text;
                                    _organization!.telegram =
                                        _telegramController!.text;
                                    _organization!.telephon =
                                        _telephonController!.text;

                                    _controller
                                        .changeObject(
                                            "organization/save", _organization)
                                        .then((value) => ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Организация было изменен!"))));
                                  },
                                  child: Text("Сохранить")),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () {}, child: Text("Отмена")),
                            ],
                          ))
                    ],
                  ),
                ))));
  }
}
