import 'package:flutter/material.dart';
// import 'package:hocado/core/utils/csv_reader.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/views/home/home_banner.dart';
import 'package:hocado/presentation/views/home/home_header.dart';
import 'package:hocado/presentation/views/home/home_search_bar.dart';
import 'package:hocado/presentation/views/home/on_going_decks.dart';
import 'package:hocado/presentation/views/home/suggested_deck_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Header
                const HomeHeader(),
                const SizedBox(height: Sizes.lg),

                // Section 2: Search Bar
                const HomeSearchBar(),
                const SizedBox(height: Sizes.lg),

                // Section 3: Banner
                const HomeBanner(),
                const SizedBox(height: Sizes.xl),

                // Section 4: Ongoing Decks
                const OnGoingDecks(),
                const SizedBox(height: Sizes.lg),

                // Section 5: Suggested Decks
                const SuggestedDeckList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
