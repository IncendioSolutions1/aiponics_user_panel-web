import 'package:aiponics_web_app/views/common/header/header_without_farm_dropdown.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

class _SubscriptionPlanState extends State<SubscriptionPlan> {

  late Color boxColor;
  late Color borderColor;
  late Color boxHeadingColor;
  late Color rowOddColor;
  late Color rowEvenColor;

  final String cross = '\u274C';
  final String tick = '\u2713';

  Color headerColor = Colors.grey;


  String basicPriceMonthly = "0";
  String basicPriceYearly = "0";

  String standardPriceMonthly = "15";
  String standardPriceYearly = "150";

  String premiumPriceMonthly = "20";
  String premiumPriceYearly = "200";

  bool isMonthly = true;

  String selectedPlanOption = 'Basic';

  late List<Map<String, dynamic>> data;

  @override
  void initState() {
    data = [
      {
        'Details': 'History',
        'Basic': 'Prev 3 months only',
        'Standard': 'Complete till date',
        'Professional': 'Complete till date',
      },
      {
        'Details': 'Live Monitoring',
        'Basic': tick,
        'Standard': tick,
        'Professional': tick,
      },
      {
        'Details': 'Ads',
        'Basic': tick,
        'Standard': cross,
        'Professional': cross,
      },


      {
        'Details': 'No of Farms',
        'Basic': '1',
        'Standard': '3',
        'Professional': '5',
      },
      {
        'Details': 'Dosing System',
        'Basic': '1',
        'Standard': '3',
        'Professional': '3',
      },
      {
        'Details': 'Monitoring System',
        'Basic': '1',
        'Standard': '1',
        'Professional': '1',
      },
      {
        'Details': 'Conventional System',
        'Basic': '1',
        'Standard': '3',
        'Professional': '3',
      },
      {
        'Details': 'No. of Fans',
        'Basic': '4',
        'Standard': '16',
        'Professional': '16',
      },
      {
        'Details': 'No. of Pumps',
        'Basic': '2',
        'Standard': '8',
        'Professional': '8',
      },

      {
        'Details': 'Control Panel',
        'Basic': 'None',
        'Standard': '1',
        'Professional': '1',
      },

      {
        'Details': 'Recommendations',
        'Basic': cross,
        'Standard': tick,
        'Professional': tick,
      },
      {
        'Details': 'Security',
        'Basic': 'Standard',
        'Standard': 'Advanced',
        'Professional': 'Advanced',
      },
      {
        'Details': 'Automated Decisions',
        'Basic': cross,
        'Standard': tick,
        'Professional': tick,
      },
      {
        'Details': 'Control through Web',
        'Basic': cross,
        'Standard': tick,
        'Professional': tick,
      },
      {
        'Details': 'Audit Logs',
        'Basic': cross,
        'Standard': tick,
        'Professional': tick,
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Define color variables based on the current theme
    boxColor = Theme.of(context).colorScheme.onSecondary; // Color for boxes
    borderColor = Theme.of(context)
        .colorScheme.onSecondaryFixed; // Border color for accessibility buttons
    boxHeadingColor = Theme.of(context)
        .textTheme
        .labelLarge!
        .color!; // Color for box headings
    rowOddColor = boxColor;
    rowEvenColor = borderColor;

    // Get the screen size to make the layout responsive
    final screenWidth =
        MediaQuery.of(context).size.width; // Get the screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // Get the screen height

    // Calculate widths and heights for responsive design
    final fiveWidth = screenWidth * 0.003434; // Calculate width factor
    final fiveHeight = screenHeight * 0.005681; // Calculate height factor

    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (_, constraints) {
            final width = MediaQuery.of(context)
                .size
                .width; // Get the current width of the screen

            // Check for desktop layout
            if (constraints.maxWidth >= 900) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 40,
                    bottom: 40,
                    right: 50,
                    left: 50), // Padding for desktop layout
                child: desktopDashboard(context, fiveWidth,
                    fiveHeight, width), // Call desktop dashboard management method
              );
            }
            // Check for tablet layout
            else if ((constraints.maxWidth < 900 &&
                constraints.maxWidth >= 750) ||
                width >= 750) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 40,
                    bottom: 40,
                    right: 50,
                    left: 50), // Padding for tablet layout
                child: tabletDashboard(context, fiveWidth, fiveHeight,
                    constraints.maxWidth), // Call tablet dashboard management method
              );
            }
            // Mobile layout
            else {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 60,
                    bottom: 40,
                    right: 30,
                    left: 30), // Padding for mobile layout
                child: mobileDashboard(context, fiveWidth, fiveHeight,
                    constraints.maxWidth), // Call mobile dashboard management method
              );
            }
          },
        ),
      ),
    );
  }

  Widget desktopDashboard(BuildContext context, double fiveWidth, double fiveHeight, double width) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomHeaderWithoutFarmDropdown(mainPageHeading: "Welcome", subHeading: "View our Subscription's Plans"),

          Container(
            height: 243,
            width: width,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Choose The Right\nFarm Subscription For You",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 35,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15,),
                Text(
                  "Choose the plan that’s right for your business. Whether you’re just getting started with farm\nmanagement or well down the path to personalization, we’re got you covered",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 45,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Monthly Button
              SizedBox(
                width: 150,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMonthly = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isMonthly ? borderColor : Colors.grey.shade300,
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                    ),
                    child: Text(
                      "Monthly",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                        color: isMonthly ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Yearly Button
              SizedBox(
                width: 150,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMonthly = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isMonthly ? Colors.grey.shade300 : borderColor,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                    ),
                    child: Text(
                      "Yearly",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                        color: isMonthly ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 45,),

          SizedBox(
            width: 1050,
            height: ( data.length * 60 ) + 130,
            child: DataTable2(
              headingRowHeight: 130,
              dataRowHeight: 60,
              columnSpacing: 30,
              horizontalMargin: 30,
              dividerThickness: 0.0,
              columns: [
                DataColumn(
                  label: Text(
                    '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: headerColor,
                    ),
                  ),
                ),
                DataColumn(
                  label: Column(
                    children: [
                      Radio<String>(
                        value: "Basic", // Unique value for this radio button
                        groupValue: selectedPlanOption, // Current selected value
                        activeColor: borderColor,
                        toggleable: false,
                        onChanged: (String? value) {
                          setState(() {
                            selectedPlanOption = value!; // Update the selected option
                          });
                        },
                      ),
                      const SizedBox(height: 5,),
                      Text(
                          'Basic',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: boxHeadingColor,
                            ),
                          )
                      ),
                      const SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isMonthly ? "$basicPriceMonthly\$" : "$basicPriceYearly\$",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: borderColor,
                            ),
                          ),
                          Text(
                            ' per month',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: headerColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        isMonthly ? '( Paid Monthly )' : '( Paid Yearly )',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: headerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Column(
                    children: [
                      Radio<String>(
                        value: 'Standard', // Unique value for this radio button
                        groupValue: selectedPlanOption, // Current selected value
                        activeColor: borderColor,
                        toggleable: false,
                        onChanged: (String? value) {
                          setState(() {
                            selectedPlanOption = value!; // Update the selected option
                          });
                        },
                      ),
                      const SizedBox(height: 5,),
                      Text(
                          'Standard',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: boxHeadingColor,
                            ),
                          )
                      ),
                      const SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isMonthly ? "$standardPriceMonthly\$" : "$standardPriceYearly\$",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: borderColor,
                            ),
                          ),
                          Text(
                            ' per month',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: headerColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        isMonthly ? '( Paid Monthly )' : '( Paid Yearly )',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: headerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Column(
                    children: [
                      Radio<String>(
                        value: 'Premium', // Unique value for this radio button
                        groupValue: selectedPlanOption, // Current selected value
                        activeColor: borderColor,
                        toggleable: false,
                        onChanged: (String? value) {
                          setState(() {
                            selectedPlanOption = value!; // Update the selected option
                          });
                        },
                      ),
                      const SizedBox(height: 5,),
                      Text(
                          'Premium',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: boxHeadingColor,
                            ),
                          )
                      ),
                      const SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isMonthly ? "$premiumPriceMonthly\$" : "$premiumPriceYearly\$",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: borderColor,
                            ),
                          ),
                          Text(
                            ' per month',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: headerColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        isMonthly ? '( Paid Monthly )' : '( Paid Yearly )',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: headerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              rows: data.asMap().map((index, planData) {
                Color rowColor = index % 2 == 0 ?  rowEvenColor : rowOddColor ;
                return MapEntry(
                  index,
                  DataRow(
                    color: WidgetStateProperty.resolveWith((states) => rowColor),
                    cells: [
                      DataCell(
                        Text(
                          planData['Details']!,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: boxHeadingColor,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            planData['Basic']!,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: boxHeadingColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            planData['Standard']!,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: boxHeadingColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            planData['Professional']!,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: boxHeadingColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).values.toList(),
            ),
          ),

          const SizedBox(height: 20,),

          SizedBox(
            height: 45,
            width: 220,
            child:  ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: borderColor, // Customize the button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // Rounded edges
                ),
                padding: const EdgeInsets.only(
                    top: 17, right: 16, left: 16, bottom: 17), // Adjust padding for size
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Proceed To Payment',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.white, // White text
                          fontWeight: FontWeight.bold,
                          fontSize: 13
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  tabletDashboard(BuildContext context, double fiveWidth, double fiveHeight, double maxWidth) {}

  mobileDashboard(BuildContext context, double fiveWidth, double fiveHeight, double maxWidth) {}
}

