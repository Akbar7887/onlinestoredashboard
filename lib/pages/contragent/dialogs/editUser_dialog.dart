import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import '../../../generated/l10n.dart';
import '../../../models/constants/main_constant.dart';
import '../../../models/contragent/User.dart';

TextEditingController _nameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _phoneController = TextEditingController();

String _id = '';
String _create = '';
final _keyEdit = GlobalKey<FormState>();
final Controller _controller = Get.find();

bool _hidePass = true;

var _formatterToSend = new DateFormat('yyyy-MM-dd  HH:mm:ss');

class EditUserDialog extends StatelessWidget {
  EditUserDialog({Key? key}) : super(key: key);

  Widget mainTab(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, setState) => ListView(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text('${S.of(context).userId}: ${_id}')),
                SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text('${S.of(context).date_create}: ${_create}')),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).validate;
                      }
                    },
                    style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                        color: Colors.black),
                    decoration: MainConstant.decorationUserForm(
                        S.of(context).user,
                        Icon(Icons.person),
                        () => _nameController.clear(),
                        Icon(Icons.delete))),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    obscureText: _hidePass,
                    controller: _passwordController,
                    maxLength: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).validate;
                      }
                    },
                    style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                        color: Colors.black),
                    decoration: MainConstant.decorationUserForm(
                      S.of(context).password,
                      Icon(Icons.security),
                      () => setState(() {
                        _hidePass = !_hidePass;
                      }),
                      Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                    )),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).validate;
                      }
                    },
                    style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                        color: Colors.black),
                    decoration: MainConstant.decoration(S.of(context).phone)),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.user.value.id != null) {
        _nameController.text = _controller.user.value.username!;
        _passwordController.text = _controller.user.value.password!;
        _phoneController.text = _controller.user.value.phone!;
        _id = _controller.user.value.id.toString();
        _create = _formatterToSend.format(
            DateTime.parse(_controller.user.value.dateCreate.toString()));
      } else {
        _id = '';
        _create = '';
        _nameController.clear();
        _passwordController.clear();
        _phoneController.clear();
      }
      // if (_controller.catalog.value.id != null) {
      //   _controller.catalog.value = _controller.catalogslist.value.firstWhere(
      //           (element) => element.id == _controller.catalog.value.id);
      // }

      return AlertDialog(
        title: Text(S.of(context).form_dialog),
        content: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height,
                child: Form(
                    key: _keyEdit,
                    child: Column(children: [
                      Expanded(
                        child: mainTab(context),
                      )
                    ])))),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (!_keyEdit.currentState!.validate()) {
                return;
              }
              User? _user;
              _user = _controller.user.value;
              if (_user.id == null) {
                _user = User();
              }
              _user.username = _nameController.text;
              _user.password = _passwordController.text;
              _user.phone = _phoneController.text;

              _controller.save("doc/user/save", _user).then((value) {
                _controller.user.value = User.fromJson(value);

                User? result = _controller.users.value.firstWhereOrNull(
                    (element) => element.id == _controller.user.value.id);
                if (result == null) {
                  _controller.users.value.add(_controller.user.value);
                }
                _controller.users.refresh();
                Navigator.of(context).pop();
              });
            },
            child: Text(S.of(context).save),
          ),
          TextButton(
            child: Text(S.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss alert dialog
            },
          ),
        ],
      );
    });
  }
}
