
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/core/components/custom_button.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/view/auth/services/auth_service.dart';
import 'package:ecommerce_user/view/checkout/models/contact_info_model.dart';
import 'package:ecommerce_user/view/notification/provider/notification_provider.dart';
import 'package:ecommerce_user/view/order/models/date_model.dart';
import 'package:ecommerce_user/view/notification/models/notification_model.dart';
import 'package:ecommerce_user/view/order/models/order_model.dart';
import 'package:ecommerce_user/view/cart/provider/cart_provider.dart';
import 'package:ecommerce_user/view/order/provider/order_provider.dart';
import 'package:ecommerce_user/core/constants/constants.dart';
import 'package:ecommerce_user/core/utils/helper_functions.dart';
import 'package:ecommerce_user/view/user/models/address_model.dart';
import 'package:ecommerce_user/view/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';

class CheckoutPage extends StatefulWidget {

  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  late UserProvider userProvider;
  late NotificationProvider notificationProvider;
  final addressLine1Controller = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String paymentMethodGroupValue = PaymentMethod.cod;

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of<OrderProvider>(context, listen: true);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    setAddressIfExists();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(9),
        children: [
          buildHeader('Product Info'),
          buildProductInfoSection(),
          buildHeader('Order Summary'),
          buildOrderSummarySection(),
          buildHeader('Delivery Address'),
          buildDeliveryAddressSection(),
          buildHeader('Contact Info'),
          buildContactInfoSection(),
          buildHeader('Payment Method'),
          buildPaymentMethodSection(),

          const SizedBox(height: Dimensions.paddingSmall),
          buildOrderButtonSection(),
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

  Widget buildDeliveryAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [

            TextField(
              controller: addressLine1Controller,
              decoration: const InputDecoration(
                hintText: 'Enter Address',
                labelText: 'Address',
              ),
            ),

            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                hintText: 'Enter City',
                labelText: 'City'
              ),
            ),

            TextField(
              controller: zipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter Zip Code',
                labelText: 'Zip Code'
              ),
            ),
            const SizedBox(height: Dimensions.paddingSmall),

          ],
        ),
      ),
    );
  }

  Widget buildContactInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Name',
                labelText: 'Name',
              ),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                  hintText: 'Enter Phone Number',
                  labelText: 'Phone Number'
              ),
            ),
            const SizedBox(height: Dimensions.paddingSmall),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressLine1Controller.dispose();
    cityController.dispose();
    zipController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Widget buildPaymentMethodSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Radio<String>(
              value: PaymentMethod.cod,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              },
            ),
            const Text(PaymentMethod.cod),
            // Radio<String>(
            //   value: PaymentMethod.online,
            //   groupValue: paymentMethodGroupValue,
            //   onChanged: (value) {
            //     setState(() {
            //       paymentMethodGroupValue = value!;
            //     });
            //   },
            // ),
            // const Text(PaymentMethod.online),
          ],
        ),
      ),
    );
  }

  Widget buildOrderButtonSection() {
    return CustomButton(
      text: 'Place Order',
      onPressed: _saveOrder,
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
    );
  }

  Future<void> _saveOrder() async {
    debugPrint('-----------------------> addressLine1Controller ${addressLine1Controller.text}');
    if (addressLine1Controller.text.isEmpty) {
      showMsg(context, "Please provide delivery address", isError: true);
      return;
    }
    if (cityController.text.isEmpty) {
      showMsg(context, "Please delivery city");
      return;
    }
    if (phoneController.text.isEmpty) {
      showMsg(context, "Please provide phone number");
      return;
    }
    if (nameController.text.isEmpty) {
      showMsg(context, "Please provide name");
      return;
    }
    EasyLoading.show(status: 'Please Wait');
    final orderModel = OrderModel(
      orderId: generateOrderId,
      userId: AuthService.currentUser!.uid,
      orderStatus: OrderStatus.pending,
      paymentMethod: paymentMethodGroupValue,
      grandTotal: orderProvider.getGrandTotal(cartProvider.getCartSubTotal()),
      discount: orderProvider.orderConstantModel.discount,
      vat: orderProvider.orderConstantModel.vat,
      deliveryCharge: orderProvider.orderConstantModel.deliveryCharge,
      orderDate: DateModel(
        timestamp: Timestamp.fromDate(DateTime.now()).toString(),
        day: DateTime.now().day,
        month: DateTime.now().month,
        year: DateTime.now().year,
      ),
      deliveryAddress: AddressModel(
          address: addressLine1Controller.text.trim(),
          zipcode: zipController.text.trim(),
          city: cityController.text.trim(),
      ),
      contactInfo: ContactInfoModel(
        name: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      ),
      productDetails: cartProvider.cartList,
    );

    try {
      await orderProvider.saveOrder(orderModel);

      final notification = NotificationModel(
        createdAt: DateTime.now(),
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: NotificationType.order,
        title: 'New Order',
        message: 'You have a new order #${orderModel.orderId}',
        orderModel: orderModel,
        typedata: OrderStatus.pending,
      );
      await notificationProvider.addNotification(notification);
      EasyLoading.dismiss();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.getOrderSuccessRoute(),
            ModalRoute.withName(AppRouter.getViewProductRoute()));
      }
      notificationProvider.sendNotification(notification);
      notificationProvider.sendTopicNotification(notification, NotificationTopic.order);



    } catch (error) {
      debugPrint('-----------------------> order place error ${error.toString()}');
      EasyLoading.dismiss();
      if(mounted) showMsg(context, "Failed to save order");
    }
  }

  void setAddressIfExists() {
    final userModel = userProvider.userModel;
    if (userModel != null) {
      if (userModel.addressModel != null) {
        final address = userModel.addressModel!;
        addressLine1Controller.text = address.address ?? '';
        cityController.text = address.city ?? '';
        zipController.text = address.zipcode ?? '';
        phoneController.text = userModel.phone ?? '';
        nameController.text = userModel.displayName ?? '';
      }
    }
  }
}

