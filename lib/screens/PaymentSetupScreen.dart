import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_delivery_admin/models/LDBaseResponse.dart';
import 'package:local_delivery_admin/models/PaymentGatewayListModel.dart';
import 'package:local_delivery_admin/models/models.dart';
import 'package:local_delivery_admin/network/NetworkUtils.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/DataProvider.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';
import 'package:local_delivery_admin/utils/Extensions/app_textfield.dart';

import '../components/BodyCornerWidget.dart';
import '../main.dart';
import '../utils/Extensions/LiveStream.dart';

class PaymentSetupScreen extends StatefulWidget {
  static String tag = '/PaymentSetupScreen';
  final Function()? onUpdate;
  final String? paymentType;
  final List<PaymentGatewayData> paymentGatewayList;

  PaymentSetupScreen({required this.paymentGatewayList, this.paymentType, this.onUpdate});

  @override
  PaymentSetupScreenState createState() => PaymentSetupScreenState();
}

class PaymentSetupScreenState extends State<PaymentSetupScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController secretKeyController = TextEditingController();
  TextEditingController publishableKeyController = TextEditingController();
  TextEditingController keyIdController = TextEditingController();
  TextEditingController secretIdController = TextEditingController();
  TextEditingController publicKeyController = TextEditingController();
  TextEditingController encryptionKeyController = TextEditingController();

  TextEditingController tokenizationKeyController = TextEditingController();
  TextEditingController accessTokenController = TextEditingController();
  TextEditingController profileIdController = TextEditingController();
  TextEditingController serverKeyController = TextEditingController();
  TextEditingController clientKeyController = TextEditingController();
  TextEditingController mIDController = TextEditingController();
  TextEditingController merchantKeyController = TextEditingController();

  List<StaticPaymentModel> staticPaymentList = getStaticPaymentItems();

  String selectedPaymentType = PAYMENT_GATEWAY_STRIPE;
  int? isTest;
  bool isUpdate = false;
  PaymentGatewayData? paymentGatewayData;
  String? logoImagePath;

  final ImagePicker _picker = ImagePicker();
  Uint8List? logoImage;
  String? logoImageName;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on(streamLanguage, (p0) {
      LiveStream().on(streamLanguage, (p0) {
        staticPaymentList.clear();
        staticPaymentList = getStaticPaymentItems();
        setState(() {});
      });
    });
    if (widget.paymentType != null) {
      selectedPaymentType = widget.paymentType!;
    }
    checkIsUpdate();
  }

  checkIsUpdate() async {
    var data = widget.paymentGatewayList.where((element) {
      if (element.type!.contains(selectedPaymentType)) {
        paymentGatewayData = element;
        setState(() {});
      }
      return element.type!.contains(selectedPaymentType);
    });
    if (data.length >= 1) {
      isUpdate = true;
    } else {
      isUpdate = false;
    }
    await setData();
  }

  setData() {
    if (isUpdate) {
      paymentMethodController.text = paymentGatewayData!.title ?? "";
      secretKeyController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.secretKey ?? "" : paymentGatewayData!.liveValue!.secretKey ?? "";
      publishableKeyController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.publishableKey ?? "" : paymentGatewayData!.liveValue!.publishableKey ?? "";
      keyIdController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.keyId ?? "" : paymentGatewayData!.liveValue!.keyId ?? "";
      secretIdController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.secretId ?? "" : paymentGatewayData!.liveValue!.secretId ?? "";
      publicKeyController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.publicKey ?? "" : paymentGatewayData!.liveValue!.publicKey ?? "";
      encryptionKeyController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.encryptionKey ?? "" : paymentGatewayData!.liveValue!.encryptionKey ?? "";

      tokenizationKeyController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.tokenizationKey ?? "" : paymentGatewayData!.liveValue!.tokenizationKey ?? "";
      accessTokenController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.accessToken ?? "" : paymentGatewayData!.liveValue!.accessToken ?? "";
      profileIdController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.profileId ?? "" : paymentGatewayData!.liveValue!.profileId ?? "";
      serverKeyController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.serverKey ?? "" : paymentGatewayData!.liveValue!.serverKey ?? "";
      clientKeyController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.clientKey ?? "" : paymentGatewayData!.liveValue!.clientKey ?? "";
      mIDController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.merchantId ?? "" : paymentGatewayData!.liveValue!.merchantId ?? "";
      merchantKeyController.text = paymentGatewayData!.isTest == 1 ? paymentGatewayData!.testValue!.merchantKey ?? "" : paymentGatewayData!.liveValue!.merchantKey ?? "";

      isTest = paymentGatewayData!.isTest!;
      logoImagePath = paymentGatewayData!.gatewayLogo!;
    } else {
      paymentMethodController.clear();
      secretKeyController.clear();
      publishableKeyController.clear();
      keyIdController.clear();
      secretIdController.clear();
      publicKeyController.clear();
      encryptionKeyController.clear();
      tokenizationKeyController.clear();
      accessTokenController.clear();
      profileIdController.clear();
      serverKeyController.clear();
      clientKeyController.clear();
      mIDController.clear();
      merchantKeyController.clear();
      isTest = null;
      logoImagePath = null;
    }
  }

  pickImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      logoImagePath = image.path;
      logoImage = await image.readAsBytes();
      logoImageName = image.name;
    }
    setState(() {});
  }

  String getPaymentTitle() {
    String title = '';
    staticPaymentList.forEach((element) {
      if (element.type == selectedPaymentType) {
        title = element.title!;
      }
    });
    return title;
  }

  /// Save Payment
  Future<void> savePaymentApiCall() async {
    appStore.setLoading(true);
    Map? valRequest;
    if (selectedPaymentType == PAYMENT_GATEWAY_STRIPE) {
      valRequest = {"secret_key": secretKeyController.text, "publishable_key": publishableKeyController.text};
    } else if (selectedPaymentType == PAYMENT_GATEWAY_RAZORPAY) {
      valRequest = {"key_id": keyIdController.text, "secret_id": secretIdController.text};
    } else if (selectedPaymentType == PAYMENT_GATEWAY_PAYSTACK) {
      valRequest = {"public_key": publicKeyController.text};
    } else if (selectedPaymentType == PAYMENT_GATEWAY_FLUTTERWAVE) {
      valRequest = {"public_key": publicKeyController.text, "secret_key": secretKeyController.text, "encryption_key": encryptionKeyController.text};
    } else if (selectedPaymentType == PAYMENT_GATEWAY_PAYPAL) {
      valRequest = {"tokenization_key": tokenizationKeyController.text};
    } else if (selectedPaymentType == PAYMENT_GATEWAY_PAYTABS) {
      valRequest = {"profile_id": profileIdController.text, "server_key": serverKeyController.text, "client_key": clientKeyController.text};
    } else if (selectedPaymentType == PAYMENT_GATEWAY_MERCADOPAGO) {
      valRequest = {"public_key": publicKeyController.text, "access_token": accessTokenController.text};
    } else if (selectedPaymentType == PAYMENT_GATEWAY_PAYTM) {
      valRequest = {"merchant_id": mIDController.text, "merchant_key": merchantKeyController.text};
    } else if (selectedPaymentType == PAYMENT_GATEWAY_MYFATOORAH) {
      valRequest = {"access_token": accessTokenController.text};
    }

    MultipartRequest multiPartRequest = await getMultiPartRequest('paymentgateway-save');

    multiPartRequest.fields['id'] = isUpdate ? paymentGatewayData!.id.toString() : "";
    multiPartRequest.fields['title'] = paymentMethodController.text;
    multiPartRequest.fields['type'] = selectedPaymentType;
    multiPartRequest.fields['is_test'] = isTest.toString();
    if (isTest == 1) {
      multiPartRequest.fields['test_value'] = jsonEncode(valRequest);
    } else if (isTest == 0) {
      multiPartRequest.fields['live_value'] = jsonEncode(valRequest);
    }
    if (logoImage != null) {
      multiPartRequest.files.add(MultipartFile.fromBytes('gateway_logo', logoImage!, filename: logoImageName));
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        if (data != null) {
          LDBaseResponse res = LDBaseResponse.fromJson(jsonDecode(data));
          toast(res.message.toString());
          Navigator.pop(context);
          widget.onUpdate!.call();
        }
      },
      onError: (error) {
        appStore.setLoading(false);
        toast(error.toString());
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget stripeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.secret_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller: shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : secretKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        SizedBox(height: 16),
        Text(language.publishable_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : publishableKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
      ],
    );
  }

  Widget razorPayForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.key_id, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() :  keyIdController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        /* SizedBox(height: 16),
        Text(language.secret_id, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : secretIdController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),*/
      ],
    );
  }

  Widget payStackForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.public_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller: shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : publicKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
      ],
    );
  }

  Widget flutterWaveForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.public_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller: shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : publicKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        SizedBox(height: 16),
        Text(language.secret_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller: shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : secretKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        SizedBox(height: 16),
        Text(language.encryption_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller: shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : encryptionKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
      ],
    );
  }

  Widget payPalForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.tokenization_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller: shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : tokenizationKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
      ],
    );
  }

  Widget mercadoPagoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.public_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller: shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : publicKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        SizedBox(height: 16),
        Text(language.access_token, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller: shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : accessTokenController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
      ],
    );
  }

  Widget payTabsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.profile_id, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : profileIdController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        SizedBox(height: 16),
        Text(language.server_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : serverKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        SizedBox(height: 16),
        Text(language.client_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : clientKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
      ],
    );
  }

  Widget paytmForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.mId, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : mIDController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        SizedBox(height: 16),
        Text(language.merchant_key, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : merchantKeyController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
      ],
    );
  }

  Widget myFatoorahForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.token, style: primaryTextStyle()),
        SizedBox(height: 8),
        AppTextField(
          controller:  shared_pref.getString(USER_TYPE) == DEMO_ADMIN ? TextEditingController() : accessTokenController,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: commonInputDecoration(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return BodyCornerWidget(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 40),
              controller: ScrollController(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: staticPaymentList.map((mData) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(defaultRadius),
                          onTap: () {
                            selectedPaymentType = mData.type!;
                            checkIsUpdate();
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedPaymentType == mData.type ? primaryColor : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              mData.title!,
                              style: boldTextStyle(color: selectedPaymentType == mData.type ? Colors.white : null),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: containerDecoration(),
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${getPaymentTitle()} ${language.payment}', style: boldTextStyle(size: 18)),
                            SizedBox(height: 24),
                            Text(language.payment_method, style: primaryTextStyle()),
                            SizedBox(height: 8),
                            AppTextField(controller: paymentMethodController, textFieldType: TextFieldType.NAME, textInputAction: TextInputAction.next, decoration: commonInputDecoration()),
                            SizedBox(height: 16),
                            Text(language.mode, style: primaryTextStyle()),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    activeColor: primaryColor,
                                    value: 1,
                                    toggleable: true,
                                    title: Text(language.test, style: primaryTextStyle()),
                                    groupValue: isTest,
                                    onChanged: (int? val) {
                                      isTest = val!;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    activeColor: primaryColor,
                                    value: 0,
                                    title: Text(language.live, style: primaryTextStyle()),
                                    groupValue: isTest,
                                    onChanged: (int? val) {
                                      isTest = val!;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            if (selectedPaymentType == PAYMENT_GATEWAY_STRIPE) stripeForm(),
                            if (selectedPaymentType == PAYMENT_GATEWAY_RAZORPAY) razorPayForm(),
                            if (selectedPaymentType == PAYMENT_GATEWAY_PAYSTACK) payStackForm(),
                            if (selectedPaymentType == PAYMENT_GATEWAY_FLUTTERWAVE) flutterWaveForm(),
                            if (selectedPaymentType == PAYMENT_GATEWAY_PAYPAL) payPalForm(),
                            if (selectedPaymentType == PAYMENT_GATEWAY_PAYTABS) payTabsForm(),
                            if (selectedPaymentType == PAYMENT_GATEWAY_MERCADOPAGO) mercadoPagoForm(),
                            if (selectedPaymentType == PAYMENT_GATEWAY_PAYTM) paytmForm(),
                            if (selectedPaymentType == PAYMENT_GATEWAY_MYFATOORAH) myFatoorahForm(),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Text(language.image, style: primaryTextStyle()),
                                SizedBox(width: 16),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    backgroundColor: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Text(language.select_file, style: boldTextStyle(color: Colors.grey)),
                                  onPressed: () {
                                    pickImage();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            if (logoImagePath != null) Center(child: commonCachedNetworkImage(logoImagePath, height: 150, width: 150)),
                            SizedBox(height: 20),
                            Center(
                              child: commonButton(isUpdate ? language.update : language.save, () {
                                if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                  toast(language.demo_admin_msg);
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    if (isTest == null) return toast(language.please_select_payment_gateway_mode);
                                    savePaymentApiCall();
                                  }
                                }
                              }, width: 200),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Positioned(top: 16, right: 16, child: backButton(context)),
            Observer(builder: (context) => appStore.isLoading ? Center(child: loaderWidget()) : SizedBox()),
          ],
        ),
      );
    });
  }
}
