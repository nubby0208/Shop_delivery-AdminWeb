import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/components/CityInfoDialog.dart';
import 'package:local_delivery_admin/models/CityListModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import '../main.dart';
import 'AddCityDialog.dart';

class CityWidget extends StatefulWidget {
  static String tag = '/CityComponent';

  @override
  CityWidgetState createState() => CityWidgetState();
}

class CityWidgetState extends State<CityWidget> {
  int currentPage = 1;
  int totalPage = 1;
  int perPage = 10;

  List<CityData> cityList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
      getCityListApiCall();
    });
  }

  getCityListApiCall() async {
    appStore.setLoading(true);
    await getCityList(page: currentPage, isDeleted: true, perPage: perPage).then((value) {
      appStore.setLoading(false);

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      cityList.clear();
      cityList.addAll(value.data!);
      if (currentPage != 1 && cityList.isEmpty) {
        currentPage -= 1;
        getCityListApiCall();
      }
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  deleteCityApiCall(int id) async {
    appStore.setLoading(true);
    await deleteCity(id).then((value) {
      appStore.setLoading(false);
      getCityListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  restoreCityApiCall({@required int? id, @required String? type}) async {
    Map req = {"id": id, "type": type};
    appStore.setLoading(true);
    await cityAction(req).then((value) {
      appStore.setLoading(false);
      getCityListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  updateStatusApiCall(CityData cityData) async {
    Map req = {
      "id": cityData.id,
      "status": cityData.status == 1 ? 0 : 1,
    };
    appStore.setLoading(true);
    await addCity(req).then((value) {
      appStore.setLoading(false);
      getCityListApiCall();
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
            padding: EdgeInsets.all(16),
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.city, style: boldTextStyle(size: 20, color: primaryColor)),
                    addButton(language.add_city, () {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // false = user must tap button, true = tap outside dialog
                        builder: (BuildContext dialogContext) {
                          return AddCityDialog(
                            onUpdate: () {
                              getCityListApiCall();
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
                cityList.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(height: 16),
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
                                    DataColumn(label: Text(language.city_name)),
                                    DataColumn(label: Text(language.country_name)),
                                    DataColumn(label: Text(language.created_date)),
                                    DataColumn(label: Text(language.status)),
                                    DataColumn(label: Text(language.actions)),
                                  ],
                                  rows: cityList.map((mData) {
                                    return DataRow(cells: [
                                      DataCell(Text('${mData.id}')),
                                      DataCell(Text('${mData.name ?? "-"}')),
                                      DataCell(Text('${mData.countryName ?? "-"}')),
                                      DataCell(Text(printDate(mData.createdAt ?? ""))),
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
                                                }, title: mData.status != 1 ? language.enable_city : language.disable_city, subtitle: mData.status != 1 ? language.enable_city_msg : language.disable_city_msg)
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
                                                      barrierDismissible: false, // false = user must tap button, true = tap outside dialog
                                                      builder: (BuildContext dialogContext) {
                                                        return AddCityDialog(
                                                          cityData: mData,
                                                          onUpdate: () {
                                                            getCityListApiCall();
                                                          },
                                                        );
                                                      },
                                                    )
                                                  : commonConfirmationDialog(context, DIALOG_TYPE_RESTORE, () {
                                                      if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                        toast(language.demo_admin_msg);
                                                      } else {
                                                        Navigator.pop(context);
                                                        restoreCityApiCall(id: mData.id, type: RESTORE);
                                                      }
                                                    }, title: language.restore_city, subtitle: language.do_you_want_to_restore_this_city);
                                            }),
                                            SizedBox(width: 8),
                                            OutlineActionIcon(mData.deletedAt == null ? Icons.delete : Icons.delete_forever, Colors.red, '${mData.deletedAt == null ? language.delete : language.force_delete}', () {
                                              commonConfirmationDialog(context, DIALOG_TYPE_DELETE, () {
                                                if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                  toast(language.demo_admin_msg);
                                                } else {
                                                  Navigator.pop(context);
                                                  mData.deletedAt == null ? deleteCityApiCall(mData.id!) : restoreCityApiCall(id: mData.id, type: FORCE_DELETE);
                                                }
                                              }, isForceDelete: mData.deletedAt != null, title: language.delete_city, subtitle: language.do_you_want_to_delete_this_city);
                                            }),
                                            SizedBox(width: 8),
                                            OutlineActionIcon(Icons.visibility, primaryColor, language.view, () {
                                              showDialog(context: context, builder: (context) => CityInfoDialog(cityData: mData));
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
                          paginationWidget(context, currentPage: currentPage, totalPage: totalPage, perPage: perPage, onUpdate: (currentPageVal, perPageVal) {
                            currentPage = currentPageVal;
                            perPage = perPageVal;
                            getCityListApiCall();
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
              : cityList.isEmpty
                  ? emptyWidget()
                  : SizedBox(),
        ],
      );
    });
  }
}
