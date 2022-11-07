import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/UserModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import 'BodyCornerWidget.dart';
import 'DeliveryPersonDocumentWidget.dart';

class DeliveryBoyWidget extends StatefulWidget {
  @override
  DeliveryBoyWidgetState createState() => DeliveryBoyWidgetState();
}

class DeliveryBoyWidgetState extends State<DeliveryBoyWidget> {
  int currentPage = 1;
  int totalPage = 1;
  int perPage = 10;

  int currentIndex = 1;
  List<UserModel> deliveryBoyList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
      getDeliveryBoyListApiCall();
    });
  }

  getDeliveryBoyListApiCall() async {
    appStore.setLoading(true);
    await getAllUserList(type: DELIVERYMAN, page: currentPage, perPage: perPage).then((value) {
      appStore.setLoading(false);

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      deliveryBoyList.clear();
      deliveryBoyList.addAll(value.data!);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  updateStatusApiCall(UserModel deliveryBoyData) async {
    Map req = {
      "id": deliveryBoyData.id,
      "status": deliveryBoyData.status == 1 ? 0 : 1,
    };
    appStore.setLoading(true);
    await updateUserStatus(req).then((value) {
      appStore.setLoading(false);
      getDeliveryBoyListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  deleteDeliveryBoyApiCall(int id) async {
    Map req = {"id": id};
    appStore.setLoading(true);
    await deleteUser(req).then((value) {
      appStore.setLoading(false);
      getDeliveryBoyListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  restoreDeliveryBoyApiCall({@required int? id, @required String? type}) async {
    Map req = {"id": id, "type": type};
    appStore.setLoading(true);
    await userAction(req).then((value) {
      appStore.setLoading(false);
      getDeliveryBoyListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.delivery_person, style: boldTextStyle(size: 20, color: primaryColor)),
                SizedBox(height: 16),
                deliveryBoyList.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.circular(defaultRadius), boxShadow: commonBoxShadow()),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: ScrollController(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: getBodyWidth(context) - 48),
                                child: DataTable(
                                  dataRowHeight: 45,
                                  headingRowHeight: 45,
                                  horizontalMargin: 16,
                                  headingRowColor: MaterialStateColor.resolveWith((states) => primaryColor.withOpacity(0.1)),
                                  showCheckboxColumn: false,
                                  dataTextStyle: primaryTextStyle(size: 14),
                                  headingTextStyle: boldTextStyle(),
                                  columns: [
                                    DataColumn(label: Text(language.id)),
                                    DataColumn(label: Text(language.name)),
                                    DataColumn(label: Text(language.email_id)),
                                    DataColumn(label: Text(language.city)),
                                    DataColumn(label: Text(language.country)),
                                    DataColumn(label: Text(language.register_date)),
                                    DataColumn(label: Text(language.status)),
                                    DataColumn(label: Text(language.is_verified)),
                                    DataColumn(label: Text(language.actions)),
                                  ],
                                  rows: deliveryBoyList.map((e) {
                                    currentIndex = deliveryBoyList.indexOf(e);
                                    return DataRow(cells: [
                                      DataCell(Text('#${e.id}')),
                                      DataCell(Text(e.name ?? "-")),
                                      DataCell(Text(e.email ?? "-")),
                                      DataCell(Text(e.cityName ?? "-")),
                                      DataCell(Text(e.countryName ?? "-")),
                                      DataCell(Text(printDate(e.createdAt ?? ""))),
                                      DataCell(
                                        TextButton(
                                          child: Text(
                                            '${e.status == 1 ? language.enable : language.disable}',
                                            style: primaryTextStyle(color: e.status == 1 ? primaryColor : Colors.red),
                                          ),
                                          onPressed: () {
                                            commonConfirmationDialog(context, e.status == 1 ? DIALOG_TYPE_DISABLE : DIALOG_TYPE_ENABLE, () {
                                              if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                toast(language.demo_admin_msg);
                                              } else {
                                                Navigator.pop(context);
                                                updateStatusApiCall(e);
                                              }
                                            },
                                                title: e.status != 1 ? language.enable_delivery_person : language.disable_delivery_person,
                                                subtitle: e.status != 1 ? language.do_you_want_to_enable_this_delivery_person : language.do_you_want_to_disable_this_delivery_person);
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        e.isVerifiedDeliveryMan! == 1
                                            ? Text(language.verified, style: primaryTextStyle(color: Colors.green))
                                            : SizedBox(
                                                height: 25,
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      appStore.setSelectedMenuIndex(DELIVERY_PERSON_DOCUMENT_INDEX);
                                                      await launchScreen(
                                                          context,
                                                          BodyCornerWidget(
                                                            child: DeliveryPersonDocumentWidget(deliveryManId: e.id!),
                                                          ));
                                                    },
                                                    child: Text(language.verify))),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            if (e.deletedAt != null)
                                              Row(
                                                children: [
                                                  OutlineActionIcon(Icons.restore, Colors.green, language.restore, () {
                                                    commonConfirmationDialog(context, DIALOG_TYPE_RESTORE, () {
                                                      if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                        toast(language.demo_admin_msg);
                                                      } else {
                                                        Navigator.pop(context);
                                                        restoreDeliveryBoyApiCall(id: e.id, type: RESTORE);
                                                      }
                                                    }, title: language.restore_delivery_person, subtitle: language.restore_delivery_person_msg);
                                                  }),
                                                  SizedBox(width: 8),
                                                ],
                                              ),
                                            OutlineActionIcon(e.deletedAt == null ? Icons.delete : Icons.delete_forever, Colors.red, '${e.deletedAt == null ? language.delete : language.force_delete}', () {
                                              commonConfirmationDialog(context, DIALOG_TYPE_DELETE, () {
                                                if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                  toast(language.demo_admin_msg);
                                                } else {
                                                  Navigator.pop(context);
                                                  e.deletedAt == null ? deleteDeliveryBoyApiCall(e.id!) : restoreDeliveryBoyApiCall(id: e.id, type: FORCE_DELETE);
                                                }
                                              }, isForceDelete: e.deletedAt != null, title: language.delete_delivery_person, subtitle: language.delete_delivery_person_msg);
                                            }),
                                          ],
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          paginationWidget(
                            context,
                            currentPage: currentPage,
                            totalPage: totalPage,
                            perPage: perPage,
                            onUpdate: (currentPageVal, perPageVal) {
                              currentPage = currentPageVal;
                              perPage = perPageVal;
                              init();
                            },
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
              : deliveryBoyList.isEmpty
                  ? emptyWidget()
                  : SizedBox()
        ],
      ),
    );
  }
}
