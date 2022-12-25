import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/auth/auth_service.dart';
import 'package:ecommerce_user/models/comment_model.dart';
import 'package:ecommerce_user/pages/login_page.dart';
import 'package:ecommerce_user/providers/cart_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:ecommerce_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productdetails';

  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late ProductProvider productProvider;
  late UserProvider userProvider;
  late Size size;
  String photoUrl = '';
  double userRating = 0.0;
  final txtController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    photoUrl = productModel.thumbnailImageModel.imageDownloadUrl;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            imageUrl: photoUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Row(children: [
            InkWell(
              onTap: () {
                setState(() {
                  photoUrl = productModel.thumbnailImageModel.imageDownloadUrl;
                });
              },
              child: Card(
                child: CachedNetworkImage(
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                  imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            ...productModel.additionalImageModels.map((url) {
              return url.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          photoUrl = url;
                        });
                      },
                      child: Card(
                        child: CachedNetworkImage(
                          width: 70,
                          height: 100,
                          fit: BoxFit.cover,
                          imageUrl: url,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
            }).toList(),
          ]),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  label: const Text('Add to Favorite'),
                ),
              ),
              Expanded(
                child:
                    Consumer<CartProvider>(builder: (context, provider, child) {
                  final isInCart =
                      provider.isProductInCart(productModel.productId!);
                  return TextButton.icon(
                    onPressed: () async{
                      EasyLoading.show(status: "Please wait");
                      if (isInCart) {
                        await provider.removeFromCart(productModel.productId!);
                        if(mounted) showMsg(context, "Removed from Cart");
                      } else {
                        await provider.addToCart(
                          productId: productModel.productId!,
                          productName: productModel.productName,
                          url: productModel.thumbnailImageModel.imageDownloadUrl,
                          salePrice: num.parse(getPriceAfterDiscount(productModel.salePrice, productModel.productDiscount)),
                        );

                        if(mounted) showMsg(context, "Added to Cart");
                      }
                      EasyLoading.dismiss();
                    },
                    icon: Icon(isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.shopping_cart),
                    label: Text(isInCart ? 'Remove from Cart' : 'Add to Cart'),
                  );
                }),
              ),
            ],
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title: Text('Sale Price: $currencySymbol${productModel.salePrice}'),
            subtitle: Text('Discount: ${productModel.productDiscount}%'),
            trailing: Text(
                '$currencySymbol${productProvider.priceAfterDiscount(productModel.salePrice, productModel.productDiscount)}'),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Rate this product'),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 0.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: false,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        userRating = rating;
                      },
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (AuthService.currentUser!.isAnonymous) {
                        showCustomDialog(
                          context: context,
                          title: 'Unregistered User',
                          positiveButtonText: 'Login',
                          content:
                              'To rate this product, you need to login with your email and password or Google account. To login with your account, go to Login Page',
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                        );
                      } else {
                        EasyLoading.show(status: 'Please wait');
                        await productProvider.addRating(
                          productModel.productId!,
                          userRating,
                          userProvider.userModel!,
                        );

                        EasyLoading.dismiss();
                        if (mounted) showMsg(context, 'Thanks for your rating');
                      }
                    },
                    child: const Text('SUBMIT'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Comments',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add your comment'),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: TextField(
                      focusNode: focusNode,
                      controller: txtController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (txtController.text.isEmpty) return;
                      if (AuthService.currentUser!.isAnonymous) {
                        showCustomDialog(
                          context: context,
                          title: 'Unregistered User',
                          positiveButtonText: 'Login',
                          content:
                              'To comment this product, you need to login with your email and password or Google account. To login with your account, go to Login Page',
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                        );
                      } else {
                        EasyLoading.show(status: 'Please wait');
                        final commentModel = CommentModel(
                          userModel: userProvider.userModel!,
                          productId: productModel.productId!,
                          comment: txtController.text,
                          date: getFormattedDate(DateTime.now(), pattern: 'dd/MM/yyyy hh:mm:ss a'),
                        );
                        await productProvider.addComment(
                          commentModel
                        );
                        final notification = NotificationModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: NotificationType.comment,
                          message: 'A new comment on ${productModel.productName} is waiting for your approval',
                          commentModel: commentModel,
                        );
                        await productProvider.addNotification(notification);
                        EasyLoading.dismiss();
                        focusNode.unfocus();
                        if (mounted)
                          showMsg(context,
                              'Thanks for your comment. Your comment is waiting for admin approval');
                      }
                    },
                    child: const Text('SUBMIT'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'All Comments',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          FutureBuilder<List<CommentModel>>(
            future:
                productProvider.getCommentsByProduct(productModel.productId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final commentList = snapshot.data!;
                if (commentList.isEmpty) {
                  return const Center(
                    child: Text('No comments found'),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: commentList
                        .map((comment) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(comment.userModel.displayName ??
                                      comment.userModel.email),
                                  subtitle: Text(comment.date),
                                  leading: comment.userModel.imageUrl == null
                                      ? const Icon(Icons.person)
                                      : CachedNetworkImage(
                                          width: 70,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          imageUrl: comment.userModel.imageUrl!,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    comment.comment,
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  );
                }
              }
              if (snapshot.hasError) {
                return const Text('Failed to load comments');
              }
              return const Center(
                child: Text('Loading comments'),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }
}
