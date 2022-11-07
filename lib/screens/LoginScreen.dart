import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/screens/DashboardScreen.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/StringExtensions.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';
import 'package:local_delivery_admin/utils/Extensions/app_textfield.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../components/ForgotPasswordDialog.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PackageInfo? packageInfo;
  String fcmToken = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
    await saveFcmTokenId().then((value) {
    });
  }

  Future<void> LoginApiCall() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      appStore.setLoading(true);
      
      Map req = {
        "email": emailController.text,
        "password": passwordController.text,
        "fcm_token": shared_pref.getString(FCM_TOKEN).validate(),
      };

      await logInApi(req).then((value) async {
        appStore.setLoading(false);
        if(value.data!.userType!=ADMIN && value.data!.userType!=DEMO_ADMIN){
          await logout(context,isFromLogin: true);
        }else {
          launchScreen(context, DashboardScreen(), isNewTask: true);
        }
      }).catchError((e) {
        appStore.setLoading(false);

        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: primaryColor,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Image.asset('assets/app_logo_primary.png'),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        ),
                        SizedBox(height: 30),
                        Text(language.app_name, style: boldTextStyle(color: Colors.white, size: 20)),
                      ],
                    ),
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        return Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('v${snap.data!.version}', style: primaryTextStyle(color: Colors.white70)),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 16),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(language.admin_sign_in, style: boldTextStyle(size: 30)),
                          SizedBox(height: 16),
                          Text(language.sign_in_your_account, style: secondaryTextStyle(size: 16)),
                          SizedBox(height: 50),
                          Text(language.email, style: primaryTextStyle()),
                          SizedBox(height: 8),
                          AppTextField(
                            controller: emailController,
                            textFieldType: TextFieldType.EMAIL,
                            decoration: commonInputDecoration(),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 16),
                          Text(language.password, style: primaryTextStyle()),
                          SizedBox(height: 8),
                          AppTextField(
                            controller: passwordController,
                            textFieldType: TextFieldType.PASSWORD,
                            decoration: commonInputDecoration(),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerRight,
                            child: commonButton(language.login, () {
                              LoginApiCall();
                            }, width: 200),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Observer(builder: (context) => appStore.isLoading ? loaderWidget() : SizedBox()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext dialogContext) {
                              return ForgotPasswordDialog();
                            },
                          );
                        },
                        child: Text(language.forgotPassword, style: primaryTextStyle(color: primaryColor))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
