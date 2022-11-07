import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_admin/models/OrderModel.dart';

import '../main.dart';
import '../models/ExtraChargeRequestModel.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';
import 'OrderSummeryWidget.dart';

class OrderDetailComponent extends StatelessWidget {
  final OrderModel orderModel;
  final List<ExtraChargeRequestModel> extraChargeForListType;

  OrderDetailComponent({required this.orderModel, required this.extraChargeForListType});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      controller: ScrollController(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${language.order_id}', style: boldTextStyle(size: 18)),
              Text('#${orderModel.id.toString()}', style: boldTextStyle(size: 18)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.parcelDetails, style: boldTextStyle()),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      decoration: containerDecoration(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(language.parcel_type, style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis)),
                              Expanded(child: Text(orderModel.parcelType ?? '-', style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end)),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.weight, style: primaryTextStyle()),
                              Text('${orderModel.totalWeight.toString()} ${language.kg}', style: primaryTextStyle()),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(language.number_of_parcels, style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis)),
                              Expanded(child: Text('${orderModel.totalParcel ?? 1}', style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.paymentDetails, style: boldTextStyle()),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      decoration: containerDecoration(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.payment_type, style: primaryTextStyle()),
                              Text('${paymentType(orderModel.paymentType ?? PAYMENT_TYPE_CASH)}', style: primaryTextStyle()),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.payment_status, style: primaryTextStyle()),
                              Text('${paymentStatus(orderModel.paymentStatus ?? PAYMENT_PENDING)}', style: primaryTextStyle()),
                            ],
                          ),
                          if ((orderModel.paymentType ?? PAYMENT_TYPE_CASH) == PAYMENT_TYPE_CASH) SizedBox(height: 16),
                          if ((orderModel.paymentType ?? PAYMENT_TYPE_CASH) == PAYMENT_TYPE_CASH)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(language.payment_collect_form, style: primaryTextStyle()),
                                Text('${paymentCollectForm(orderModel.paymentCollectFrom!)}', style: primaryTextStyle()),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orderModel.pickupPoint!.address != null)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language.pickup_address, style: boldTextStyle()),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(16),
                        decoration: containerDecoration(),
                        child: Row(
                          children: [
                            ImageIcon(AssetImage('assets/icons/ic_pick_location.png'), size: 24, color: primaryColor),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (orderModel.pickupDatetime != null)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text('${language.picked_at} ${printDate(orderModel.pickupDatetime!)}', style: secondaryTextStyle()),
                                    ),
                                  Text('${orderModel.pickupPoint!.address}', style: primaryTextStyle()),
                                  if (orderModel.pickupPoint!.contactNumber != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.call, color: Colors.green, size: 18),
                                          SizedBox(width: 8),
                                          Text('${orderModel.pickupPoint!.contactNumber}', style: secondaryTextStyle()),
                                        ],
                                      ),
                                    ),
                                  if (orderModel.pickupDatetime == null && orderModel.pickupPoint!.endTime != null && orderModel.pickupPoint!.startTime != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          '${language.note} ${language.courierWillPickupAt} ${DateFormat('dd MMM yyyy').format(DateTime.parse(orderModel.pickupPoint!.startTime!).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(orderModel.pickupPoint!.startTime!).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(orderModel.pickupPoint!.endTime!).toLocal())}',
                                          style: secondaryTextStyle()),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: 16),
              if (orderModel.deliveryPoint!.address != null)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language.delivery_address, style: boldTextStyle()),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(16),
                        decoration: containerDecoration(),
                        child: Row(
                          children: [
                            ImageIcon(AssetImage('assets/icons/ic_delivery_location.png'), size: 24, color: primaryColor),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (orderModel.deliveryDatetime != null)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text('${language.delivered_at} ${printDate(orderModel.deliveryDatetime!)}', style: secondaryTextStyle()),
                                    ),
                                  Text('${orderModel.deliveryPoint!.address}', style: primaryTextStyle()),
                                  if (orderModel.deliveryPoint!.contactNumber != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.call, color: Colors.green, size: 18),
                                          SizedBox(width: 8),
                                          Text('${orderModel.deliveryPoint!.contactNumber}', style: secondaryTextStyle()),
                                        ],
                                      ),
                                    ),
                                  if (orderModel.deliveryDatetime == null && orderModel.deliveryPoint!.endTime != null && orderModel.deliveryPoint!.startTime != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          '${language.note} ${language.courierWillDeliveredAt} ${DateFormat('dd MMM yyyy').format(DateTime.parse(orderModel.deliveryPoint!.startTime!).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(orderModel.deliveryPoint!.startTime!).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(orderModel.deliveryPoint!.endTime!).toLocal())}',
                                          style: secondaryTextStyle()),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orderModel.pickupConfirmByClient == 1)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.picUp_signature, style: boldTextStyle()),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 8),
                          padding: EdgeInsets.all(16),
                          decoration: containerDecoration(),
                          child: orderModel.pickupTimeSignature!.isNotEmpty
                              ? commonCachedNetworkImage(
                                  orderModel.pickupTimeSignature ?? '-',
                                  fit: BoxFit.contain,
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Text(language.no_data),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(width: 16),
              orderModel.pickupConfirmByDeliveryMan == 1
                  ? Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.delivery_signature, style: boldTextStyle()),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.all(16),
                              decoration: containerDecoration(),
                              child: orderModel.deliveryTimeSignature!.isNotEmpty
                                  ? commonCachedNetworkImage(
                                      orderModel.deliveryTimeSignature!,
                                      fit: BoxFit.contain,
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                    )
                                  : Text(language.no_data),
                            ),
                          ],
                        ),
                      ),
                  )
                  : Spacer(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(16),
            decoration: containerDecoration(),
            child: (orderModel.extraCharges is List<dynamic>)
                ? OrderSummeryWidget(
                    extraChargesList: extraChargeForListType,
                    totalDistance: orderModel.totalDistance ?? 0,
                    totalWeight: orderModel.totalWeight ?? 0,
                    distanceCharge: orderModel.distanceCharge ?? 0,
                    weightCharge: orderModel.weightCharge ?? 0,
                    totalAmount: orderModel.totalAmount ?? 0,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.delivery_charges, style: primaryTextStyle()),
                          SizedBox(width: 16),
                          Text('${printAmount(orderModel.fixedCharges ?? 0)}', style: primaryTextStyle()),
                        ],
                      ),
                      if (orderModel.distanceCharge != 0)
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(language.distance_charge, style: primaryTextStyle()),
                                SizedBox(width: 16),
                                Text('${printAmount(orderModel.distanceCharge ?? 0)}', style: primaryTextStyle()),
                              ],
                            )
                          ],
                        ),
                      if (orderModel.weightCharge != 0)
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(language.weight_charge, style: primaryTextStyle()),
                                SizedBox(width: 16),
                                Text('${printAmount(orderModel.weightCharge ?? 0)}', style: primaryTextStyle()),
                              ],
                            ),
                          ],
                        ),
                      if ((orderModel.distanceCharge != 0 || orderModel.weightCharge != 0) && orderModel.extraCharges.keys.length != 0)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            children: [
                              SizedBox(height: 8),
                              Text('${printAmount((orderModel.fixedCharges ?? 0) + (orderModel.distanceCharge ?? 0) + (orderModel.weightCharge ?? 0))}', style: primaryTextStyle()),
                            ],
                          ),
                        ),
                      if (orderModel.extraCharges.keys.length != 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(language.extra_charges, style: boldTextStyle()),
                            SizedBox(height: 8),
                            Column(
                                children: List.generate(orderModel.extraCharges.keys.length, (index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(orderModel.extraCharges.keys.elementAt(index).replaceAll("_", " "), style: primaryTextStyle()),
                                    SizedBox(width: 16),
                                    Text('${printAmount(orderModel.extraCharges.values.elementAt(index))}', style: primaryTextStyle()),
                                  ],
                                ),
                              );
                            }).toList()),
                          ],
                        ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.total, style: boldTextStyle(size: 20)),
                          Text('${printAmount(orderModel.totalAmount ?? 0)}', style: boldTextStyle(size: 20, color: primaryColor)),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
