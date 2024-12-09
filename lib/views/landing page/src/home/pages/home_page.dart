import 'package:aiponics_web_app/routes/app_routes.dart';
import 'package:aiponics_web_app/views/landing%20page/env/assets/constants.dart';
import 'package:aiponics_web_app/views/landing%20page/env/models/card.dart';
import 'package:aiponics_web_app/views/landing%20page/env/models/navigation.dart';
import 'package:aiponics_web_app/views/landing%20page/env/widgets/drawer.dart';
import 'package:aiponics_web_app/views/landing%20page/env/models/home_pricing_model.dart';
import 'package:aiponics_web_app/views/landing%20page/src/home/pages/home_faq_section.dart';
import 'package:aiponics_web_app/views/landing%20page/src/home/pages/home_features_section.dart';
import 'package:aiponics_web_app/views/landing%20page/src/home/pages/home_pricing_section.dart';
import 'package:aiponics_web_app/views/landing%20page/src/home/pages/home_starter_section.dart';
import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:scroll_to_id/scroll_to_id.dart';
import 'package:seo/seo.dart';

import '../../../env/widgets/background.dart';
import '../../../env/widgets/footer.dart';
import '../../../env/widgets/header.dart';

// HomePage widget: This is the main page of the landing page and houses all the sections like starter, features, pricing, FAQ, etc.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // The SelectionArea allows for text selection in the entire widget tree inside this area.
    return SelectionArea(
      child: Background.parallax(
        // RawKeyboardListener enables keyboard input handling (focus handling and onKey event callback)
        child: RawKeyboardListener(
          autofocus: true,
          focusNode: TAppRoute.controller.node, // Ensures that the focus node is controlled through the TAppRoute controller
          onKey: TAppRoute.controller.onKey, // Binds the onKey event handler for keyboard events
          child: Scaffold(
            backgroundColor: Colors.transparent, // Transparent background for the entire page
            appBar: NavigationHeader(), // Custom navigation header widget
            drawer: NavigationDrawer.of(context), // Custom navigation drawer
            body: InteractiveScrollViewer(
              scrollToId: TAppRoute.controller.instance, // Handles the scroll behavior for smooth scrolling to specific sections
              scrollDirection: Axis.vertical, // Defines vertical scrolling for the body
              children: [
                ...TAppRoute.navigations.to(HomePage.scrollContent), // Dynamically renders sections of the home page (like Starter, Features, etc.)
                ScrollContent(
                  id: 'footer',
                  child: const NavigationFooter(), // Footer section at the bottom of the page
                )
              ],
            ),
            // Floating action button for navigating back to the top of the page
            floatingActionButton: HomePage.floatingButton(),
          ),
        ),
      ),
    );
  }

  // Creates a floating action button that scrolls the page back to the top
  static Widget floatingButton() {
    return ValueListenableBuilder(
      valueListenable: TAppRoute.controller, // Listens for changes in the navigation controller's state
      builder: (_, value, child) {
        // TweenAnimationBuilder is used to animate the button's translation when navigating
        return TweenAnimationBuilder(
          tween: Tween(end: value == TAppRoute.navigations.last.id ? 0.0 : 1.0), // Animates the button's visibility based on the navigation state
          duration: Constants.duration, // Duration of the animation
          builder: (_, value, child) {
            return Transform.translate(
              offset: Offset(0.0, value * kToolbarHeight * 2.0), // Adjusts the button's position based on animation
              child: child,
            );
          },
          child: child,
        );
      },
      child: Builder(
        builder: (context) {
          return Row(
            mainAxisSize: MainAxisSize.max, // Makes the row take full width of the screen
            children: [
              const Spacer(),
              FloatingActionButton(
                shape: const CircleBorder(), // Creates a circular floating action button
                onPressed: () => TAppRoute.controller.onTap(
                  context,
                  id: TAppRoute.navigations.first.id, // Navigates to the first section of the page (top)
                ),
                child: Seo.link(
                  anchor: 'Go back to top', // SEO-friendly link anchor for search engines
                  href: '/?section=${TAppRoute.navigations.first.id}', // Link to the top of the page with section identifier
                  child: const Icon(
                    Icons.arrow_upward_rounded, // Arrow icon to indicate upward navigation
                    semanticLabel: 'Go back to top', // Accessibility label for screen readers
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // scrollContent method dynamically generates content for each section (Starter, Features, Pricing, FAQ)
  static ScrollContent scrollContent(
      int index,
      NavigationModel item,
      ) {
    return ScrollContent(
      id: item.id,
      child: [
        // HomeStarter Section: Introduction - First section of the page, introducing the features of the service
        HomeStarter(
          id: item.id,
          title: "Explore Key Features or Benefits",
          subtitle:
          "We've Solved Problem with Your Solution - Making Your Life Easier. Get Ready for Our Upcoming Launch - Something Amazing Awaits. Stay Informed.",
        ),

        // HomeFeatures Section: Key Features - Displays the main features of the product or service
        HomeFeatures(
          id: item.id,
          title: 'Key Features',
          subtitle:
          'Explore Why Our Product is the Ideal Solution for Your Needs',
          cards: const [
            // CardModel items representing different features of the product
            CardModel(
              source: 'assets/image/icon_inactive_faq.svg',
              title: "Automated Irrigation Systems",
              subtitle:
              'Efficiently manage water usage with smart irrigation systems that ensure your crops receive the right amount of water, reducing waste and increasing yield. 💧',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_features.svg',
              title: 'Smart Crop Monitoring',
              subtitle:
              'Leverage advanced sensors and analytics to monitor soil health, moisture levels, and plant growth, ensuring optimal conditions for crop success. 🌾',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_pricing.svg',
              title: 'Sustainable Farming Practices',
              subtitle:
              'Adopt eco-friendly farming techniques that promote soil health, reduce chemical usage, and conserve water, ensuring long-term farm sustainability. 🌍',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_faq.svg',
              title: 'Automated Harvesting Solutions',
              subtitle:
              'Enhance your harvesting efficiency with automated machinery, minimizing labor costs and maximizing crop output at the perfect harvest time. 🚜',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_features.svg',
              title: 'Real-time Farm Data Insights',
              subtitle:
              'Access real-time data about your farm’s performance, including soil conditions, crop health, and environmental factors, to make informed decisions. 📊',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_pricing.svg',
              title: 'Renewable Energy Integration',
              subtitle:
              'Power your farm sustainably by incorporating solar and wind energy systems to reduce carbon footprint and energy costs. ☀️',
            ),
          ],
        ),

        // HomePricing Section: Pricing Plans - Displays the various pricing plans and benefits for each
        HomePricing(
          id: item.id,
          title: 'Choose the Perfect Plan',
          subtitle:
          'Explore the benefits and features of each plan to make the right choice for your business.',
          plans: const [
            HomePricingModel(
              title: 'Basic Plan',
              price: 0,
              type: HomePricingType.forever, // Indicates the plan is free for life
              benefits:
              "History: Prev 3 months only\nLive Monitoring: ✔\nAds: ✔\nNo of Farms: 1\nDosing System: 1\nMonitoring System: 1\nConventional System: 1\nNo. of Fans: 4\nNo. of Pumps: 2\nControl Panel: None\nRecommendations: ✘\nSecurity: Standard\nAutomated Decisions: ✘\nControl through Web: ✘\nAudit Logs: ✘",
            ),
            HomePricingModel(
              title: 'Pro Plan',
              price: 15,
              type: HomePricingType.month, // Subscription plan on a monthly basis
              benefits:
              "History: Complete till date\nLive Monitoring: ✔\nAds: ✘\nNo of Farms: 3\nDosing System: 3\nMonitoring System: 1\nConventional System: 3\nNo. of Fans: 16\nNo. of Pumps: 8\nControl Panel: 1\nRecommendations: ✔\nSecurity: Advanced\nAutomated Decisions: ✔\nControl through Web: ✔\nAudit Logs: ✔",
            ),
            HomePricingModel(
              title: 'Premium Plan',
              price: 120,
              type: HomePricingType.year, // Yearly subscription plan
              benefits:
              "History: Complete till date\nLive Monitoring: ✔\nAds: ✘\nNo of Farms: 5\nDosing System: 3\nMonitoring System: 1\nConventional System: 3\nNo. of Fans: 20\nNo. of Pumps: 10\nControl Panel: 1\nRecommendations: ✔\nSecurity: Premium\nAutomated Decisions: ✔\nControl through Web: ✔\nAudit Logs: ✔",
            ),
          ],
        ),

        // HomeFaq Section: Frequently Asked Questions - Helps customers understand more about the product/service
        // HomeFAQ Section: Frequently Asked Questions
        HomeFAQ(
          id: item.id,
          title: 'Frequently Asked Questions',
          subtitle: 'Answers to Common Inquiries About Our Farm Automation Services',
          cards: const [
            // CardModel items representing frequently asked questions
            CardModel(
              source: 'assets/image/icon_inactive_faq.svg',
              title: "🌱 What is Farm Automation?",
              subtitle:
              'Farm automation involves using technology and machines to manage and monitor farming operations like irrigation, fertilization, and harvesting, improving efficiency and reducing human labor.',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_features.svg',
              title: '🚜 How Do We Monitor Farm Conditions?',
              subtitle:
              'Our system provides real-time monitoring of temperature, humidity, soil conditions, and more, to ensure optimal growth conditions for your crops.',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_pricing.svg',
              title: '💰 What Are the Pricing Plans?',
              subtitle:
              'We offer various pricing plans tailored to your needs. Whether you’re just starting with one farm or managing multiple large-scale operations, we’ve got the right plan for you.',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_faq.svg',
              title: '💡 What Kind of Technology Do You Use?',
              subtitle:
              'We utilize advanced hardware and software systems, including dosing systems, monitoring sensors, automated control panels, and data analytics to optimize farm management.',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_features.svg',
              title: '📊 Can I Access Farm Data Remotely?',
              subtitle:
              'Yes, our system allows you to access your farm’s data and control settings through a web interface, so you can monitor and manage your farm from anywhere.',
            ),
            CardModel(
              source: 'assets/image/icon_inactive_pricing.svg',
              title: '🔐 How Secure is the System?',
              subtitle:
              'We provide robust security features, including encryption, secure login, and data protection to ensure your farm’s data is always safe and private.',
            ),
          ],
        ),
      ][index],
    );
  }
}





