import 'package:flutter/material.dart';
import 'package:instagram_clone/Dashboard/add_post_screen.dart';
import 'package:instagram_clone/Dashboard/fav_screen.dart';
import 'package:instagram_clone/Dashboard/feed_screen.dart';
import 'package:instagram_clone/Dashboard/profile_screen.dart';
import 'package:instagram_clone/Dashboard/search_screen.dart';

const webScreenSize = 600;

List<Widget> listOfpages = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const FavScreen(),
  const ProfileScreen(),
];
