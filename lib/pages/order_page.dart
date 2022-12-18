import 'package:ecommerce_user/models/cart_model.dart';
import 'package:ecommerce_user/providers/order_provider.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);
  static const String routeName = '/orderpage';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Consumer<OrderProvider>(
            builder: (context, provider, child) {
              final itemList = provider.orderItemList;
              return ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    itemList[panelIndex].isExpanded = !isExpanded;
                  });
                },
                children: itemList.map<ExpansionPanel>((item) => ExpansionPanel(
                        isExpanded: item.isExpanded,
                        headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(getFormattedDate(
                              item.orderModel.orderDate.timestamp.toDate(),
                              pattern: 'dd/MM/yyyy HH:mm:ss')),
                          subtitle: Text(item.orderModel.orderStatus),
                          trailing: Text('$currencySymbol${item.orderModel.grandTotal}'),
                        ),
                        body: Column(
                          children: item.orderModel.productDetails.map((cartModel) {
                            return ListTile(
                              title: Text(cartModel.productName),
                              trailing: Text('${cartModel.quantity} x ${cartModel.salePrice}$currencySymbol'),
                            );
                          }).toList(),
                        ),
                      )).toList(),
                
              );
            },
          ),
        ),
      ),
    );
  }
}
