import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/CountryListModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

import 'AddCountryDialog.dart';

class CountryWidget extends StatefulWidget {
  static String tag = '/CountryComponent';

  @override
  CountryWidgetState createState() => CountryWidgetState();
}

class CountryWidgetState extends State<CountryWidget> {
  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int totalPage = 1;
  int perPage = 10;

  List<CountryData> countryList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
      getCountryListApiCall();
    });
  }

  getCountryListApiCall() async {
    appStore.setLoading(true);
    await getCountryList(page: currentPage, isDeleted: true,perPage:perPage).then((value) {
      appStore.setLoading(false);

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      countryList.clear();
      countryList.addAll(value.data!);
      if (currentPage != 1 && countryList.isEmpty) {
        currentPage -= 1;
        getCountryListApiCall();
      }
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  deleteCountryApiCall(int id) async {
    appStore.setLoading(true);
    await deleteCountry(id).then((value) {
      appStore.setLoading(false);
      getCountryListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  restoreCountryApiCall({@required int? id, @required String? type}) async {
    Map req = {"id": id, "type": type};
    appStore.setLoading(true);
    await countryAction(req).then((value) {
      appStore.setLoading(false);
      getCountryListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  updateStatusApiCall(CountryData countryData) async {
    Map req = {
      "id": countryData.id,
      "status": countryData.status == 1 ? 0 : 1,
    };
    appStore.setLoading(true);
    await addCountry(req).then((value) {
      appStore.setLoading(false);
      getCountryListApiCall();
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
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.country, style: boldTextStyle(size: 20, color: primaryColor)),
                    addButton(language.add_country, () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) {
                          return AddCountryDialog(onUpdate: () {
                            getCountryListApiCall();
                          });
                        },
                      );
                    }),
                  ],
                ),
                countryList.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    DataColumn(label: Text(language.country_name)),
                                    DataColumn(label: Text(language.distance_type)),
                                    DataColumn(label: Text(language.weight_type)),
                                    DataColumn(label: Text(language.created_date)),
                                    DataColumn(label: Text(language.status)),
                                    DataColumn(label: Text(language.actions)),
                                  ],
                                  rows: countryList.map((CountryData mData) {
                                    return DataRow(cells: [
                                      DataCell(Text('${mData.id}')),
                                      DataCell(Text('${mData.name ?? "-"}')),
                                      DataCell(Text('${mData.distanceType ?? "-"}')),
                                      DataCell(Text('${mData.weightType ?? "-"}')),
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
                                                }, title: mData.status != 1 ? language.enable_country : language.disable_country, subtitle: mData.status != 1 ? language.enable_country_msg : language.disable_country_msg)
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
                                                      // false = user must tap button, true = tap outside dialog
                                                      builder: (BuildContext dialogContext) {
                                                        return AddCountryDialog(
                                                          countryData: mData,
                                                          onUpdate: () {
                                                            getCountryListApiCall();
                                                          },
                                                        );
                                                      },
                                                    )
                                                  : commonConfirmationDialog(context, DIALOG_TYPE_RESTORE, () {
                                                      if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                        toast(language.demo_admin_msg);
                                                      } else {
                                                        Navigator.pop(context);
                                                        restoreCountryApiCall(id: mData.id, type: RESTORE);
                                                      }
                                                    }, title: language.restore_country, subtitle: language.do_you_want_to_restore_this_country);
                                            }),
                                            SizedBox(width: 8),
                                            OutlineActionIcon(mData.deletedAt == null ? Icons.delete : Icons.delete_forever, Colors.red, '${mData.deletedAt == null ? language.delete : language.force_delete}', () {
                                              commonConfirmationDialog(context, DIALOG_TYPE_DELETE, () {
                                                if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                  toast(language.demo_admin_msg);
                                                } else {
                                                  Navigator.pop(context);
                                                  mData.deletedAt == null ? deleteCountryApiCall(mData.id!) : restoreCountryApiCall(id: mData.id, type: FORCE_DELETE);
                                                }
                                              }, isForceDelete: mData.deletedAt != null, title: language.delete_country, subtitle: language.do_you_want_to_delete_this_country);
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
                              onUpdate: (currentPageVal,perPageVal) {
                                currentPage = currentPageVal;
                                perPage = perPageVal;
                                getCountryListApiCall();
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
              : countryList.isEmpty
                  ? emptyWidget()
                  : SizedBox(),
        ],
      );
    });
  }
}
