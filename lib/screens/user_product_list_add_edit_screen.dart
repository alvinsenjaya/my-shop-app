import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/product_list_provider.dart';
import 'package:my_shop_app/screens/user_product_list_manager_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserProductAddEditScreen extends StatefulWidget {
  static const routeName = '/user-products-edit';

  final String productId;

  const UserProductAddEditScreen(this.productId);

  @override
  _UserProductAddEditScreenState createState() =>
      _UserProductAddEditScreenState();
}

class _UserProductAddEditScreenState extends State<UserProductAddEditScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  void _updateImageListener() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (!_form.currentState.validate()) return;

    ProductProvider _existingProduct;

    final ProductListProvider _productList =
        Provider.of<ProductListProvider>(context, listen: false);

    if (widget.productId != null) {
      _existingProduct = _productList.findById(widget.productId);
      if (_existingProduct != null) {
        _existingProduct.editProduct(
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          imageUrl: _imageUrlController.text,
        );
        Navigator.of(context)
            .pushReplacementNamed(UserProductListManagerScreen.routeName);

        return;
      }
    }

    _productList.addProduct(
      ProductProvider(
        id: Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
      ),
    );

    Navigator.of(context)
        .pushReplacementNamed(UserProductListManagerScreen.routeName);
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageListener);

    if (widget.productId != null) {
      final ProductProvider _product =
          Provider.of<ProductListProvider>(context, listen: false)
              .findById(widget.productId);

      _titleController.text = _product.title;
      _priceController.text = _product.price.toString();
      _descriptionController.text = _product.description;
      _imageUrlController.text = _product.imageUrl;
    }

    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageListener);
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value.isEmpty) return 'This field is required';
                  return null;
                },
                textInputAction: TextInputAction.next,
                controller: _titleController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                validator: (value) {
                  if (value.isEmpty) return 'This field is required';
                  if (double.tryParse(value) == null)
                    return 'Please provide price in number';
                  if (double.parse(value) <= 0)
                    return 'Price have to be greater than 0';
                  return null;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _priceController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value.isEmpty) return 'This field is required';
                  return null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                controller: _descriptionController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image Url',
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'This field is required';
                        if (!value.startsWith('http')) return 'Invalid url';
                        return null;
                      },
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 30, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Center(
                            child: Text(
                            'Enter Image URL',
                            textAlign: TextAlign.center,
                          ))
                        : Image.network(_imageUrlController.text,
                            fit: BoxFit.cover),
                  ),
                ],
              ),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: () {
                  _saveForm();
                },
                color: Theme.of(context).primaryColorLight,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
