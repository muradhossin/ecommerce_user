import 'package:ecommerce_user/providers/cart_provider.dart';
import 'package:ecommerce_user/providers/order_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  late UserProvider userProvider;
  String paymentMethodGroupValue = PaymentMethod.cod;

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of<OrderProvider>(context, listen: true);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(9),
        children: [
          buildHeader('Product Info'),
          buildProductInfoSection(),
          buildHeader('Order Summary'),
          buildOrderSummarySection(),
        ],
      ),
    );
  }

  Padding buildHeader(String header) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        header,
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget buildProductInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: cartProvider.cartList
              .map((cartModel) => ListTile(
                    title: Text(cartModel.productName),
                    trailing:
                        Text('${cartModel.quantity} x ${cartModel.salePrice}'),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget buildOrderSummarySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: const Text('Sub - total'),
              trailing:
                  Text('$currencySymbol${cartProvider.getCartSubTotal()}'),
            ),
            ListTile(
              title: Text(
                  'Discount (${orderProvider.orderConstantModel.discount}%)'),
              trailing: Text(
                  '$currencySymbol${orderProvider.getDiscountAmount(cartProvider.getCartSubTotal())}'),
            ),
            ListTile(
              title: Text('VAT (${orderProvider.orderConstantModel.vat}%)'),
              trailing: Text(
                  '$currencySymbol${orderProvider.getVatAmount(cartProvider.getCartSubTotal())}'),
            ),
            ListTile(
              title: const Text('Delivery Charge'),
              trailing: Text(
                  '$currencySymbol${orderProvider.orderConstantModel.deliveryCharge}'),
            ),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              title: const Text(
                'Grand Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '$currencySymbol${orderProvider.getGrandTotal(cartProvider.getCartSubTotal())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
