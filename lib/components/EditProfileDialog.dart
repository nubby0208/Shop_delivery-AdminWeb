import 'dart:typed_data';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../network/RestApis.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';
import '../utils/Extensions/app_textfield.dart';

class EditProfileDialog extends StatefulWidget {
  static String tag = '/EditProfileDialog';

  @override
  EditProfileDialogState createState() => EditProfileDialogState();
}

class EditProfileDialogState extends State<EditProfileDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String countryCode = '+91';

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode contactFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  XFile? imageProfile;
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    String phoneNum = shared_pref.getString(USER_CONTACT_NUMBER) ?? "";
    emailController.text = shared_pref.getString(USER_EMAIL) ?? "";
    usernameController.text = shared_pref.getString(USER_NAME) ?? "";
    nameController.text = shared_pref.getString(NAME) ?? "";
    if (phoneNum.split(" ").length == 1) {
      contactNumberController.text = phoneNum.split(" ").last;
    } else {
      countryCode = phoneNum.split(" ").first;
      contactNumberController.text = phoneNum.split(" ").last;
    }
    addressController.text = shared_pref.getString(USER_ADDRESS) ?? "";
  }

  Widget profileImage() {
    if (image != null) {
      return ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.memory(image!, height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center));
    } else {
      if (appStore.userProfile.isNotEmpty) {
        return ClipRRect(borderRadius: BorderRadius.circular(50), child: commonCachedNetworkImage(appStore.userProfile, fit: BoxFit.cover, height: 100, width: 100));
      } else {
        return Padding(
          padding: EdgeInsets.only(right: 4, bottom: 4),
          child: ClipRRect(child: commonCachedNetworkImage('assets/profile.png', height: 90, width: 90)),
        );
      }
    }
  }

  Future<void> getImage() async {
    imageProfile = null;
    imageProfile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    image = await imageProfile!.readAsBytes();
    setState(() {});
  }

  Future<void> save() async {
    appStore.setLoading(true);
    await updateProfile(
      image: image,
      fileName: imageProfile != null ? imageProfile!.path.split('/').last : shared_pref.getString(USER_PROFILE_PHOTO)!.split('/').last,
      name: nameController.text,
      userName: usernameController.text,
      userEmail: emailController.text,
      address: addressController.text,
      contactNumber: '$countryCode ${contactNumberController.text.trim()}',
    ).then((value) {
      Navigator.pop(context, true);
      appStore.setLoading(false);
      toast(language.profileUpdatedSuccessfully);
    }).catchError((error) {
      log(error);
      appStore.setLoading(false);
    });
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
          Text(language.editProfile, style: boldTextStyle(color: primaryColor, size: 20)),
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
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(child: profileImage()),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 60, left: 80),
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: primaryColor),
                            child: IconButton(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.email, style: primaryTextStyle()),
                              SizedBox(height: 8),
                              AppTextField(
                                readOnly: true,
                                controller: emailController,
                                textFieldType: TextFieldType.EMAIL,
                                focus: emailFocus,
                                nextFocus: usernameFocus,
                                decoration: commonInputDecoration(),
                                onTap: () {
                                  toast(language.youCannotChangeEmailId);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.username, style: primaryTextStyle()),
                            SizedBox(height: 8),
                            AppTextField(
                              readOnly: true,
                              controller: usernameController,
                              textFieldType: TextFieldType.USERNAME,
                              focus: usernameFocus,
                              nextFocus: nameFocus,
                              decoration: commonInputDecoration(),
                              onTap: () {
                                toast(language.youCannotChangeUsername);
                              },
                            ),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.name, style: primaryTextStyle()),
                              SizedBox(height: 8),
                              AppTextField(
                                controller: nameController,
                                textFieldType: TextFieldType.NAME,
                                focus: nameFocus,
                                nextFocus: addressFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired: language.field_required_msg,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.address, style: primaryTextStyle()),
                            SizedBox(height: 8),
                            AppTextField(
                              controller: addressController,
                              textFieldType: TextFieldType.OTHER,
                              focus: addressFocus,
                              decoration: commonInputDecoration(),
                            ),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(language.contactNumber, style: primaryTextStyle()),
                    SizedBox(height: 8),
                    AppTextField(
                      controller: contactNumberController,
                      textFieldType: TextFieldType.PHONE,
                      focus: contactFocus,
                      nextFocus: addressFocus,
                      decoration: commonInputDecoration(
                        prefixIcon: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CountryCodePicker(
                                initialSelection: countryCode,
                                showCountryOnly: false,
                                showFlag: true,
                                showFlagDialog: true,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                textStyle: primaryTextStyle(),
                                dialogBackgroundColor: Theme.of(context).cardColor,
                                barrierColor: Colors.black12,
                                dialogTextStyle: primaryTextStyle(),
                                searchDecoration: InputDecoration(
                                  iconColor: Theme.of(context).dividerColor,
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                ),
                                searchStyle: primaryTextStyle(),
                                onInit: (c) {
                                  countryCode = c!.dialCode!;
                                },
                                onChanged: (c) {
                                  countryCode = c.dialCode!;
                                },
                              ),
                              VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                            ],
                          ),
                        ),
                      ),
                      validator: (s) {
                        if (s!.trim().isEmpty) return language.field_required_msg;
                        if (s.trim().length < 10 && s.trim().length > 14) return language.contact_length_validation;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => Visibility(visible: appStore.isLoading, child: Positioned.fill(child: loaderWidget()))),
          ],
        ),
      ),
      actions: <Widget>[
        dialogSecondaryButton(language.cancel, () {
          Navigator.pop(context);
        }),
        SizedBox(width: 4),
        dialogPrimaryButton(language.save, () {
          if (_formKey.currentState!.validate()) {
            save();
          }
        }),
      ],
    );
  }
}
