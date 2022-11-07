import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/OrderModel.dart';
import 'package:local_delivery_admin/models/UserModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

class DeliveryOrderAssignWidget extends StatefulWidget {
  final int OrderId;
  final OrderModel orderModel;
  final Function()? onUpdate;

  DeliveryOrderAssignWidget({this.onUpdate, required this.OrderId, required this.orderModel});

  @override
  DeliveryOrderAssignWidgetState createState() => DeliveryOrderAssignWidgetState();
}

class DeliveryOrderAssignWidgetState extends State<DeliveryOrderAssignWidget> {
  int currentPage = 1;
  int totalPage = 0;
  int perPage = 10;
  

  List<UserModel> deliveryList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getDeliveryBoyApi();
    afterBuildCreated(() => appStore.setLoading(true));
  }

  getDeliveryBoyApi() async {
    await getAllDeliveryBoyList(type: DELIVERYMAN, countryId: widget.orderModel.countryId, cityID: widget.orderModel.cityId, page: currentPage).then((value) {
      appStore.setLoading(false);

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      deliveryList.clear();
      deliveryList.addAll(value.data!);
      setState(() {});
    }).catchError((error) {
      log(error.toString());
      appStore.setLoading(false);
    });
  }

  orderAssignApi({required int orderId, required int deliveryBoyID}) async {
    appStore.setLoading(true);
    Map req = {
      "id": orderId,
      "type": ORDER_ASSIGNED,
      "delivery_man_id": deliveryBoyID,
      "status": ORDER_ASSIGNED,
    };
    await orderAssign(req).then((value) {
      appStore.setLoading(false);
      widget.onUpdate!.call();
      Navigator.pop(context);
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        height: 500,
        width: 700,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.assign_order, style: boldTextStyle(color: primaryColor, size: 20)),
                      IconButton(
                        icon: Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  deliveryList.isNotEmpty
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minWidth: 670),
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
                                  DataColumn(label: Text(language.delivery_person)),
                                  DataColumn(label: Text(language.city_name)),
                                  DataColumn(label: Text(language.assign)),
                                ],
                                rows: deliveryList.map((e) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('#${e.id}')),
                                      DataCell(Text(e.name ?? '')),
                                      DataCell(Text(e.cityName ?? '')),
                                      DataCell(
                                        OutlinedButton(
                                          child: widget.orderModel.deliveryManId == null ? Text(language.assign_order) : Text(language.order_transfer),
                                          onPressed: () async {
                                            if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                              toast(language.demo_admin_msg);
                                            } else {
                                              await orderAssignApi(orderId: widget.OrderId, deliveryBoyID: e.id!);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
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
                              getDeliveryBoyApi();
                            },
                          ),
                        ],
                      )
                      : SizedBox(),
                  SizedBox(height: 80),
                ],
              ),
            ),
            appStore.isLoading
                ? loaderWidget()
                : deliveryList.isEmpty
                    ? emptyWidget()
                    : SizedBox()
          ],
        ),
      ),
    );
  }
}
