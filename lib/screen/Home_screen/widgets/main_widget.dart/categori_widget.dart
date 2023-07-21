import 'package:flutter/material.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/config/app_storage_path.dart';

import '../../../../config/app_dimens.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.dimens_5),
        child: GestureDetector(
          onTap: () {},
          child: SizedBox(
            height: AppDimens.dimens_120,
            width: AppDimens.dimens_70,
            child: Column(children: <Widget>[
              SizedBox(
                width: AppDimens.dimens_60,
                height: AppDimens.dimens_60,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                      AppStoragePath.categories[index]['image'] as String),
                ),
              ),
              const SizedBox(
                height: AppDimens.dimens_10,
              ),
              Text(
                AppStoragePath.categories[index]['title'] as String,
                style: const TextStyle(
                    fontSize: AppDimens.dimens_18,
                    fontWeight: AppFont.semiBold),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
