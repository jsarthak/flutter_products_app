import 'package:flutter/material.dart';
import 'price_tag.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:flutter_course/widgets/product/address_tag.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final int index;
  final Product product;
  ProductCard(this.product, this.index);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: product.id,
            child: FadeInImage(
              image: NetworkImage(product.image),
              placeholder: AssetImage('assets/food.jpg'),
              height: 300.0,
              fit: BoxFit.cover,
            ),
          ),
          Container(padding: EdgeInsets.only(top: 10.0), child: buildRow()),
          AddressTag('Sagar'),
          _buildButtonBar(context)
        ],
      ),
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
          color: Theme.of(context).accentColor,
          icon: Icon(Icons.info),
          onPressed: () {
            model.selectProduct(model.allProducts[index].id);
            Navigator.pushNamed<bool>(
                    context, '/product/' + model.allProducts[index].id)
                .then((_) {
              model.selectProduct(null);
            });
          },
        ),
        IconButton(
          color: Colors.red,
          icon: Icon(model.allProducts[index].isFavorite
              ? Icons.favorite
              : Icons.favorite_border),
          onPressed: () {
            model.selectProduct(model.allProducts[index].id);
            model.toggleProductFavoriteStatus();
          },
        )
      ]);
    });
  }

  Row buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleDefault(product.title),
        SizedBox(
          width: 10.0,
        ),
        PriceTag(product.price),
      ],
    );
  }
}
