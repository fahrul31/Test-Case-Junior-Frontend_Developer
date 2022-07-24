import 'package:flutter/material.dart';
import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:test_case/models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List<Product>> fetchProduct() async {
  var response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (json.decode(response.body) as List)
        .map((e) => Product.fromJson(e))
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load product');
  }
}

Future<List<String>> fetchCategories() async {
  var response =
      await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (json.decode(response.body) as List)
        .map((e) => e.toString())
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load categories');
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _kategori = "electronics";
  int panjang = 4;
  late TabController _tabController;
  late Future<List<Product>> futureProduct;
  late Future<List<String>> futureCategory;
  @override
  void initState() {
    futureProduct = fetchProduct();
    futureCategory = fetchCategories();
    _tabController = TabController(length: panjang, vsync: this);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            children: [
              //widget for search box and icon notification
              searchBoxAndNotif(context),
              //widget for banner
              banner(context),
              //widget for tab bar
              tabBar(),
              //widget for tabbar view
              tabBarView(itemWidth, itemHeight, size),
            ],
          ),
        )),
      ),
    );
  }

  CustomLineIndicatorBottomNavbar bottomNavBar() {
    return CustomLineIndicatorBottomNavbar(
      selectedColor: Colors.black,
      unSelectedColor: Colors.black54,
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      unselectedIconSize: 30,
      selectedIconSize: 30,
      onTap: _onItemTapped,
      enableLineIndicator: true,
      lineIndicatorWidth: 2,
      indicatorType: IndicatorType.Top,
      customBottomBarItems: [
        CustomBottomBarItems(
          label: '',
          icon: Icons.home,
        ),
        CustomBottomBarItems(
          label: '',
          icon: Icons.favorite_border_rounded,
        ),
        CustomBottomBarItems(label: '', icon: Icons.shopping_cart_outlined),
        CustomBottomBarItems(
          label: '',
          icon: Icons.account_circle,
        ),
      ],
    );
  }

  Container banner(BuildContext context) {
    return Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              height: 175,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://dummyimage.com/1920x1080/000/fff",
                    fit: BoxFit.cover,
                  )),
            );
  }

  Row searchBoxAndNotif(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 110,
                  decoration: BoxDecoration(
                      color: const Color(0xfff3f3f4),
                      borderRadius: BorderRadius.circular(12)),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search clothes...",
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.black54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xfff3f3f4),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black54,
                  ),
                )
              ],
            );
  }

  SizedBox tabBar() {
    return SizedBox(
              height: 50,
              child: FutureBuilder(
                  future: futureCategory,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> _category = snapshot.data as List<String>;
                      return TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        unselectedLabelColor: Colors.black54,
                        labelColor: Colors.white,
                        indicatorColor: Colors.blueGrey,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black),
                        onTap: (index) {
                          _kategori = _category[index];
                          print(_kategori);
                        },
                        tabs: List.generate(
                          _category.length,
                          (index) => Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(toBeginningOfSentenceCase(
                                    _category[index]) as String),
                              ),
                            ),
                          ),
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

  Container tabBarView(double itemWidth, double itemHeight, Size size) {
    return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 800,
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  panjang,
                  (index) => FutureBuilder(
                      future: futureProduct,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Product> _product =
                              snapshot.data as List<Product>;
                          _product = _product
                              .where((a) => a.category == _kategori)
                              .toList();
                          return GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (itemWidth / itemHeight),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: List<Widget>.generate(_product.length,
                                (index) {
                              return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/detail_page",
                            arguments: _product[index].id);
                      },
                      child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Column(
                                  children: [
                                    //picture
                                    Card(
                                      elevation: 6,
                                      child: SizedBox(
                                        height: 275,
                                        width: size.width,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            _product[index].image,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),

                                    //name and price product
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  _product[index]
                                                              .title
                                                              .length >
                                                          12
                                                      ? "${_product[index].title.substring(0, 12)}..."
                                                      : _product[index].title,
                                                  maxLines: 1,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              const SizedBox(height: 5),
                                              Text(
                                                  '\$${_product[index].price}',
                                                  style: TextStyle(color: Colors.red[400], fontSize: 14, fontWeight: FontWeight.w700)),
                                            ],
                                          ),
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color:
                                                    const Color(0xfff3f3f4)),
                                            child: const Icon(
                                              Icons.favorite_border_rounded,
                                              color: Colors.black54,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                            }),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          );
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
            );
  }
}
