import 'package:ecommerce_user/models/user_model.dart';

const String collectionComment = 'Comment';

const String commentFieldId = 'commentId';
const String commentFieldUserModel = 'userModel';
const String commentFieldProductId = 'productId';
const String commentFieldComment = 'comment';
const String commentFieldApproved = 'approved';
const String commentFieldDate = 'date';

class CommentModel {
  String? commentId;
  UserModel userModel;
  String productId;
  String comment;
  bool approved;
  String date;

  CommentModel({
    this.commentId,
    required this.userModel,
    required this.productId,
    required this.comment,
    required this.date,
    this.approved = false,

  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      commentFieldId: commentId,
      commentFieldUserModel: userModel.toMap(),
      commentFieldProductId: productId,
      commentFieldDate : date,
      commentFieldApproved : approved,
      commentFieldComment: comment,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
        commentId: map[commentFieldId],
        userModel: UserModel.fromMap(map[commentFieldUserModel]),
        productId: map[commentFieldProductId],
        date: map[commentFieldDate],
        approved: map[commentFieldApproved],
        comment: map[commentFieldComment],
      );
}
