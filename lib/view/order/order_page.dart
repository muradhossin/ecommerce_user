import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/extensions/style.dart';
import 'package:ecommerce_user/view/order/provider/order_provider.dart';
import 'package:ecommerce_user/core/constants/constants.dart';
import 'package:ecommerce_user/core/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: SingleChildScrollView(
        child: Consumer<OrderProvider>(
          builder: (context, provider, child) {
            final itemList = provider.orderItemList;
            debugPrint('----------------->ordertime: ${itemList[0].orderModel.orderDate.timestamp}');
            return ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                debugPrint('panelIndex: $panelIndex');
                debugPrint('isExpanded: $isExpanded');
                provider.toggleExpansion(panelIndex);
              },
              children: itemList.map<ExpansionPanel>((item) => ExpansionPanel(
                      isExpanded: item.isExpanded,
                      headerBuilder: (context, isExpanded) => ListTile(
                        title: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID: ${item.orderModel.orderId}'),
                            Text(getFormattedDate(
                                getDateTimeFromTimeStampString(item.orderModel.orderDate.timestamp),
                                pattern: 'dd MMM yyyy hh:mm a', ),
                              style: const TextStyle().regular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                            ),
                          ],
                        ),
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
    );
  }
}
