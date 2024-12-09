// Replace this with the actual ErrorPage implementation
import 'package:aiponics_web_app/views/landing%20page/env/models/error.dart';
import 'package:aiponics_web_app/views/landing%20page/env/widgets/error.dart';
import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:seo/seo.dart';


class ErrorPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      MetaSEO()
        ..ogTitle(ogTitle: 'Flutter Landing Page : Page Not Found')
        ..description(description: 'An example of error page in flutter.')
        ..keywords(
            keywords: 'Flutter, Error Page, Template, 404, Page Not Found')
        ..author(author: 'Louis Wiwawan')
        ..ogDescription(ogDescription: 'An example of error page in flutter.')
        ..ogImage(
            ogImage: 'https://user-images.githubusercontent.com/45191605/'
                '283660084-c7bd8b9d-34b1-49e7-88e3-7c52a2003532.png')
        ..nameContent(name: 'twitter:site', content: '@wawan_ariwijaya');
    }
    return DLogWidget(
      'http://localhost/error',
      child: Seo.head(
        tags: const [
          MetaTag(
            name: 'title',
            content: 'Flutter Landing Page : Page Not Found',
          ),
          LinkTag(
            rel: 'canonical',
            href: 'https://nialixus-landing-page.web.app/error',
          ),
        ],
        child: ErrorPage(model: ErrorModel.error404),
      ),
    );
  }
}