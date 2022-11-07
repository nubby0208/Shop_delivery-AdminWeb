import 'package:flutter/material.dart';

import '../../main.dart';
import '../models/ExtraChargeRequestModel.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';

class OrderSummeryWidget extends StatefulWidget {
  static String tag = '/OrderSummeryWidget';

  final List<ExtraChargeRequestModel> extraChargesList;
  final num totalDistance;
  final num totalWeight;
  final num distanceCharge;
  final num weightCharge;
  final num totalAmount;

  OrderSummeryWidget({required this.extraChargesList, required this.totalDistance, required this.totalWeight, required this.distanceCharge, required this.weightCharge, required this.totalAmount});

  @override
  OrderSummeryWidgetState createState() => OrderSummeryWidgetState();
}

class OrderSummeryWidgetState extends State<OrderSummeryWidget> {
  num fixedCharges = 0;
  num minDistance = 0;
  num minWeight = 0;
  num perDistanceCharges = 0;
  num perWeightCharges = 0;
  List<ExtraChargeRequestModel> extraList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    print(widget.extraChargesList.length);
    widget.extraChargesList.forEach((element) {
      if (element.key == FIXED_CHARGES) {
        fixedCharges = element.value!;
      } else if (element.key == MIN_DISTANCE) {
        minDistance = element.value!;
      } else if (element.key == MIN_WEIGHT) {
        minWeight = element.value!;
      } else if (element.key == PER_DISTANCE_CHARGE) {
        perDistanceCharges = element.value!;
      } else if (element.key == PER_WEIGHT_CHARGE) {
        perWeightCharges = element.value!;
      } else {
        extraList.add(element);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(language.delivery_charges, style: primaryTextStyle()),
            SizedBox(width: 16),
            Text('${printAmount(fixedCharges)}', style: primaryTextStyle()),
          ],
        ),
        if(widget.distanceCharge != 0)
        Column(
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Text(language.distance_charge, style: primaryTextStyle()),
                SizedBox(width: 4),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('(${(widget.totalDistance - minDistance).toStringAsFixed(2)}', style: secondaryTextStyle()),
                      Icon(Icons.close, color: Colors.grey, size: 12),
                      Text('$perDistanceCharges)', style: secondaryTextStyle()),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Text('${printAmount(widget.distanceCharge)}', style: primaryTextStyle()),
              ],
            )
          ],
        ),
        if(widget.weightCharge != 0) Column(
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Text(language.weight_charge, style: primaryTextStyle()),
                SizedBox(width: 4),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('(${widget.totalWeight - minWeight}', style: secondaryTextStyle()),
                      Icon(Icons.close, color: Colors.grey, size: 12),
                      Text('$perWeightCharges)', style: secondaryTextStyle()),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Text('${printAmount(widget.weightCharge)}', style: primaryTextStyle()),
              ],
            ),
          ],
        ),
        if((widget.weightCharge != 0 || widget.distanceCharge != 0) && extraList.length != 0)Align(
          alignment: Alignment.bottomRight,
          child: Column(
            children: [
              SizedBox(height: 8),
              Text('${printAmount(double.parse((fixedCharges + widget.distanceCharge + widget.weightCharge).toStringAsFixed(2)))}', style: primaryTextStyle()),
            ],
          ),
        ),
        if(extraList.length != 0) Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           SizedBox(height: 16),
            Text(language.extra_charges, style: boldTextStyle()),
            SizedBox(height: 8),
            Column(
                children: List.generate(extraList.length, (index) {
                  ExtraChargeRequestModel mData = extraList.elementAt(index);
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(mData.key!.replaceAll("_", " "), style: primaryTextStyle()),
                    SizedBox(width: 4),
                    Expanded(child: Text('(${mData.valueType==CHARGE_TYPE_PERCENTAGE ? '${mData.value}%' : '${printAmount(mData.value ?? 0)}'})', style: secondaryTextStyle())),
                    SizedBox(width: 16),
                    Text('${printAmount(countExtraCharge(totalAmount: (fixedCharges + widget.weightCharge + widget.distanceCharge), chargesType: mData.valueType!, charges: mData.value!))}', style: primaryTextStyle()),
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
            Text(language.total, style: boldTextStyle()),
            SizedBox(width: 16),
            Text('${printAmount(widget.totalAmount)}', style: boldTextStyle(size: 20)),
          ],
        ),
      ],
    );
  }
}
