import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:local_delivery_admin/models/LDBaseResponse.dart';
import 'package:local_delivery_admin/models/PaymentGatewayListModel.dart';
import 'package:local_delivery_admin/network/NetworkUtils.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/screens/PaymentSetupScreen.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import '../main.dart';

class PaymentGatewayWidget extends StatefulWidget {
  @override
  PaymentGatewayWidgetState createState() => PaymentGatewayWidgetState();
}

class PaymentGatewayWidgetState extends State<PaymentGatewayWidget> {
  int currentIndex = 0;
  int currentPage = 1;

  List<PaymentGatewayData> paymentGatewayList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
      getPaymentGatewayListApiCall();
    });
  }

  getPaymentGatewayListApiCall() async {
    appStore.setLoading(true);
    await getPaymentGatewayList().then((value) {
      appStore.setLoading(false);
      paymentGatewayList.clear();
      paymentGatewayList.addAll(value.data!);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  /// Update Payment Status
  Future<void> updateStatusApiCall(PaymentGatewayData paymentGatewayData) async {
    appStore.setLoading(true);
    MultipartRequest multiPartRequest = await getMultiPartRequest('paymentgateway-save');

    multiPartRequest.fields['id'] = paymentGatewayData.id!.toString();
    multiPartRequest.fields['status'] = paymentGatewayData.status == 1 ? "0" : "1";
    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        if (data != null) {
          LDBaseResponse res = LDBaseResponse.fromJson(jsonDecode(data));
          toast(res.message.toString());
          getPaymentGatewayListApiCall();
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

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.payment_gateway, style: boldTextStyle(size: 20, color: primaryColor)),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
                        child: Text(language.setup, style: boldTextStyle(color: Colors.white)),
                      ),
                      onTap: () {
                        launchScreen(
                            context,
                            PaymentSetupScreen(
                              paymentGatewayList: paymentGatewayList,
                              onUpdate: () {
                                getPaymentGatewayListApiCall();
                              },
                            ));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                paymentGatewayList.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.circular(defaultRadius), boxShadow: commonBoxShadow()),
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: getBodyWidth(context) - 48),
                          child: DataTable(
                            dataRowHeight: 60,
                            headingRowHeight: 45,
                            horizontalMargin: 16,
                            headingRowColor: MaterialStateColor.resolveWith((states) => primaryColor.withOpacity(0.1)),
                            showCheckboxColumn: false,
                            dataTextStyle: primaryTextStyle(size: 14),
                            headingTextStyle: boldTextStyle(),
                            columns: [
                              DataColumn(label: Text(language.id)),
                              DataColumn(label: Text(language.payment_method)),
                              DataColumn(label: Text(language.image)),
                              DataColumn(label: Text(language.mode)),
                              DataColumn(label: Text(language.status)),
                              DataColumn(label: Text(language.actions)),
                            ],
                            rows: paymentGatewayList.map((mData) {
                              return DataRow(cells: [
                                DataCell(Text('${mData.id ?? ""}')),
                                DataCell(Text('${mData.title ?? ""}')),
                                DataCell(
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: commonCachedNetworkImage('${mData.gatewayLogo!}', fit: BoxFit.fitHeight, height: 60, width: 60),
                                  ),
                                ),
                                DataCell(Text(mData.isTest == 1 ? language.test : language.live)),
                                DataCell(
                                  TextButton(
                                    child: Text(
                                      '${mData.status == 1 ? language.enable : language.disable}',
                                      style: primaryTextStyle(color: mData.status == 1 ? primaryColor : Colors.red),
                                    ),
                                    onPressed: () {
                                      commonConfirmationDialog(context, mData.status == 1 ? DIALOG_TYPE_DISABLE : DIALOG_TYPE_ENABLE, () {
                                        if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                          toast(language.demo_admin_msg);
                                        } else {
                                          Navigator.pop(context);
                                          updateStatusApiCall(mData);
                                        }
                                      },
                                          title: mData.status != 1 ? language.enable_payment : language.disable_payment,
                                          subtitle: mData.status != 1 ? language.do_you_want_to_enable_this_payment : language.do_you_want_to_disable_this_payment);
                                    },
                                  ),
                                ),
                                DataCell(
                                  OutlineActionIcon(Icons.edit, Colors.green, language.edit, () async {
                                    await launchScreen(
                                        context,
                                        PaymentSetupScreen(
                                          paymentGatewayList: paymentGatewayList,
                                          paymentType: mData.type,
                                          onUpdate: () {
                                            getPaymentGatewayListApiCall();
                                          },
                                        ));
                                  }),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                  ],
                )
                    : SizedBox(),
              ],
            ),
          ),
          appStore.isLoading
              ? loaderWidget()
              : paymentGatewayList.isEmpty
              ? emptyWidget()
              : SizedBox(),
        ],
      );
    });
  }
}
