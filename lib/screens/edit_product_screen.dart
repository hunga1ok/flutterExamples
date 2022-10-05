import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/extensions/string_ext.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      final text = _imageUrlController.text;
      if (text.isEmpty ||
          !text.isUrl ||
          !text.endsWith('.png') &&
              !text.endsWith('.jpg') &&
              !text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid != true) return;
    _form.currentState?.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a value';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: newValue ?? '',
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isNullOrEmpty) {
                    return 'Please enter a price';
                  }

                  if (double.tryParse(value.orEmpty) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value.orEmpty) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(newValue ?? '0'),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value.isNullOrEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.orEmpty.length < 10) {
                      return 'Should be at least 10 characters long.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: newValue ?? '',
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  }),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Center(
                            child: Text(
                            'Enter a URL',
                          ))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stackTrace) {
                                return const Text('Your error widget');
                              },
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isNullOrEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.isUrl) {
                          return 'Please enter a valid URL';
                        }
                        if (!value.orEmpty.endsWith('.png') &&
                            !value.orEmpty.endsWith('.jpg') &&
                            !value.orEmpty.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: newValue ?? '');
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
