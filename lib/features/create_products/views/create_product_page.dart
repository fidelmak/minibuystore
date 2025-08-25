import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minibuy/features/create_products/controller/create_product_provider.dart';
import 'package:minibuy/features/create_products/model/create_product_model.dart';

class CreateProductPage extends StatefulWidget {
  final String? productId; // For editing existing products
  final CreateProductModel? existingProduct;

  const CreateProductPage({Key? key, this.productId, this.existingProduct})
    : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final CreateProductProvider _controller = Get.put(CreateProductProvider());
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _ratingCountController = TextEditingController();

  bool get isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.existingProduct != null) {
      _titleController.text = widget.existingProduct!.title;
      _priceController.text = widget.existingProduct!.price.toString();
      _descriptionController.text = widget.existingProduct!.description;
      _categoryController.text = widget.existingProduct!.category;
      _imageController.text = widget.existingProduct!.image;
      _ratingController.text = widget.existingProduct!.rating.rate.toString();
      _ratingCountController.text = widget.existingProduct!.rating.count
          .toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    _ratingController.dispose();
    _ratingCountController.dispose();
    super.dispose();
  }

  void _showMessage(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    // Check for duplicate title if creating new product
    if (!isEditing) {
      final exists = await _controller.doesProductExist(
        _titleController.text.trim(),
      );
      if (exists) {
        _showMessage('A product with this title already exists', true);
        return;
      }
    }

    final product = CreateProductModel(
      title: _titleController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      image: _imageController.text.trim(),
      rating: Rating(
        rate: double.tryParse(_ratingController.text.trim()) ?? 0.0,
        count: int.tryParse(_ratingCountController.text.trim()) ?? 0,
      ),
      additionalImages: [], // You can extend this for multiple images
    );

    bool success;
    if (isEditing) {
      success = await _controller.updateProduct(widget.productId!, product);
    } else {
      final productId = await _controller.createProduct(product);
      success = productId != null;
    }

    if (success) {
      _showMessage(_controller.successMessage, false);
      if (!isEditing) {
        _clearForm();
      }
    } else {
      _showMessage(_controller.errorMessage, true);
    }
  }

  void _clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _imageController.clear();
    _ratingController.clear();
    _ratingCountController.clear();
    _controller.clearMessages();
  }

  Future<void> _deleteProduct() async {
    if (!isEditing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _controller.deleteProduct(widget.productId!);
      if (success) {
        _showMessage(_controller.successMessage, false);
        Navigator.of(context).pop(); // Go back after deletion
      } else {
        _showMessage(_controller.errorMessage, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Create Product'),
        backgroundColor: Color(0xff007198),
        foregroundColor: Colors.white,
        actions: isEditing
            ? [IconButton(icon: Icon(Icons.delete), onPressed: _deleteProduct)]
            : null,
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Field
                    CustomTextField(
                      label: 'Product Title *',
                      hintText: 'Enter product title',
                      controller: _titleController,
                    ),
                    SizedBox(height: 16),

                    // Price Field
                    CustomTextField(
                      label: 'Price *',
                      hintText: 'Enter product price',
                      controller: _priceController,
                    ),
                    SizedBox(height: 16),

                    // Category Field
                    CustomTextField(
                      label: 'Category *',
                      hintText: 'Enter product category',
                      controller: _categoryController,
                    ),
                    SizedBox(height: 16),

                    // Image URL Field
                    CustomTextField(
                      label: 'Image URL',
                      hintText: 'Enter image URL',
                      controller: _imageController,
                    ),
                    SizedBox(height: 16),

                    // Description Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description *',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Enter product description',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff9CA3AF),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Color(0xff9CA3AF)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Color(0xff9CA3AF)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Color(0xff007198)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Rating Section
                    Text(
                      'Rating Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Rating (0-5)',
                            hintText: '0.0',
                            controller: _ratingController,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'Rating Count',
                            hintText: '0',
                            controller: _ratingCountController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        if (!isEditing) ...[
                          Expanded(
                            child: CustomButton(
                              text: 'Clear Form',
                              onPressed: _clearForm,
                              color: Colors.grey[600]!,
                              textColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                        ],
                        Expanded(
                          child: CustomButton(
                            text: isEditing
                                ? 'Update Product'
                                : 'Create Product',
                            onPressed: _saveProduct,
                            color: Color(0xff007198),
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Image Preview
                    if (_imageController.text.isNotEmpty) ...[
                      SizedBox(height: 24),
                      Text(
                        'Image Preview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff9CA3AF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _imageController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error, color: Colors.red),
                                      Text('Failed to load image'),
                                    ],
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Loading Overlay
            if (_controller.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xff007198),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            isEditing
                                ? 'Updating product...'
                                : 'Creating product...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

// Custom TextField Widget (already provided by user)
class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  CustomTextField({
    required this.label,
    required this.hintText,
    this.controller,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 8.0,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: Colors.black,
              ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                hintStyle ??
                TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: Color(0xff9CA3AF),
                ),
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor ?? Color(0xff9CA3AF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor ?? Color(0xff9CA3AF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: focusedBorderColor ?? Color(0xff007198),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Button Widget (already provided by user)
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
        padding: padding,
      ),
      child: Text(text),
    );
  }
}
