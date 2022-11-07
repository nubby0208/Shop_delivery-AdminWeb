import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/models/ParcelTypeListModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import '../main.dart';
import 'AddParcelTypeDialog.dart';

class ParcelTypeWidget extends StatefulWidget {
  static String tag = '/ParcelTypeComponent';

  @override
  ParcelTypeWidgetState createState() => ParcelTypeWidgetState();
}

class ParcelTypeWidgetState extends State<ParcelTypeWidget> {
  int currentPage = 1;
  int totalPage = 1;
  int perPage = 10;
  

  List<ParcelTypeData> parcelTypeList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated((){
      appStore.setLoading(true);
      getParcelTypeListApiCall();
    });
  }

  getParcelTypeListApiCall() async {
    appStore.setLoading(true);
    await getParcelTypeList(page: currentPage,perPage:perPage).then((value) {
      appStore.setLoading(false);

      currentPage = value.pagination!.currentPage!;
      totalPage = value.pagination!.totalPages!;

      parcelTypeList.clear();
      parcelTypeList.addAll(value.data!);
      if (currentPage != 1 && parcelTypeList.isEmpty) {
        currentPage -= 1;
        getParcelTypeListApiCall();
      }
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  deleteParcelTypeApiCall(int id) async {
    appStore.setLoading(true);
    await deleteParcelType(id).then((value) {
      appStore.setLoading(false);
      getParcelTypeListApiCall();
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
                    Text(language.parcel_type, style: boldTextStyle(size: 20, color: primaryColor)),
                    addButton(language.add_parcel_types, () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) {
                          return AddParcelTypeDialog(
                            onUpdate: () {
                              getParcelTypeListApiCall();
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
                parcelTypeList.isNotEmpty
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
                                    DataColumn(label: Text(language.label)),
                                    DataColumn(label: Text(language.value)),
                                    DataColumn(label: Text(language.created)),
                                    DataColumn(label: Text(language.actions)),
                                  ],
                                  rows: parcelTypeList.map((mData) {
                                    return DataRow(cells: [
                                      DataCell(Text('${mData.id}')),
                                      DataCell(Text('${mData.label ?? "-"}')),
                                      DataCell(Text('${mData.value ?? "-"}')),
                                      DataCell(Text(printDate(mData.createdAt!))),
                                      DataCell(
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              OutlineActionIcon(Icons.edit, Colors.green, language.edit ,() {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext dialogContext) {
                                                    return AddParcelTypeDialog(
                                                        parcelTypeData: mData,
                                                        onUpdate: () {
                                                          getParcelTypeListApiCall();
                                                        });
                                                  },
                                                );
                                              }),
                                              SizedBox(width: 8),
                                              OutlineActionIcon(Icons.delete, Colors.red, language.delete ,() {
                                                commonConfirmationDialog(context, DIALOG_TYPE_DELETE, () {
                                                  if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                    toast(language.demo_admin_msg);
                                                  } else {
                                                    Navigator.pop(context);
                                                    deleteParcelTypeApiCall(mData.id!);
                                                  }
                                                }, title: language.delete_parcel_type, subtitle: language.do_you_want_to_delete_this_parcel_type);
                                              }),
                                            ],
                                          ),
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
                            onUpdate: (currentPageVal,perPageVal) {
                              currentPage = currentPageVal;
                              perPage=perPageVal;
                              getParcelTypeListApiCall();
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
              : parcelTypeList.isEmpty
                  ? emptyWidget()
                  : SizedBox(),
        ],
      );
    });
  }
}
