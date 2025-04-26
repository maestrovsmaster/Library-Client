import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'widgets/banner_widget.dart';
import 'widgets/genre_section_widget.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Прозорий фон
      statusBarIconBrightness: Brightness.light, // Білі іконки
      statusBarBrightness: Brightness.dark, // для iOS
    ));

    return Scaffold(
      extendBodyBehindAppBar: true, // <-- Set this
      appBar: AppBar(
        backgroundColor: Colors.transparent, // <-- this
        shadowColor: Colors.transparent, // <-- and this
      ),

      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          BannerWidget(
            imagePath: 'assets/images/img_family.png',
            title: 'Сімейні книги',
            subtitle: 'Натисніть, щоб переглянути',
            onTap: () {
              // Навігація
              context.push('/genre/family');
            },
          ),
          GenreSectionWidget(genreTitle: 'Дитячі', genreId: 'Казки'),
          GenreSectionWidget(genreTitle: 'Пригоди', genreId: 'Пригодницький роман'),
          GenreSectionWidget(genreTitle: 'Класика', genreId: 'Класика'),
          GenreSectionWidget(genreTitle: 'Вірші', genreId: 'Вірші'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                context.push('/genres');
              },
              child: Text('Переглянути всі жанри'),
            ),
          ),
        ],
      ),
    );
  }
}
