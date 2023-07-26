import 'package:flutter/material.dart';
import 'package:new_ap/config/app_storage_path.dart';
import '../config/app_dimens.dart';
import '../config/app_string.dart';

class CommonWidget {
  static Color getColors(int count, int value, BuildContext ctx) {
    if (count >= value) {
      return Theme.of(ctx).primaryColor;
    } else {
      return Colors.grey;
    }
  }

  static Widget getWidget(int status, BuildContext context, int count,
      IconData icon, String time, String url) {
    return Container(
      height: AppDimens.dimens_130,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.dimens_20,
      ),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                icon,
                color: getColors(status, count, context),
              ),
              Container(
                height: AppDimens.dimens_100,
                width: AppDimens.dimens_5,
                decoration:
                    BoxDecoration(color: getColors(status, count, context)),
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: AppDimens.dimens_10),
            child: Column(
              children: <Widget>[
                FittedBox(
                  child: Text(
                    'Tình trạng: ${AppString.statusDelivery[count - 1]}',
                    style: TextStyle(
                        fontSize: AppDimens.dimens_20,
                        fontWeight: FontWeight.bold,
                        color: status >= count ? Colors.black : Colors.grey),
                  ),
                ),
                if (status >= count)
                  Text(
                    '${time.split(':')[0]}:${time.split(':')[1]}',
                    style: const TextStyle(color: Colors.black),
                  ),
                if (count == 2 && url != '')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.dimens_10),
                    height: AppDimens.dimens_80,
                    width: AppDimens.dimens_50,
                    child: Image.network(
                      url,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Image.asset(AppStoragePath.empty);
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                const Expanded(child: SizedBox()),
                Divider(
                    height: AppDimens.dimens_0,
                    thickness: AppDimens.dimens_2,
                    color: getColors(status, count, context))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
