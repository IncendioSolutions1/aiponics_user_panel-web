import 'package:aiponics_web_app/routes/app_routes.dart';
import 'package:aiponics_web_app/views/landing%20page/env/assets/constants.dart';
import 'package:aiponics_web_app/views/landing%20page/env/models/card.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seo/seo.dart';

// A StatelessWidget that displays a section of features on the home page.
class HomeFeatures extends StatelessWidget {
  // Constructor accepting parameters for id, title, subtitle, and list of cards to display.
  const HomeFeatures({
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
    // Check if the current context is for a desktop platform.
    if (context.isDesktop) {
      // Desktop layout: Uses Column to arrange the widgets vertically.
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 10), // Adds spacing between widgets

          // Displays the introduction with title and subtitle.
          HomeFeatures.introduction(id: id, title: title, subtitle: subtitle),

          // A container to display a list of feature cards with some padding.
          Container(
            padding: const EdgeInsets.all(Constants.spacing).copyWith(top: 0.0),
            alignment: Alignment.center,
            child: Wrap(
              direction: Axis.horizontal, // Wraps the cards horizontally
              spacing: Constants.spacing, // Spacing between cards
              runSpacing: Constants.spacing, // Spacing between rows of cards
              crossAxisAlignment: WrapCrossAlignment.start, // Align cards to the top
              children: cards.to((index, item) => Animate(
                autoPlay: false, // Disable autoplay for animations
                onInit: TAppRoute.controller.animate(id), // Trigger animation when initialized
                effects: [
                  // Slide effect to animate the card from top to center
                  SlideEffect(
                    begin: const Offset(0.0, -0.25),
                    end: Offset.zero,
                    delay: Constants.duration * (index + 1), // Delay based on index
                    duration: const Duration(milliseconds: 500), // Duration of animation
                  ),
                  // Fade effect to animate opacity of the card
                  FadeEffect(
                    delay: Constants.duration * (index + 1),
                    duration: const Duration(milliseconds: 500),
                  ),
                ],
                child: HomeFeatures.card(item: item), // Call to display individual card widget
              )),
            ),
          ),
        ],
      );
    } else {
      // Mobile layout: Uses a container with gradient background and swiper.
      return Container(
        alignment: Alignment.center,
        width: context.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.color.primary, // Gradient color from primary color
              context.color.primary.withOpacity(0.0), // Transparent fade effect
            ],
          ),
        ),
        height: context.height - kToolbarHeight, // Full height minus toolbar height
        constraints: BoxConstraints(minHeight: context.width < 560.0 ? 650.0 : 455.0),
        padding: const EdgeInsets.all(Constants.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display introduction with title and subtitle for mobile.
            HomeFeatures.introduction(id: id, title: title, subtitle: subtitle),

            // Display swiper for card items
            Expanded(
              child: Animate(
                autoPlay: false,
                onInit: TAppRoute.controller.animate(id),
                effects: const [
                  ScaleEffect(
                    begin: Offset(0.75, 0.75),
                    end: Offset(1.0, 1.0),
                    delay: Constants.duration,
                    duration: Duration(milliseconds: 500),
                  ),
                  FadeEffect(
                    delay: Constants.duration,
                    duration: Duration(milliseconds: 500),
                  ),
                ],
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) => SingleChildScrollView(
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(), // Bounce effect for scroll
                    child: Column(
                      children: [HomeFeatures.card(item: cards[index])],
                    ),
                  ),
                  itemCount: cards.length, // Number of items in the swiper
                  autoplay: true, // Enable autoplay for swiper
                  scrollDirection: context.width >= 560.0 ? Axis.horizontal : Axis.vertical, // Horizontal or vertical based on screen width
                  autoplayDelay: 10 * 1000, // Autoplay delay (10 seconds)
                  layout: SwiperLayout.STACK, // Stack layout for the swiper items
                  itemWidth: 300.0, // Width of each swiper item
                  itemHeight: context.height.max(250.0), // Height of swiper items
                  control: SwiperControl(
                    iconNext: Icons.navigate_next_rounded, // Next icon
                    iconPrevious: Icons.navigate_before_rounded, // Previous icon
                    color: context.color.surface, // Control icon color
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Static method for displaying the introduction with title and subtitle.
  static Widget introduction({
    required String id,
    required String title,
    required String subtitle,
  }) {
    return Builder(
      builder: (context) {
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
                duration: Duration(milliseconds: 500),
              ),
              FadeEffect(
                duration: Duration(milliseconds: 500),
              ),
            ],
            child: MergeSemantics(
              child: Column(
                children: [
                  // Display the main title with SEO support for better search indexing.
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
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),

                  // Display the subtitle with SEO support.
                  Seo.text(
                    text: subtitle,
                    style: TextTagStyle.p,
                    child: Text(
                      '\n$subtitle',
                      semanticsLabel: subtitle,
                      style: GoogleFonts.poppins(
                          textStyle: context.text.bodySmall?.copyWith(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          )
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

  // Static method for displaying an individual feature card.
  static Widget card({required CardModel item}) {
    return Builder(
      builder: (context) {
        return Container(
          width: 300.0,
          height: 250.0,
          padding: const EdgeInsets.all(Constants.spacing),
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(Constants.spacing * 0.5),
            boxShadow: [
              BoxShadow(
                color: context.color.onSurface.withOpacity(0.1),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: MergeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the card's image with semantic labeling for accessibility.
                Semantics(
                  image: true,
                  label: '${item.title} Icon',
                  child: Seo.image(
                    alt: '${item.title} Icon',
                    src: 'assets/${item.source}',
                    child: DImage(
                      source: item.source,
                      size: const Size.square(Constants.spacing * 1.5),
                      color: context.color.primary,
                    ),
                  ),
                ),

                // Add spacing between image and title.
                Padding(
                  padding: const EdgeInsets.only(
                    top: Constants.spacing * 0.5,
                    bottom: Constants.spacing,
                  ),
                  child: Seo.text(
                    text: item.title,
                    style: TextTagStyle.h4,
                    child: Text(
                      item.title,
                      semanticsLabel: item.title,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.color.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Display the subtitle text for the card.
                Seo.text(
                  text: item.subtitle,
                  style: TextTagStyle.p,
                  child: Text(
                    item.subtitle,
                    semanticsLabel: item.subtitle,
                    textAlign: TextAlign.justify,
                    style: context.text.bodySmall
                        ?.copyWith(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
