import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cat.dart';
import '../views/like_dislike_button.dart';
import '../views/swipeable_card.dart';
import 'detail_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Cat? currentCat;
  int likeCounter = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRandomCat();
  }

  Future<void> fetchRandomCat() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
      'https://api.thecatapi.com/v1/images/search?has_breeds=true&api_key=live_50UpjVLhDSEH9DmBJIILNqR6F65EKQf7jhVSOQGCvRKtUlNIIPSby0rxQeZcZ55Z',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        setState(() {
          currentCat = Cat.fromJson(jsonData[0]);
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void likeCat() {
    setState(() {
      likeCounter++;
    });
    fetchRandomCat();
  }

  void dislikeCat() {
    fetchRandomCat();
  }

  void openDetailScreen() {
    if (currentCat != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(cat: currentCat!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cat Browser')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : currentCat == null
              ? Center(child: Text('Нет данных'))
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: openDetailScreen,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SwipeableCard(
                        cat: currentCat!,
                        onLike: likeCat,
                        onDislike: dislikeCat,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LikeDislikeButton(
                        icon: Icons.thumb_down,
                        onPressed: dislikeCat,
                        color: Colors.red,
                      ),
                      LikeDislikeButton(
                        icon: Icons.thumb_up,
                        onPressed: likeCat,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Лайков: $likeCounter', style: TextStyle(fontSize: 18)),
                ],
              ),
    );
  }
}
