import 'package:flutter/material.dart';
import 'package:quotes_appdem0/quotes_pg.dart';
import 'package:quotes_appdem0/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String>Categories=["love","inspirational","life","humor"];

  List quotes=[];
  List authors=[];
  bool isDataThere = false;
  @override
  void initState() {

    super.initState();
    setState(() {
      getquotes();
    });
  }
  getquotes() async {
    String url= "https://quotes.toscrape.com/";
    Uri uri=Uri.parse(url);
    http.Response response= await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass= document.getElementsByClassName("quote");

    quotes=
        quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    authors=
        quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();

    setState(() {
      isDataThere = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
          Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              'Quotes App',
              style: textStyle(25, Colors.black, FontWeight.bold)
            ),
          ),
        ),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: Categories.map((category)  {
                return InkWell(
                  onTap: (){
                   Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>QuotesPage(category)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: Text(category.toUpperCase(),
                      style:textStyle(20, Colors.black, FontWeight.bold),)
                    ),

                  ),
                );
              }).toList(),
            ),


            SizedBox(height: 40),
            isDataThere== false? Center(child: CircularProgressIndicator(),):
            ListView.builder(
              shrinkWrap: true,
              itemCount:quotes.length,
                itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    color: Colors.white.withOpacity(0.8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(quotes[index],
                            style: textStyle(15, Colors.black, FontWeight.bold),),
                        ),
                        Center(child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(authors[index],
                          style:textStyle(18, Colors.black, FontWeight.bold)),
                        ),
                        )
                      ],
                    ),
                  ),
                );
                })
    ]
        ),
      )
    );
  }
}
