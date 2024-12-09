// Replace this with the actual HomePage implementation
import 'package:aiponics_web_app/routes/app_routes.dart';
import 'package:aiponics_web_app/views/landing%20page/src/home/pages/home_page.dart';
import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';


class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(TAppRoute.controller.node);
    return DLogWidget(
      'http://localhost/',
      child: Seo.head(
        tags: const [
          MetaTag(name: 'title', content: 'Flutter Landing Page'),
          LinkTag(
            rel: 'canonical',
            href: 'https://nialixus-landing-page.web.app',
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}