import 'package:aiponics_web_app/routes/app_routes.dart';
import 'package:aiponics_web_app/routes/route.dart';
import 'package:aiponics_web_app/views/landing%20page/env/assets/constants.dart';
import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' ;
import 'package:google_fonts/google_fonts.dart';
import 'package:seo/seo.dart';


class NavigationHeader extends AppBar {
  NavigationHeader({
    super.key,
    super.backgroundColor = Colors.transparent,
    this.selectionColor,
  });

  final Color? selectionColor;

  @override
  bool get automaticallyImplyLeading => false;

  @override
  Widget? get flexibleSpace => Hero(
        tag: '#Header',
        child: Builder(builder: (context) {
          return DChangeBuilder(
            value: TAppRoute.controller.scroll,
            builder: (context, value, child) {
              // Calculate the scroll progress
              double position() {
                if (value.hasClients) return value.offset;
                return 0.0;
              }

              double progress = position().max(kToolbarHeight) / kToolbarHeight;

              return Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: Theme.of(context).textSelectionTheme.copyWith(
                    selectionColor: selectionColor ??
                        Color.lerp(
                          context.color.onSurface,
                          context.color.surface,
                          progress,
                        )?.withOpacity(0.25),
                  ),
                ),
                child: Container(
                  color: Color.lerp(
                    context.color.primary.withOpacity(progress),
                    // context.color.onSurface,
                    Colors.white,
                    progress,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: !context.isDesktop ? 0.0 : Constants.spacing,
                    right: Constants.spacing,
                  ),
                  child: child,
                ),
              );
            },
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              if (!context.isDesktop)
                Semantics(
                  label: 'Open Menu',
                  link: true,
                  child: DButton(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    padding: const EdgeInsets.all(Constants.spacing * 0.75),
                    color: Colors.transparent,
                    child: Icon(Icons.menu, color: context.color.surface),
                  ),
                ),
              NavigationHeader.logo(),
              context.isDesktop
                  ? Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Display navigation buttons for desktop
                          for (var navigation in TAppRoute.navigations)
                            Semantics(
                              label: navigation.name,
                              link: true,
                              child: Seo.link(
                                anchor: navigation.name,
                                href: '/?section=${navigation.id}',
                                child: DButton.text(
                                  text: navigation.name,
                                  color: Colors.transparent,
                                  style: GoogleFonts.inter(
                                    textStyle: context.text.bodyMedium?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () => TAppRoute.controller.onTap(
                                    context,
                                    id: navigation.id,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : const Spacer(),
              Theme(
                data: Theme.of(context),
                child: Semantics(
                  label: 'Go to login',
                  link: true,
                  child: Seo.link(
                    anchor: 'Get Started',
                    href: '/dashboard',
                    child: DButton.text(
                      text: 'Get Started',
                      color: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      borderRadius: BorderRadius.circular(5.0),
                      style: GoogleFonts.inter(
                        textStyle: context.text.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => Get.toNamed(TRoutes.login),
                    ),
                  ),
                ),
              )
            ]),
          );
        }),
      );

  static Widget logo() {
    return Builder(builder: (context) {
      return Seo.text(
        text: '🎉  AI Ponics',
        style: TextTagStyle.h1,
        child: Text(
          // Your logo
          '🎉  AI Ponics', semanticsLabel: 'Aiponics Landing Page Logo',
          style: context.text.titleLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20.0,
          ),
        ),
      );
    });
  }
}
