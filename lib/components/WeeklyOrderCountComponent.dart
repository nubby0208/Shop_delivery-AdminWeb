import 'package:flutter/material.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/DashboardModel.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeeklyOrderCountComponent extends StatefulWidget {
  static String tag = '/WeeklyOrderCountComponent';
  final List<WeeklyDataModel> weeklyOrderCount;

  WeeklyOrderCountComponent({required this.weeklyOrderCount});

  @override
  WeeklyOrderCountComponentState createState() => WeeklyOrderCountComponentState();
}

class WeeklyOrderCountComponentState extends State<WeeklyOrderCountComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 350,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        title: ChartTitle(text: language.weekly_order_count, textStyle: boldTextStyle(color: primaryColor)),
        tooltipBehavior: TooltipBehavior(enable: true),
        legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries>[
          PieSeries<WeeklyDataModel, String>(
              dataSource: widget.weeklyOrderCount,
              xValueMapper: (WeeklyDataModel data, _) => data.day,
              yValueMapper: (WeeklyDataModel data, _) => data.total,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: boldTextStyle()))
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: commonBoxShadow(),
        color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
    );
  }
}
