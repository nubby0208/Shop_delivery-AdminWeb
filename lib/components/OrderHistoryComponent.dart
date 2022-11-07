import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../models/OrderHistoryModel.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';

class OrderHistoryComponent extends StatelessWidget {
  final List<OrderHistoryModel> orderHistory;

  OrderHistoryComponent({required this.orderHistory});

  messageData(OrderHistoryModel orderModel) {
    if (orderModel.history_type == ORDER_ASSIGNED) {
      return 'Your Order#${orderModel.order_id} has been assigned to ${orderModel.history_data!.deliveryManName}.';
    } else if (orderModel.history_type == ORDER_TRANSFER) {
      return 'Your Order#${orderModel.order_id} has been transfered to ${orderModel.history_data!.deliveryManName}.';
    } else {
      return '${orderModel.history_message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orderHistory.length,
      itemBuilder: (context, index) {
        OrderHistoryModel mData = orderHistory[index];
        return TimelineTile(
          alignment: TimelineAlign.start,
          isFirst: index == 0 ? true : false,
          isLast: index == (orderHistory.length - 1) ? true : false,
          indicatorStyle: IndicatorStyle(width: 15, color: primaryColor),
          afterLineStyle: LineStyle(color: primaryColor, thickness: 3),
          beforeLineStyle: LineStyle(color: primaryColor, thickness: 3),
          endChild: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                ImageIcon(AssetImage(statusTypeIcon(type: mData.history_type)), color: primaryColor, size: 30),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${mData.history_type!.replaceAll("_", " ")}', style: boldTextStyle()),
                      SizedBox(height: 8),
                      Text(messageData(mData),style: primaryTextStyle()),
                      SizedBox(height: 8),
                      Text('${printDate('${mData.created_at}')}', style: secondaryTextStyle()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}