import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_foot_client/controller/home_controller.dart';
import 'package:new_foot_client/pages/login_page.dart';
import 'package:new_foot_client/pages/product_detail_page.dart';
import 'package:new_foot_client/widgets/multi_select_drop_down.dart';
import 'package:new_foot_client/widgets/my_drop_down_btn%20copy.dart';
import 'package:new_foot_client/widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New Foot Home'),
                IconButton(
                  onPressed: () {
                    GetStorage box = GetStorage();
                    box.erase();
                    Get.offAll(LoginPage());
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.productCategory.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          ctrl.filterByCategory(
                              ctrl.productCategory[index].name ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Chip(
                              label:
                                  Text(ctrl.productCategory[index].name ?? '')),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                      child: MultiSelectDropDown(
                    items: ['Adidas', 'Nike', 'Sports'],
                    onSelectionChanged: (selectedItems) {
                      ctrl.filterByBrand(selectedItems);
                    },
                  )),
                  Flexible(
                    child: MyDropDownBtn(
                        items: [
                          'Rs : Low to High',
                          'Rs : High to Low',
                        ],
                        label: 'Sort',
                        onSelected: (selected) {
                          print(selected);
                          ctrl.sortByPrice(
                              ascending: selected == 'Rs : Low to High'
                                  ? true
                                  : false);
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    itemCount: ctrl.productShowInUI.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.productShowInUI[index].name ?? 'No name',
                        imageUrl: ctrl.productShowInUI[index].image ?? 'No URL',
                        price: (ctrl.productShowInUI[index].price).toString(),
                        offerTag: '20 % off',
                        onTap: () {
                          Get.to(ProductDetailPage(),
                              arguments: {'data': ctrl.productShowInUI[index]});
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
