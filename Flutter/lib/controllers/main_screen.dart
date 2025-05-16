import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cat.dart';
import '../views/like_dislike_button.dart';
import '../views/liked_cats_screen.dart';
import '../views/swipeable_card.dart';
import 'detail_screen.dart';
import '../models/liked_cat.dart';
import '../domain/like_cubit.dart';

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

    try {
      final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=true&api_key=live_50UpjVLhDSEH9DmBJIILNqR6F65EKQf7jhVSOQGCvRKtUlNIIPSby0rxQeZcZ55Z'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newCat = Cat.fromJson(data[0]);
        setState(() {
          currentCat = newCat;
          isLoading = false;
        });
      } else {
        throw Exception('Ошибка загрузки');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Ошибка сети"),
          content: const Text("Не удалось загрузить котика. Попробуйте позже."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ок"),
            ),
          ],
        ),
      );
    }
  }


  void likeCat() {
    context.read<LikeCubit>().add(LikedCat(cat: currentCat!, likedAt: DateTime.now()));
    setState(() => likeCounter++);
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
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LikedCatsScreen()),
                );
              },
            )
          ],
          title: Text('Cat Browser')
      ),
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
                  Text('Лайков: ${context.watch<LikeCubit>().state.likedCats.length}', style: TextStyle(fontSize: 18)),
                ],
              ),
    );
  }
}
