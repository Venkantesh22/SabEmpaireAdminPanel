import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/features/popup/edit_super_category_pop.dart';
import 'package:admin_panel_ak/models/super_cate/super_cate.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuperCateImage extends StatefulWidget {
  final SuperCategoryModel superCategoryModel;

  const SuperCateImage({
    super.key,
    required this.superCategoryModel,
  });

  @override
  State<SuperCateImage> createState() => _SuperCateImageState();
}

class _SuperCateImageState extends State<SuperCateImage> {
  bool _hasImageError = false;

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    // AppProvider appProvider = Provider.of<AppProvider>(context);
    String? superCateImgUrl;

    // Check if image URL exists
    if (widget.superCategoryModel.imgUrl != null &&
        widget.superCategoryModel.imgUrl!.isNotEmpty) {
      superCateImgUrl = widget.superCategoryModel.imgUrl;
    } else {
      superCateImgUrl = null;
    }

    return Container(
      margin: EdgeInsets.all(Dimensions.dimenisonNo12),
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width / 4.5,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.all(Dimensions.dimenisonNo12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo12),
      ),
      child: Stack(
        children: [
          // Image or loading/error state
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo12),
            child: superCateImgUrl != null
                ? Image.network(
                    superCateImgUrl,
                    fit: BoxFit.fitHeight,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      // While loading, display a gray container
                      return Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Container(color: Colors.grey);
                    },
                  )
                : Container(color: Colors.grey),
          ),

          // Delete button
          Align(
            alignment: Alignment.topLeft,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert), // Three vertical dots
              onSelected: (value) {
                if (value == 'Edit') {
                  showDialog(
                    context: context,
                    builder: (context) => EditSuperCategoryPopup(
                        superCategoryModel: widget.superCategoryModel),
                  );
                } else if (value == 'Delete') {
                  showDeleteAlertDialog(context, "Delete Super-Category",
                      "Do you want to delete ${widget.superCategoryModel.superCategoryName} Super-Category",
                      () async {
                    try {
                      showLoaderDialog(context);
                      serviceProvider.deleteSingleSuperCategoryPro(
                          widget.superCategoryModel);
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context, rootNavigator: true).pop();
                      showBottonMessage(
                          "Successfully deleted ${widget.superCategoryModel.superCategoryName}",
                          context);
                    } on Exception catch (e) {
                      showBottonMessageError(
                          "Error deleting ${widget.superCategoryModel.superCategoryName}",
                          context);
                      // TODO
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'Edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'Delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),

          // Category name
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: Dimensions.dimenisonNo20),
              child: Text(
                widget.superCategoryModel.superCategoryName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.dimenisonNo18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
