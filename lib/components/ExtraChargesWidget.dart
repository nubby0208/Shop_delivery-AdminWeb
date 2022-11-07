import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/components/AddExtraChargeDialog.dart';
import 'package:local_delivery_admin/models/ExtraChragesListModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import '../main.dart';

class ExtraChargesWidget extends StatefulWidget {
  static String tag = '/ExtraChangesComponent';

  @override
  ExtraChargesWidgetState createState() => ExtraChargesWidgetState();
}

class ExtraChargesWidgetState extends State<ExtraChargesWidget> {
  int currentPage = 1;
  int totalPage = 1;
  int perPage = 10;

  List<ExtraChargesData> extraChargeList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
      getExtraChargeListApiCall();
    });
  }

  getExtraChargeListApiCall() async {
    appStore.setLoading(true);
    await getExtraChargeList(page: currentPage, isDeleted: true, perPage: perPage).then((value) {
      appStore.setLoading(false);

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      extraChargeList.clear();
      extraChargeList.addAll(value.data!);
      if (currentPage != 1 && extraChargeList.isEmpty) {
        currentPage -= 1;
        getExtraChargeListApiCall();
      }
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  deleteExtraChargeApiCall(int id) async {
    appStore.setLoading(true);
    await deleteExtraCharge(id).then((value) {
      appStore.setLoading(false);
      getExtraChargeListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  restoreExtraChargeApiCall({@required int? id, @required String? type}) async {
    Map req = {"id": id, "type": type};
    appStore.setLoading(true);
    await extraChargeAction(req).then((value) {
      appStore.setLoading(false);
      getExtraChargeListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  updateStatusApiCall(ExtraChargesData extraChargesData) async {
    Map req = {
      "id": extraChargesData.id,
      "status": extraChargesData.status == 1 ? 0 : 1,
    };
    appStore.setLoading(true);
    await addExtraCharge(req).then((value) {
      appStore.setLoading(false);
      getExtraChargeListApiCall();
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
    return Observer(builder: (context) {
      return Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            controller: ScrollController(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.extra_charges, style: boldTextStyle(size: 20, color: primaryColor)),
                    addButton(language.add_extra_charge, () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) {
                          return AddExtraChargeDialog(
                            onUpdate: () {
                              getExtraChargeListApiCall();
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
                extraChargeList.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.circular(defaultRadius), boxShadow: commonBoxShadow()),
                            child: SingleChildScrollView(
                              controller: ScrollController(),
                              scrollDirection: Axis.horizontal,
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
                                      DataColumn(label: Text(language.title)),
                                      DataColumn(label: Text(language.country_name)),
                                      DataColumn(label: Text(language.city_name)),
                                      DataColumn(label: Text(language.charge)),
                                      DataColumn(label: Text(language.created)),
                                      DataColumn(label: Text(language.status)),
                                      DataColumn(label: Text(language.actions)),
                                    ],
                                    rows: extraChargeList.map((mData) {
                                      return DataRow(cells: [
                                        DataCell(Text('${mData.id}')),
                                        DataCell(Text('${mData.title ?? "-"}')),
                                        DataCell(Text('${mData.countryName ?? "-"}')),
                                        DataCell(Text('${mData.cityName ?? "-"}')),
                                        DataCell(Text('${mData.charges} ${mData.chargesType == CHARGE_TYPE_PERCENTAGE ? '%' : ''}')),
                                        DataCell(Text(printDate(mData.createdAt!))),
                                        DataCell(TextButton(
                                          child: Text(
                                            '${mData.status == 1 ? language.enable : language.disable}',
                                            style: primaryTextStyle(color: mData.status == 1 ? primaryColor : Colors.red),
                                          ),
                                          onPressed: () {
                                            mData.deletedAt == null
                                                ? commonConfirmationDialog(context, mData.status == 1 ? DIALOG_TYPE_DISABLE : DIALOG_TYPE_ENABLE, () {
                                                    if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                      toast(language.demo_admin_msg);
                                                    } else {
                                                      Navigator.pop(context);
                                                      updateStatusApiCall(mData);
                                                    }
                                                  },
                                                    title: mData.status != 1 ? language.enable_extra_charge : language.disable_extra_charge,
                                                    subtitle: mData.status != 1 ? language.enable_extra_charge_msg : language.disable_extra_charge_msg)
                                                : toast(language.you_cannot_update_status_record_deleted);
                                          },
                                        )),
                                        DataCell(
                                          Row(
                                            children: [
                                              OutlineActionIcon(mData.deletedAt == null ? Icons.edit : Icons.restore, Colors.green, '${mData.deletedAt == null ? language.edit : language.restore}', () {
                                                mData.deletedAt == null
                                                    ? showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext dialogContext) {
                                                          return AddExtraChargeDialog(
                                                            extraChargesData: mData,
                                                            onUpdate: () {
                                                              getExtraChargeListApiCall();
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : commonConfirmationDialog(context, DIALOG_TYPE_RESTORE, () {
                                                        if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                          toast(language.demo_admin_msg);
                                                        } else {
                                                          Navigator.pop(context);
                                                          restoreExtraChargeApiCall(id: mData.id, type: RESTORE);
                                                        }
                                                      }, title: language.restore_extraCharges, subtitle: language.do_you_want_to_restore_this_extra_charges);
                                              }),
                                              SizedBox(width: 8),
                                              OutlineActionIcon(mData.deletedAt == null ? Icons.delete : Icons.delete_forever, Colors.red, '${mData.deletedAt == null ? language.delete : language.force_delete}', () {
                                                commonConfirmationDialog(context, DIALOG_TYPE_DELETE, () {
                                                  if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                    toast(language.demo_admin_msg);
                                                  } else {
                                                    Navigator.pop(context);
                                                    mData.deletedAt == null ? deleteExtraChargeApiCall(mData.id!) : restoreExtraChargeApiCall(id: mData.id, type: FORCE_DELETE);
                                                  }
                                                }, isForceDelete: mData.deletedAt != null, title: language.delete_extra_charges, subtitle: language.do_you_want_to_delete_this_extra_charges);
                                              }),
                                            ],
                                          ),
                                        ),
                                      ]);
                                    }).toList()),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          paginationWidget(context, currentPage: currentPage, totalPage: totalPage, perPage: perPage, onUpdate: (currentPageVal, perPageVal) {
                            currentPage = currentPageVal;
                            perPage = perPageVal;
                            getExtraChargeListApiCall();
                            setState(() {});
                          }),
                          SizedBox(height: 80),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
          appStore.isLoading
              ? loaderWidget()
              : extraChargeList.isEmpty
                  ? emptyWidget()
                  : SizedBox(),
        ],
      );
    });
  }
}
