import 'package:flutter/material.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/LanguageDataModel.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/DataProvider.dart';

import '../utils/Extensions/app_common.dart';

enum WidgetType { DROPDOWN, LIST }

/// Use SELECTED_LANGUAGE_CODE Pref key to get selected language code
class LanguageListWidget extends StatefulWidget {
  final WidgetType widgetType;
  final Widget? trailing;

  /// You can set scrollPhysics to NeverScrollableScrollPhysics if you have SingleChildScroll already.
  final ScrollPhysics? scrollPhysics;
  final void Function(LanguageDataModel)? onLanguageChange;

  LanguageListWidget({
    this.widgetType = WidgetType.LIST,
    this.onLanguageChange,
    this.scrollPhysics,
    this.trailing,
  });

  @override
  LanguageListWidgetState createState() => LanguageListWidgetState();
}

class LanguageListWidgetState extends State<LanguageListWidget> {
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

  Widget build(BuildContext context) {
    Widget _buildImageWidget(String imagePath) {
      if (imagePath.startsWith('http')) {
        return Image.network(imagePath, width: 24);
      } else {
        return Image.asset(imagePath, width: 24);
      }
    }

    if (widget.widgetType == WidgetType.LIST) {
      return Container(
        child: ListView.builder(
          itemBuilder: (_, index) {
            LanguageDataModel data = languageList()[index];

            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(data.name ?? '',style: primaryTextStyle(color: Colors.green)),
              subtitle: Text(data.subTitle ?? '-'),
              leading: (data.flag != null) ? _buildImageWidget(data.flag!) : null,
              trailing: Container(
                child: widget.trailing ??
                    Container(
                      padding: EdgeInsets.all(2),
                      //decoration: boxDecorationDefault(shape: BoxShape.circle),
                      child: Icon(Icons.check, size: 15, color: Colors.black),
                    ),
              ) /*.visible(getStringAsync(SELECTED_LANGUAGE_CODE) ==
                  data.languageCode.validate())*/
              ,
              onTap: () async {
                await shared_pref.setString(SELECTED_LANGUAGE_CODE, data.languageCode!);

                selectedLanguageDataModel = data;

                setState(() {});
                widget.onLanguageChange?.call(data);
              },
            );
          },
          shrinkWrap: true,
          physics: widget.scrollPhysics,
          itemCount: languageList().length,
        ),
      );
    } else {
      return DropdownButton<LanguageDataModel>(
        underline: SizedBox(),
        value: selectedLanguageDataModel,
        dropdownColor: Theme.of(context).cardColor,
        style: primaryTextStyle(color: Colors.white),
        elevation: 4,
        onChanged: (LanguageDataModel? data) async {
          selectedLanguageDataModel = data;

          await shared_pref.setString(SELECTED_LANGUAGE_CODE, data!.languageCode ?? '-');

          setState(() {});
          widget.onLanguageChange?.call(data);
        },
        items: localeLanguageList.map((data) {
          return DropdownMenuItem<LanguageDataModel>(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (data.flag != null) _buildImageWidget(data.flag!),
                SizedBox(width: 4),
                Text(data.name ?? '-', style: primaryTextStyle()),
              ],
            ),
            value: data,
          );
        }).toList(),
      );
    }
  }
}
