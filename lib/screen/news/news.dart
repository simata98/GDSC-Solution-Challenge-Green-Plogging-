import 'package:gdsc_solution/components/customListTile.dart';
import 'package:gdsc_solution/model/article_model.dart';
import 'package:gdsc_solution/services/api_service.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  ApiService client = ApiService();

  @override
  Widget build(BuildContext context) {
    //Now let's call the APi services with futurebuilder wiget
    return Column(
        children: [
          Text("Environment News", style: TextStyle(color: Colors.black)),
          FutureBuilder(
            future: client.getArticle(),
            builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
              //let's check if we got a response or not
              if (snapshot.hasData) {
                //Now let's make a list of articles
                List<Article>? articles = snapshot.data;
                return ListView.builder(
                  //Now let's create our custom List tile
                  itemCount: articles?.length,
                  itemBuilder: (context, index) =>
                      customListTile(articles![index], context),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
    );
  }
}