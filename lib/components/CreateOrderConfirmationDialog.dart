import 'package:flutter/material.dart';
import 'package:local_delivery_admin/components/OrderSummeryWidget.dart';

import '../main.dart';
import '../models/ExtraChargeRequestModel.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';

class CreateOrderConfirmationDialog extends StatefulWidget {
  final List<ExtraChargeRequestModel> extraChargesList;
  final num totalDistance;
  final num totalWeight;
  final num distanceCharge;
  final num weightCharge;
  final num totalAmount;
  final Function? onAccept;

  CreateOrderConfirmationDialog({required this.extraChargesList, required this.totalDistance, required this.totalWeight, required this.distanceCharge, required this.weightCharge, required this.totalAmount, this.onAccept});

  @override
  CreateOrderConfirmationDialogState createState() => CreateOrderConfirmationDialogState();
}

class CreateOrderConfirmationDialogState extends State<CreateOrderConfirmationDialog> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
      child: Container(
        width: 500,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.order_summury, style: boldTextStyle(size: 20)),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            OrderSummeryWidget(
                extraChargesList: widget.extraChargesList,
                totalDistance: widget.totalDistance,
                totalWeight: widget.totalWeight,
                distanceCharge: widget.distanceCharge,
                weightCharge: widget.weightCharge,
                totalAmount: widget.totalAmount),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                dialogSecondaryButton(language.cancel, () {
                  Navigator.pop(context);
                }),
                SizedBox(width: 16),
                dialogPrimaryButton(language.create, () {
                  Navigator.pop(context);
                  widget.onAccept!.call();
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
