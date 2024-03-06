import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_foot_client/controller/purchase_controller.dart';
import 'package:new_foot_client/model/product/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];

    return GetBuilder<PurchaseController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Product Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    product.image ?? '',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  product.name ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  product.description ?? '',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Rs ${product.price ?? ''}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.green),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: ctrl.addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: 'Enter Your Billing Address'),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: () {
                        ctrl.submitOrder(
                            item: product.name ?? '',
                            description: product.description ?? '',
                            price: product.price ?? 0);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            )),
      );
    });
  }
}
