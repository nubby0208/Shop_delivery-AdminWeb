import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../main.dart';
import '../network/RestApis.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';
import '../utils/Extensions/app_textfield.dart';

class ChangePasswordDialog extends StatefulWidget {
  static String tag = '/ChangePasswordDialog';

  @override
  ChangePasswordDialogState createState() => ChangePasswordDialogState();
}

class ChangePasswordDialogState extends State<ChangePasswordDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode oldPassFocus = FocusNode();
  FocusNode newPassFocus = FocusNode();
  FocusNode confirmPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      Map req = {
        'old_password': oldPassController.text.trim(),
        'new_password': newPassController.text.trim(),
      };
      appStore.setLoading(true);

      await shared_pref.setString(USER_PASSWORD, newPassController.text.trim());

      await changePassword(req).then((value) {
        toast(value.message.toString());
        appStore.setLoading(false);

        Navigator.pop(context);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.only(right: 16, bottom: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(language.changePassword, style: boldTextStyle(color: primaryColor, size: 20)),
          IconButton(
            icon: Icon(Icons.close),
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Stack(
          children: [
            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.oldPassword, style: primaryTextStyle()),
                    SizedBox(height: 8),
                    AppTextField(
                      controller: oldPassController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: oldPassFocus,
                      nextFocus: newPassFocus,
                      decoration: commonInputDecoration(),
                      errorThisFieldRequired: language.field_required_msg,
                      errorMinimumPasswordLength: language.passwordValidation,
                    ),
                    SizedBox(height: 16),
                    Text(language.newPassword, style: primaryTextStyle()),
                    SizedBox(height: 8),
                    AppTextField(
                      controller: newPassController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: newPassFocus,
                      nextFocus: confirmPassFocus,
                      decoration: commonInputDecoration(),
                      errorThisFieldRequired: language.field_required_msg,
                      errorMinimumPasswordLength: language.passwordValidation,
                    ),
                    SizedBox(height: 16),
                    Text(language.confirmPassword, style: primaryTextStyle()),
                    SizedBox(height: 8),
                    AppTextField(
                      controller: confirmPassController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: confirmPassFocus,
                      decoration: commonInputDecoration(),
                      errorThisFieldRequired: language.field_required_msg,
                      errorMinimumPasswordLength: language.passwordValidation,
                      validator: (val) {
                        if (val!.isEmpty) return language.field_required_msg;
                        if (val != newPassController.text) return language.passwordNotMatch;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (context) => Visibility(visible: appStore.isLoading, child: Positioned.fill(child: loaderWidget()))),
          ],
        ),
      ),
      actions: <Widget>[
        dialogSecondaryButton(language.cancel, () {
          Navigator.pop(context);
        }),
        SizedBox(width: 4),
        dialogPrimaryButton(language.save, () {
          submit();
        }),
      ],
    );
  }
}
