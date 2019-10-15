import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:torii_shopping/src/common/blocs/BlocProvider.dart';
import 'package:torii_shopping/src/common/torii_colors.dart';
import 'package:torii_shopping/src/products/domain/entities/product.dart';
import 'package:torii_shopping/src/products/presentation/blocs/product_bloc.dart';
import 'package:torii_shopping/src/products/presentation/widgets/product_prices_list.dart';

class ProductScreen extends StatelessWidget {
  Product initialData;

  ProductScreen(this.initialData);

  @override
  Widget build(BuildContext context) {
    ProductBloc bloc = BlocProvider.of<ProductBloc>(context);
    Widget content;

    return StreamBuilder<Product>(
      initialData: initialData,
      stream: bloc.product,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          content = _content(context, snapshot.data);
        } else if (snapshot.hasError) {
          content = Text(
            "${snapshot.error}",
            overflow: TextOverflow.ellipsis,
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: content,
        );
      },
    );
  }

  Widget _content(BuildContext context, Product product) {
    Widget _content;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _content = Column(children: <Widget>[
        _header(context, product),
        _body(context, product)
      ]);
    } else {
      _content = Row(children: <Widget>[
        _header(context, product),
        _body(context, product)
      ]);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _content,
    );
  }

  Widget _header(BuildContext context, Product product) {
    return Expanded(
        child: SafeArea(
            child: Stack(
      children: <Widget>[
        Positioned.fill(
            child: Container(
          margin: EdgeInsets.all(16.0),
          child: Hero(
            tag: product.name,
            child: Carousel(
                boxFit: BoxFit.scaleDown,
                dotBgColor: Colors.transparent,
                dotIncreasedColor: Colors.lightBlueAccent,
                dotColor: Colors.blue,
                //dotVerticalPadding: -20,
                autoplay: false,
                images: product.images
                    .map((image) => NetworkImage(image))
                    .toList()),
          ),
        )),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        )
      ],
    )));
  }

  Widget _body(BuildContext context, Product product) {
    const padding = 25.0;

    return Expanded(
        child: Container(
      padding: EdgeInsets.only(
         left: padding, right: padding, bottom: padding),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -5),
            blurRadius: 5,
            color: Colors.black26,
          )
        ],
        borderRadius: _bodyBorderRadius(context),
        gradient: ToriiColors.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Text(
                product.name,
                style: TextStyle(fontSize: 21, color: Colors.white),
              ),
            ),
            Expanded(child: Center(child: ProductPricesList(product.prices))),
          ],
        ),
      ),
    ));
  }

  BorderRadius _bodyBorderRadius(BuildContext context) {
    const Radius radius = Radius.circular(55);

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return BorderRadius.only(topLeft: radius, topRight: radius);
    } else {
      return BorderRadius.only(topLeft: radius, bottomLeft: radius);
    }
  }
}