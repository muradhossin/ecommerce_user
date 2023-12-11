
import 'category_model.dart';
import 'image_model.dart';

const String collectionProduct = 'Products';
const String productFieldId = 'productId';
const String productFieldName = 'productName';
const String productFieldCategory = 'productCategory';
const String productFieldShortDescription = 'productShortDescription';
const String productFieldLongDescription = 'productLongDescription';
const String productFieldSalePrice = 'productSalePrice';
const String productFieldStock = 'productStock';
const String productFieldDiscount = 'productDiscount';
const String productFieldThumbnailImageUrl = 'productThumbnailImageUrl';
const String productFieldAdditionalImages = 'productAdditionalImages';
const String productFieldAvailable = 'productAvailable';
const String productFieldFeatured = 'productFeatured';
const String productFieldAvgRating = 'avgRating';

class ProductModel {
  String? productId;
  String productName;
  CategoryModel category;
  String? shortDescription;
  String? longDescription;
  num salePrice;
  num stock;
  num productDiscount;
  ImageModel thumbnailImageModel;
  List<String> additionalImageModels;
  bool available;
  bool featured;
  num avgRating;

  ProductModel({
    this.productId,
    required this.productName,
    required this.category,
    this.shortDescription,
    this.longDescription,
    required this.salePrice,
    required this.stock,
    this.avgRating = 0.0,
    required this.productDiscount,
    required this.thumbnailImageModel,
    required this.additionalImageModels,
    this.available = true,
    this.featured = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      productFieldId: productId,
      productFieldName: productName,
      productFieldCategory: category.toMap(),
      productFieldShortDescription: shortDescription,
      productFieldLongDescription: longDescription,
      productFieldSalePrice: salePrice,
      productFieldStock: stock,
      productFieldAvgRating: avgRating,
      productFieldDiscount: productDiscount,
      productFieldThumbnailImageUrl: thumbnailImageModel.toMap(),
      productFieldAdditionalImages: additionalImageModels,
      productFieldAvailable: available,
      productFieldFeatured: featured,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    productId: map[productFieldId],
    productName: map[productFieldName],
    category: CategoryModel.fromMap(map[productFieldCategory]),
    shortDescription: map[productFieldShortDescription],
    longDescription: map[productFieldLongDescription],
    salePrice: map[productFieldSalePrice],
    stock: map[productFieldStock],
    avgRating: map[productFieldAvgRating],
    productDiscount: map[productFieldDiscount],
    thumbnailImageModel: ImageModel.fromMap(map[productFieldThumbnailImageUrl]),
    additionalImageModels: (map[productFieldAdditionalImages] as List).map((e) => e as String).toList(),
    available: map[productFieldAvailable],
    featured: map[productFieldFeatured],
  );
}
