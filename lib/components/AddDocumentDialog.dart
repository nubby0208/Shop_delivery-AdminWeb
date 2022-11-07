import 'package:flutter/material.dart';
import 'package:local_delivery_admin/network/RestApis.dart';

import '../main.dart';
import '../models/DocumentListModel.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';
import '../utils/Extensions/app_textfield.dart';

class AddDocumentDialog extends StatefulWidget {
  static String tag = '/AddDocumentDialog';

  final DocumentData? documentData;
  final Function()? onUpdate;

  AddDocumentDialog({this.documentData, this.onUpdate});

  @override
  AddDocumentDialogState createState() => AddDocumentDialogState();
}

class AddDocumentDialogState extends State<AddDocumentDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  bool isUpdate = false;
  bool isRequired = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.documentData != null;
    if (isUpdate) {
      nameController.text = widget.documentData!.name!;
      isRequired = widget.documentData!.isRequired == 1;
    }
  }

  AddDocumentApiCall() async {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      Map req = {
        "id": isUpdate ? widget.documentData!.id : "",
        "name": nameController.text,
        "is_required": isRequired ? 1 : 0,
      };
      appStore.setLoading(true);
      await addDocument(req).then((value) {
        appStore.setLoading(false);
        toast(value.message.toString());
        widget.onUpdate!.call();
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
          Text(isUpdate ? language.updateDocument : language.add_document, style: boldTextStyle(color: primaryColor, size: 20)),
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(language.name, style: primaryTextStyle()),
                SizedBox(height: 8),
                AppTextField(
                  controller: nameController,
                  textFieldType: TextFieldType.NAME,
                  decoration: commonInputDecoration(),
                  textInputAction: TextInputAction.next,
                  validator: (s) {
                    if (s!.trim().isEmpty) return language.field_required_msg;
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  value: isRequired,
                  onChanged: (value) {
                    isRequired = value!;
                    setState(() {});
                  },
                  activeColor:primaryColor,
                  title: Text(language.required, style: primaryTextStyle()),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        dialogSecondaryButton(language.cancel, () {
          Navigator.pop(context);
        }),
        SizedBox(width: 4),
        dialogPrimaryButton(isUpdate ? language.update : language.add, () {
          if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
            toast(language.demo_admin_msg);
          } else {
            AddDocumentApiCall();
          }
        }),
      ],
    );
  }
}
