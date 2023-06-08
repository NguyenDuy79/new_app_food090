import 'package:flutter/material.dart';
import 'package:new_ap/model/categories.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: CategoriesModel.categoriesList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: 120,
          width: 70,
          child: Column(children: <Widget>[
            CircleAvatar(
              backgroundImage:
                  NetworkImage(CategoriesModel.categoriesList[index]['image']),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              CategoriesModel.categoriesList[index]['title'],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ]),
        ),
      ),
    );
  }
}
