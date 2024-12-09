import 'package:aiponics_web_app/routes/app_routes.dart';
import 'package:aiponics_web_app/views/landing%20page/env/assets/constants.dart';
import 'package:aiponics_web_app/views/landing%20page/env/models/card.dart';
import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seo/seo.dart';

class HomeFAQ extends StatelessWidget {
  const HomeFAQ({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cards,
  });

  final String id, title, subtitle;
  final List<CardModel> cards;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        minHeight: context.height - kToolbarHeight,
      ),
      child: DProvider(
        value: id,
        child: Builder(
          builder: (context) {
            if (!context.isDesktop) {
              // For mobile screens, the FAQ introduction and cards are laid out in a column
              return Column(
                children: [
                  // Display the FAQ introduction section
                  HomeFAQ.introduction(
                    id: id,
                    title: title,
                    subtitle: subtitle,
                  ),
                  // Display FAQ cards with wrapping layout
                  Padding(
                    padding: const EdgeInsets.all(Constants.spacing * 2.0),
                    child: Wrap(
                      spacing: Constants.spacing * 2.0,
                      runSpacing: Constants.spacing * 2.0,
                      direction: Axis.horizontal,
                      children: cards.to(HomeFAQ.card),
                    ),
                  ),
                ],
              );
            } else {
              // For desktop screens, the FAQ introduction and cards are displayed in a centered layout
              return Column(
                children: [
                  // Display the FAQ introduction section
                  Center(
                    child: HomeFAQ.introduction(
                      id: id,
                      title: title,
                      subtitle: subtitle,
                    ),
                  ),
                  // Display FAQ cards with a centered wrap layout
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Constants.spacing * 2.0),
                      child: Wrap(
                        spacing: Constants.spacing * 2.0,
                        runSpacing: Constants.spacing * 2.0,
                        direction: Axis.horizontal,
                        children: cards.to(HomeFAQ.card),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  static Widget introduction({
    required String id,
    required String title,
    required String subtitle,
  }) {
    return Builder(
      builder: (context) {
        // Animating the introduction section with slide and fade effects
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.spacing,
            vertical: Constants.spacing * 2.0,
          ),
          child: Animate(
            autoPlay: false,
            onInit: TAppRoute.controller.animate(id),
            effects: const [
              SlideEffect(
                begin: Offset(0.0, -0.25),
                end: Offset.zero,
                duration: Duration(milliseconds: 750),
              ),
              FadeEffect(
                duration: Duration(milliseconds: 750),
              ),
            ],
            child: MergeSemantics(
              child: Column(
                children: [
                  // Title text with SEO properties and styling
                  Seo.text(
                    text: title,
                    style: TextTagStyle.h2,
                    child: Text(
                      title,
                      semanticsLabel: title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: context.text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Subtitle text with SEO properties and styling
                  Seo.text(
                    text: subtitle,
                    style: TextTagStyle.p,
                    child: Text(
                      '\n$subtitle',
                      semanticsLabel: subtitle,
                      style: GoogleFonts.poppins(
                        textStyle: context.text.bodySmall?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget card(int index, CardModel item) {
    return LayoutBuilder(
      builder: (context, constraint) {
        // Calculate the width of the card
        double width = (constraint.maxWidth * 0.5 - (Constants.spacing * 2.0));

        return Animate(
          autoPlay: false,
          onInit: TAppRoute.controller.animate(DProvider.of(context)),
          effects: [
            // Apply slide and fade effects to the card with delays based on index
            SlideEffect(
              begin: const Offset(0.0, -0.25),
              end: Offset.zero,
              delay: Constants.duration * (index + 1),
              duration: const Duration(milliseconds: 750),
            ),
            FadeEffect(
              delay: Constants.duration * (index + 1),
              duration: const Duration(milliseconds: 750),
            ),
          ],
          child: Container(
            constraints: BoxConstraints(
              maxWidth: width < 240.0 ? constraint.maxWidth : width,
            ),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: context.color.surface,
              borderRadius: BorderRadius.circular(Constants.spacing * 0.25),
            ),
            child: MergeSemantics(
              child: DTileWrapper(
                    (isExpanded) => ExpansionTile(
                  initiallyExpanded: true,
                  trailing: Icon(isExpanded ? Icons.remove : Icons.add),
                  title: Seo.text(
                    text: item.title,
                    style: TextTagStyle.h4,
                    child: Text(
                      item.title,
                      semanticsLabel: item.title,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.color.onSurface,
                      ),
                    ),
                  ),
                  children: [
                    Container(
                      color: context.color.surface,
                      padding: const EdgeInsets.all(Constants.spacing),
                      child: Row(
                        children: [
                          Expanded(
                            child: Seo.text(
                              text: item.subtitle,
                              style: TextTagStyle.p,
                              child: Text(
                                item.subtitle,
                                semanticsLabel: item.subtitle,
                                textAlign: TextAlign.start,
                                style: context.text.bodySmall?.copyWith(
                                  color: context.color.outline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
