import 'package:flutter/material.dart';
// import 'package:hocado/core/utils/csv_reader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/core/constants/images.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/views/home/home_header.dart';
import 'package:hocado/presentation/views/home/home_search_bar.dart';
import 'package:hocado/presentation/widgets/deck_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final selectedNavIndex = ref.watch(bottomNavProvider);

    // Dữ liệu giả cho danh sách card
    final ongoingDecks = List.generate(
      4,
      (index) => {
        'title': 'Tiêu đề ${index + 1}',
        'description': 'Mô tả về bộ card, nó như thế nào...',
      },
    );

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
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      Images.bannerHomepage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.xl),

                // Section 4: Ongoing Decks Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ongoing decks', style: theme.textTheme.headlineSmall),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(70),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.md),

                // Section 5: Decks Grid
                GridView.builder(
                  itemCount: ongoingDecks.length,
                  physics:
                      const NeverScrollableScrollPhysics(), // Để scroll view cha xử lý
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        0.9, // Tỉ lệ chiều rộng/chiều cao của card
                  ),
                  itemBuilder: (context, index) {
                    final deck = ongoingDecks[index];
                    return DeckCard(
                      did: '1',
                      title: deck['title']!,
                      description: deck['description']!,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
