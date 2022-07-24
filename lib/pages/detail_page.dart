import 'package:flutter/material.dart';
import 'package:test_case/models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';

Future<Product> fetchSingleProduct(int _id) async {
  var response =
      await http.get(Uri.parse('https://fakestoreapi.com/products/$_id'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Product.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load product');
  }
}

class DetailPage extends StatefulWidget {
  DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    int? _id = ModalRoute.of(context)!.settings.arguments as int;

    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: FutureBuilder(
                future: fetchSingleProduct(_id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Product _product = snapshot.data as Product;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        pictSlide(_id),
                        //category and title
                        categoryAndTitleText(_product),
                        //Description product
                        description(_product),
                        //photo
                        photo(_product),
                        //price
                        priceAndButton(_product)
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Padding priceAndButton(Product _product) {
    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("\$ ",
                                    style: TextStyle(
                                        color: Colors.red[400],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Text(_product.price.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                  height: 55,
                                  width: 170,
                                  color: Colors.black,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Add to Chart",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ),
                          ],
                        ),
                      );
  }

  Column categoryAndTitleText(Product _product) {
    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_product.category,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 250,
                            child: Text(
                              _product.title,
                              maxLines: 2,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text(
                                  "Save 20%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.star_rate_rounded,
                                      color: Colors.yellow),
                                  SizedBox(width: 5),
                                  Text(_product.rating.rate.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(width: 5),
                                  Text(
                                    "(${_product.rating.count} Reviews)",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      );
  }

  SizedBox photo(Product _product) {
    return SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: ((context, index) =>
                              SizedBox(width: 12)),
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) =>
                              ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                                height: 75,
                                width: 75,
                                child: Image.network(
                                  _product.image,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      );
  }

  Padding description(Product _product) {
    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Information",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                                ),
                            const SizedBox(height: 10),
                            ReadMoreText(
                              _product.description,
                              trimLines: 3,
                              colorClickableText: Colors.grey[600],
                              trimMode: TrimMode.Line,
                              trimCollapsedText: ' Show more',
                              trimExpandedText: ' Show less',
                              moreStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              textAlign: TextAlign.justify,      
                            ),
                          ],
                        ),
                      );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Detail product",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: IconButton(
          color: Colors.grey[300],
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
      ),
      actions: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
          child: const Icon(
            Icons.favorite,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Padding pictSlide(_id) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: FutureBuilder(
          future: fetchSingleProduct(_id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Product _product = snapshot.data as Product;
              return CarouselSlider.builder(
                itemCount: 2,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = _product.image;
                  return Image.network(
                    urlImage,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  );
                },
                options: CarouselOptions(
                  height: 400,
                  enableInfiniteScroll: true,
                  viewportFraction: 1,
                  //   onPageChanged: (index, reason) =>
                  //       setState(() => activeIndex = index),
                  // ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }
}
