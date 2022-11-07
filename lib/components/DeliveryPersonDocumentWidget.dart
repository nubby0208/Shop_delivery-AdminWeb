import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../models/DeliveryDocumentListModel.dart';
import '../network/NetworkUtils.dart';
import '../network/RestApis.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';

class DeliveryPersonDocumentWidget extends StatefulWidget {
  static String tag = '/DeliveryPersonDocumentWidget';

  final int? deliveryManId;

  DeliveryPersonDocumentWidget({this.deliveryManId});

  @override
  DeliveryPersonDocumentWidgetState createState() => DeliveryPersonDocumentWidgetState();
}

class DeliveryPersonDocumentWidgetState extends State<DeliveryPersonDocumentWidget> {
  int currentPage = 1;
  int totalPage = 1;
  int perPage = 10;
  

  List<DeliveryDocumentData> deliveryDocList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
      getDocumentListApiCall();
    });
  }

  /// Verify Documents
  verifyDocument(int docId) async {
    MultipartRequest multiPartRequest = await getMultiPartRequest('delivery-man-document-save');
    multiPartRequest.fields["id"] = docId.toString();
    multiPartRequest.fields["is_verified"] = '1';
    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        getDocumentListApiCall();
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  /// Delivery Document List
  getDocumentListApiCall() async {
    appStore.setLoading(true);
    await getDeliveryDocumentList(page: currentPage, isDeleted: true, deliveryManId: widget.deliveryManId, perPage: perPage).then((value) {
      appStore.setLoading(false);

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      deliveryDocList.clear();
      deliveryDocList.addAll(value.data!);
      if (currentPage != 1 && deliveryDocList.isEmpty) {
        currentPage -= 1;
        getDocumentListApiCall();
      }
      setState(() {});
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
                Text(language.delivery_person_documents, style: boldTextStyle(size: 20, color: primaryColor)),
                deliveryDocList.isNotEmpty
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
                                    dataRowHeight: 100,
                                    headingRowHeight: 45,
                                    horizontalMargin: 16,
                                    headingRowColor: MaterialStateColor.resolveWith((states) => primaryColor.withOpacity(0.1)),
                                    showCheckboxColumn: false,
                                    dataTextStyle: primaryTextStyle(size: 14),
                                    headingTextStyle: boldTextStyle(),
                                    columns: [
                                      DataColumn(label: Text(language.id)),
                                      DataColumn(label: Text(language.delivery_person_name)),
                                      DataColumn(label: Text(language.document_name)),
                                      DataColumn(label: Text(language.document)),
                                      DataColumn(label: Text(language.created)),
                                      DataColumn(label: Text(language.actions)),
                                    ],
                                    rows: deliveryDocList.map((mData) {
                                      return DataRow(cells: [
                                        DataCell(Text('${mData.id}')),
                                        DataCell(Text('${mData.deliveryManName ?? "-"}')),
                                        DataCell(Text('${mData.documentName ?? "-"}')),
                                        DataCell(TextButton(
                                          child: mData.deliveryManDocument!.contains('.pdf')
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(defaultRadius)),
                                                  child: Text(mData.deliveryManDocument!.split('/').last, style: primaryTextStyle()),
                                                )
                                              : commonCachedNetworkImage(mData.deliveryManDocument ?? "", height: 80, width: 80),
                                          onPressed: () {
                                            launchUrl(Uri.parse(mData.deliveryManDocument ?? ""));
                                          },
                                        )),
                                        DataCell(Text(printDate(mData.createdAt!))),
                                        DataCell(mData.isVerified == 1
                                            ? Text(language.verified, style: primaryTextStyle(color: Colors.green))
                                            : SizedBox(
                                                height: 25,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    commonConfirmationDialog(context, DIALOG_TYPE_ENABLE, () {
                                                      if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                        toast(language.demo_admin_msg);
                                                      } else {
                                                        Navigator.pop(context);
                                                        verifyDocument(mData.id!);
                                                      }
                                                    }, title: language.verify_document, subtitle: language.do_you_want_to_verify_document);
                                                  },
                                                  child: Text(language.verify),
                                                ),
                                              )),
                                      ]);
                                    }).toList()),
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
                                getDocumentListApiCall();
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
              : deliveryDocList.isEmpty
                  ? emptyWidget()
                  : SizedBox(),
        ],
      );
    });
  }
}
