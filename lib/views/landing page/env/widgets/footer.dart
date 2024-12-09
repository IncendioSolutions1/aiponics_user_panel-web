

import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seo/html/seo_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../assets/constants.dart';
import 'header.dart';

class NavigationFooter extends StatelessWidget {
  const NavigationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: context.color.surface.withOpacity(0.15),
        ),
      ),
      child: Container(
        color: context.color.onSurface,
        padding: const EdgeInsets.all(Constants.spacing),
        constraints: BoxConstraints(minWidth: context.width),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceAround,
          children: [
            // Navigation Logo
            NavigationHeader.logo(),

            // Menu list
            Padding(
              padding: const EdgeInsets.all(Constants.spacing),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  // Term of Service Button
                  Semantics(
                    label: 'Unidentified Route',
                    link: true,
                    child: Seo.link(
                      anchor: 'Term of Service',
                      href: '/term_of_service.txt',
                      child: DButton.text(
                        onTap: () => context.go('/term_of_service.txt'),
                        text: 'Term of Service',
                        style: context.text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.color.primary,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),

                  // Privacy Policy Button
                  Semantics(
                    label: 'Sponsor Us',
                    link: true,
                    child: Seo.link(
                      anchor: 'Privacy Policy',
                      href: '',
                      child: DButton.text(
                        onTap: () => launchUrl(
                            Uri.parse('')),
                        text: 'Privacy Policy',
                        style: context.text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.color.primary,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),

                  // Contact Us Button
                  Semantics(
                    label: 'Author Email',
                    link: true,
                    child: Seo.link(
                      anchor: 'Contact Us',
                      href: '',
                      child: DButton.text(
                        onTap: () =>
                            launchUrl(Uri.parse('')),
                        text: 'Contact Us',
                        style: context.text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.color.primary,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),

                  // Blog Button
                  Semantics(
                    label: 'Github Repository',
                    link: true,
                    child: Seo.link(
                      anchor: 'Blog',
                      href: '',
                      child: DButton.text(
                        onTap: () => launchUrl(
                          Uri.parse(''
                              ''),
                        ),
                        text: 'Blog',
                        style: context.text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.color.primary,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Copyright text
            Semantics(
              label: 'Copyright 2024 AiPonics',
              child: Seo.link(
                anchor: '© 2024 AiPonics',
                href: ''
                    '',
                child: DButton.text(
                  mainAxisSize: MainAxisSize.min,
                  text: "© 2024 AiPonics",
                  style: context.text.bodyMedium?.copyWith(
                    color: context.color.surface.withOpacity(0.25),
                    fontWeight: FontWeight.w400,
                    fontSize: 11.0,
                  ),
                  textAlign: TextAlign.center,
                  color: Colors.transparent,
                  onTap: () => launchUrl(
                    Uri.parse(
                      ''
                      '',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
