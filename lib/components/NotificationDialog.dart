import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/NotificationModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/screens/NotificationViewAllScreen.dart';
import 'package:local_delivery_admin/screens/OrderDetailScreen.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

class NotificationDialog extends StatefulWidget {
  @override
  NotificationDialogState createState() => NotificationDialogState();
}

class NotificationDialogState extends State<NotificationDialog> {
  List<NotificationData> notificationData = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    appStore.setLoading(true);
    getNotification(page: 1).then((value) {
      appStore.setLoading(false);
      appStore.setAllUnreadCount(value.all_unread_count ?? 0);
      notificationData.addAll(value.notification_data!);
      setState(() {});
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
    return Observer(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(left: 16,top: 16,right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.notification, style: boldTextStyle()),
                GestureDetector(
                  child: Text(language.view_all,style: primaryTextStyle(size: 14,color: primaryColor)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationViewAllScreen()));
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
            Stack(
              children: [
                notificationData.isNotEmpty
                    ? Column(
                        children: [
                          ListView.builder(
                            itemCount: notificationData.take(5).length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              NotificationData data = notificationData[index];
                              return GestureDetector(
                                onTap: () async {
                                  await launchScreen(context, OrderDetailScreen(orderId: data.data!.id!));
                                  init();
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: data.read_at == null ? primaryColor : null),
                                        width: 10,
                                        height: 10,
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor.withOpacity(0.15),
                                        ),
                                        child: ImageIcon(AssetImage(notificationTypeIcon(type: data.data!.type)), color: primaryColor, size: 26),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(data.data!.subject ?? '-', style: boldTextStyle(size: 12)),
                                            SizedBox(height: 4),
                                            Text(data.data!.message ?? '-', style: primaryTextStyle(size: 12), maxLines: 2,overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(data.created_at ?? '-', style: secondaryTextStyle(size: 10)),
                                          SizedBox(height: 4),
                                          Text('#${data.data!.id ?? '-'}', style: secondaryTextStyle(size: 10)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : SizedBox(),
                appStore.isLoading
                    ? loaderWidget()
                    : notificationData.isEmpty
                        ? emptyWidget()
                        : SizedBox()
              ],
            ),
          ],
        ),
      );
    });
  }
}
