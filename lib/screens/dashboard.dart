import 'package:apple_ui/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../provider/data_provider.dart';

class HomeScreennew extends StatelessWidget {
  const HomeScreennew({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Dashboard()),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int page = 1; // Initialize the page number
  List<Map<String, dynamic>> images = [];
  int totalcoursed = 0;
  bool isLoading = false; // Add a flag to track loading state
  late ScrollController _controller;


  // *The list to hold the posts fetched from the server
  List _posts = [];
  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DataProvider>(context, listen: false).getAllTodos();
    });

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
            style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [ Container(
            margin: EdgeInsets.fromLTRB(3, 10, 3, 10),
            child: Text(
              'Showing ' + totalcoursed.toString() + ' Courses ',
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

            Expanded(child: Consumer<DataProvider>(
              builder: (context, value, child) {
                if (value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final todos = value.todos;
                totalcoursed = todos.length;

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];

                    return Container(
                        margin: EdgeInsets.fromLTRB(3, 0, 3, 10),
                        color: Colors.transparent,
                        // height: 100,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                          //  height: MediaQuery.of(context).size.height / 4.2,
                          child:
                          Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7.0),
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
                                            todo.image.toString(),
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
                                                    todo.title!,
                                                    style: GoogleFonts.roboto(color: Color(0xff000000), fontSize: 14, fontWeight: FontWeight.bold),
                                                  )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      // width: 90,
                                                      child: Text(
                                                    todo.category!,
                                                    style: GoogleFonts.roboto(color: Color(0xff666666), fontSize: 14),
                                                  )),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  RatingBar.builder(
                                                    initialRating: double.parse(todo.rating!.rate!.toString()),
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
                                                    '(${todo.rating!.rate!})',
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    todo.rating!.count!.toString(),
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    '\$' + '${todo.price}',
                                                    style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold),
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
                        ));
                  },
                );
              },
            )),
          ],
        ));
  }


}
