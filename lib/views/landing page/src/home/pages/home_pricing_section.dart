import 'package:aiponics_web_app/routes/app_routes.dart';
import 'package:aiponics_web_app/routes/route.dart';
import 'package:aiponics_web_app/views/landing%20page/env/assets/constants.dart';
import 'package:aiponics_web_app/views/landing%20page/env/models/home_pricing_model.dart';
import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:google_fonts/google_fonts.dart';
import 'package:seo/seo.dart';

class HomePricing extends StatelessWidget {
  const HomePricing({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.plans,
  });

  // Variables to store id, title, subtitle, and plans data.
  final String id, title, subtitle;
  final List<HomePricingModel> plans;

  @override
  Widget build(BuildContext context) {
    return DProvider(
      value: id,
      child: Builder(
        builder: (context) {
          // Conditional rendering based on device type (desktop or mobile)
          if (!context.isDesktop) {
            return Column(
              children: [
                // Display the introductory label (title & subtitle)
                HomePricing.introduction(
                    id: id, title: title, subtitle: subtitle),

                // Display pricing plans as scrollable horizontal row
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minHeight: context.height * 0.75),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Constants.spacing),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: plans.to(HomePricing.card),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Rendering for desktop version (additional space and layout adjustments)
            return Column(
              children: [
                const SizedBox(height: 100,), // Space before intro text
                Center(
                    child: HomePricing.introduction(
                        id: id, title: title, subtitle: subtitle)),

                // Display pricing plans on desktop (centered with scrollable row)
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    constraints:
                    BoxConstraints(minHeight: context.height * 0.75),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(Constants.spacing),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: plans.to(HomePricing.card),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // Widget to display the introductory label (title and subtitle)
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
              // Slide-in animation effect
              SlideEffect(
                begin: Offset(0.0, -0.25),
                end: Offset.zero,
                duration: Duration(milliseconds: 750),
              ),
              // Fade-in animation effect
              FadeEffect(
                duration: Duration(milliseconds: 750),
              ),
            ],
            child: MergeSemantics(
              child: Column(
                children: [
                  // Display the title with SEO
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
                          color: Colors.black,
                          fontSize: 30,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),

                  // Display the subtitle with SEO
                  Seo.text(
                    text: subtitle,
                    style: TextTagStyle.p,
                    child: Text(
                      '\n$subtitle',
                      semanticsLabel: subtitle,
                      style: GoogleFonts.poppins(
                        textStyle: context.text.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 20,
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

  // Widget to display each pricing card
  static Widget card(int index, HomePricingModel item) {
    return Builder(
      builder: (context) {
        return Animate(
          autoPlay: false,
          onInit: TAppRoute.controller.animate(DProvider.of(context)),
          effects: [
            // Slide-in animation for cards with delay based on index
            SlideEffect(
              begin: const Offset(-0.25, 0.0),
              end: Offset.zero,
              delay: const Duration(milliseconds: 750) * index * 1.5,
              duration: const Duration(milliseconds: 750),
            ),
            // Fade-in animation for cards with delay
            FadeEffect(
              delay: const Duration(milliseconds: 750) * index * 1.5,
              duration: const Duration(milliseconds: 750),
            ),
          ],
          child: Container(
            width: 275.0,
            padding: const EdgeInsets.all(Constants.spacing),
            margin: const EdgeInsets.only(right: Constants.spacing),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.spacing),
              color: context.color.surface,
            ),
            child: MergeSemantics(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display pricing plan title
                  Seo.text(
                    text: item.title,
                    style: TextTagStyle.h2,
                    child: Text(
                      item.title,
                      semanticsLabel: item.title,
                      style: context.text.titleMedium?.copyWith(
                        color: context.color.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Display pricing amount with currency and type
                  Padding(
                    padding: const EdgeInsets.all(Constants.spacing * 2.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Seo.text(
                            text: '\$',
                            style: TextTagStyle.h4,
                            child: Text(
                              '\$',
                              semanticsLabel: 'USD',
                              style: context.text.bodyMedium?.copyWith(
                                color: context.color.onSurface,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Seo.text(
                            text: item.price.toString(),
                            style: TextTagStyle.h2,
                            child: Text(
                              "${item.price}",
                              semanticsLabel: item.price.toString(),
                              style: context.text.titleLarge?.copyWith(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w900,
                                color: context.color.onSurface,
                                height: 1.1,
                              ),
                            ),
                          ),
                          Seo.text(
                            text: item.type.name,
                            style: TextTagStyle.h4,
                            child: Text(
                              "/${item.type.name}",
                              semanticsLabel: item.type.name.toString(),
                              style: context.text.bodyMedium?.copyWith(
                                color:
                                context.color.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Display list of benefits
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: item.benefits.split("\n").to(
                              (index, item) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: Constants.spacing),
                            child: MergeSemantics(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // Display benefit checkmark
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: Constants.spacing),
                                    child: Seo.text(
                                      text: '✓',
                                      style: TextTagStyle.p,
                                      child: Text(
                                        "✓",
                                        semanticsLabel: 'Including',
                                        style: context.text.bodyMedium
                                            ?.copyWith(
                                          color: context.color.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Display benefit description
                                  Expanded(
                                    child: Seo.text(
                                      text: item,
                                      style: TextTagStyle.p,
                                      child: Text(
                                        item,
                                        semanticsLabel: item,
                                        textAlign: TextAlign.justify,
                                        style: context.text.bodySmall
                                            ?.copyWith(
                                          color: context.color.onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Display Upgrade button
                  Semantics(
                    label: 'Upgrade Your Plan',
                    link: true,
                    child: Seo.link(
                      anchor: 'Upgrade',
                      href: '/dashboard',
                      child: DButton.text(
                        onTap: () => Get.toNamed(TRoutes.login),
                        color: context.color.primary,
                        text: 'Upgrade',
                        style: context.text.bodyMedium?.copyWith(
                          color: context.color.onPrimary,
                        ),
                      ),
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
}
