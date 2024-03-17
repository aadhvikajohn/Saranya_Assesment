import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // *Fetching data from this Rest api
  final _baseUrl = 'https://fakestoreapi.com/products';

  // Fetching the first 20 posts
  int _page = 0;
  final int _limit = 20;

  // The controller for the ListView
  late ScrollController _controller;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators whn _firstLoad function is running
  bool _isFirstLoadRunning = true;

  // Used to display loading indicators when _loadMore function is rnning
  bool _isLoadMoreRunning = false;

  // *The list to hold the posts fetched from the server
  List _posts = [];
  List filteredItems = [];
  String _query = '';

  void search(String query) {
    setState(
          () {
        _query = query;

        filteredItems = _posts
            .where(
              (item) => item['category'].toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
            .toList();
      },
    );
  }

  // *This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res =
      await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));
      setState(() {
        _posts = json.decode(res.body);
      });
    } catch (err) {
      throw Exception('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // *This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        final res =
        await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        throw Exception('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe5e5e5),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(
              0xff000000,
            ),
          ),
        ),
        title: Text(
          'Academy',
          style: GoogleFonts.akshar(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isFirstLoadRunning
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 3, 10),
            child: Text(
                filteredItems.isEmpty?  'Showing ' + _posts.length.toString() + ' Courses ':'Showing ' + filteredItems.length.toString() + ' Courses ',
              textAlign: TextAlign.left,
              style: GoogleFonts.akshar(color: Colors.black,  fontSize: 20),
            ),
          ),
          Container(child: TextField(
            style: const TextStyle(color: Colors.black),
            onChanged: (value) {
              search(value);
            },
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.black),
             fillColor: Colors.black,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),),
          filteredItems.isNotEmpty || _query.isNotEmpty
              ? filteredItems.isEmpty
              ? const Center(
            child: Text(
              'No Results Found',
              style: TextStyle(fontSize: 18),
            ),
          )
              :  Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              itemCount: filteredItems.length,
              itemBuilder: (_, index) => Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child:
                Column(
                  children: <Widget>[
                    Container(
                      //   margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7.0),
                      child: Container(
                        //   height: 100,
                        // width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(10))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              //height: 100,
                              width: 100,
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(10))),
                              child: FadeInImage(
                                height: 100,
                                width: 100,
                                placeholder: const AssetImage("assets/images/icon1.jpg"),
                                image: NetworkImage(
                                  filteredItems[index]['image'],
                                ),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/icon1.jpg', fit: BoxFit.fitWidth);
                                },
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          // width: 90,
                                            child: Text(
                                              filteredItems[index]['title'],
                                              style: GoogleFonts.akshar(color: Color(0xff000000), fontSize: 15,),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          // width: 90,
                                            child: Text(
                                              filteredItems[index]['category'],
                                              style: GoogleFonts.akshar(color: Color(0xff666666), fontSize: 14),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        RatingBar.builder(
                                          initialRating: double.parse(  filteredItems[index]['rating']['rate'].toString()),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 15.0,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            size: 10,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '(${ filteredItems[index]['rating']['rate']})',
                                          style: GoogleFonts.akshar(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${ filteredItems[index]['rating']['count']}',
                                          style: GoogleFonts.akshar(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '\$' + '${filteredItems[index]['price']}',
                                          style: GoogleFonts.akshar(fontSize: 15, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ):
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              itemCount: _posts.length,
              itemBuilder: (_, index) => Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child:
                Column(
                  children: <Widget>[
                    Container(
                   //   margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7.0),
                      child: Container(
                        //   height: 100,
                        // width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(10))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              //height: 100,
                              width: 100,
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(10))),
                              child: FadeInImage(
                                height: 100,
                                width: 100,
                                placeholder: const AssetImage("assets/images/icon1.jpg"),
                                image: NetworkImage(
                                    _posts[index]['image'],
                                ),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/icon1.jpg', fit: BoxFit.fitWidth);
                                },
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          // width: 90,
                                            child: Text(
                                              _posts[index]['title'],
                                              style: GoogleFonts.akshar(color: Color(0xff000000), fontSize: 15,),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          // width: 90,
                                            child: Text(
                                              _posts[index]['category'],
                                              style: GoogleFonts.akshar(color: Color(0xff666666), fontSize: 14),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        RatingBar.builder(
                                          initialRating: double.parse(  _posts[index]['rating']['rate'].toString()),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 15.0,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            size: 10,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '(${ _posts[index]['rating']['rate']})',
                                          style: GoogleFonts.akshar(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${ _posts[index]['rating']['count']}',
                                          style: GoogleFonts.akshar(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '\$' + '${_posts[index]['price']}',
                                          style: GoogleFonts.akshar(fontSize: 15, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // * When the  _loadMore function is running
          if (_isLoadMoreRunning)
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 40,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          // TODO: Adicionar funcao para desaparecer a notificacao quando fazer um scroll up
          // *When nothing else to load
          if (_hasNextPage == false)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .05,
              child: Container(
                color: Colors.black87,
                child: const Center(
                  child: Text(
                    'You have fetched all the content.',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}