import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ProductFab extends StatefulWidget {
  final Product product;
  ProductFab(this.product);
  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> with TickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  mini: true,
                  onPressed: () async {
                    final url = 'mailto:${widget.product.userEmail}';
                    if (await canLaunch(url)) {
                      launch(url);
                    } else {
                      throw ('Could not launch.');
                    }
                  },
                  heroTag: 'mail',
                  child: Icon(
                    Icons.mail,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.0, 0.5, curve: Curves.easeOut)),
                child: FloatingActionButton(
                  onPressed: () {
                    model.toggleProductFavoriteStatus();
                  },
                  heroTag: 'favorite',
                  backgroundColor: Theme.of(context).cardColor,
                  child: Icon(
                    model.selectedProduct.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  ),
                  mini: true,
                ),
              ),
            ),
            Container(
              height: 70.0,
              width: 56.0,
              child: FloatingActionButton(
                heroTag: 'options',
                onPressed: () {
                  if (_animationController.isDismissed) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
                child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        alignment: FractionalOffset.center,
                        transform: Matrix4.rotationZ(
                            _animationController.value * 0.5 * math.pi),
                        child: Icon(_animationController.isDismissed
                            ? Icons.more_vert
                            : Icons.close),
                      );
                    }),
                mini: true,
              ),
            ),
          ],
        );
      },
    );
  }
}
