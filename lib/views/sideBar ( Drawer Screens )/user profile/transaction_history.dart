import 'package:aiponics_web_app/routes/route.dart';
import 'package:aiponics_web_app/views/common/header/header_without_farm_dropdown.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/user%20profile/subscription_plan.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {

  late Color boxColor;
  late Color borderColor;
  late Color boxHeadingColor;
  late Color oddRowColor;
  late Color oddEvenColor;

  List<Map<String, dynamic>> _filteredItems = [];

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> data = [
    {
      'Invoice': 'INV001',
      'Billing Date': '2023-10-01',
      'Status': 'Paid',
      'Amount': 100.0,
      'Plan': 'Basic',
    },
    {
      'Invoice': 'INV002',
      'Billing Date': '2023-10-05',
      'Status': 'Pending',
      'Amount': 200.0,
      'Plan': 'Standard',
    },
    {
      'Invoice': 'INV003',
      'Billing Date': '2023-10-10',
      'Status': 'Overdue',
      'Amount': 300.0,
      'Plan': 'Premium',
    },
    {
      'Invoice': 'INV004',
      'Billing Date': '2023-10-15',
      'Status': 'Paid',
      'Amount': 150.0,
      'Plan': 'Basic',
    },
    {
      'Invoice': 'INV005',
      'Billing Date': '2023-10-20',
      'Status': 'Pending',
      'Amount': 250.0,
      'Plan': 'Standard',
    },
    {
      'Invoice': 'INV006',
      'Billing Date': '2023-10-25',
      'Status': 'Overdue',
      'Amount': 275.0,
      'Plan': 'Premium',
    },
    {
      'Invoice': 'INV007',
      'Billing Date': '2023-10-30',
      'Status': 'Paid',
      'Amount': 180.0,
      'Plan': 'Basic',
    },
    {
      'Invoice': 'INV008',
      'Billing Date': '2023-11-01',
      'Status': 'Paid',
      'Amount': 190.0,
      'Plan': 'Standard',
    },
    {
      'Invoice': 'INV009',
      'Billing Date': '2023-11-05',
      'Status': 'Overdue',
      'Amount': 320.0,
      'Plan': 'Premium',
    },
    {
      'Invoice': 'INV010',
      'Billing Date': '2023-11-10',
      'Status': 'Pending',
      'Amount': 220.0,
      'Plan': 'Basic',
    },
    {
      'Invoice': 'INV011',
      'Billing Date': '2023-11-15',
      'Status': 'Paid',
      'Amount': 210.0,
      'Plan': 'Standard',
    },
    {
      'Invoice': 'INV012',
      'Billing Date': '2023-11-20',
      'Status': 'Overdue',
      'Amount': 310.0,
      'Plan': 'Premium',
    },
    {
      'Invoice': 'INV013',
      'Billing Date': '2023-11-25',
      'Status': 'Pending',
      'Amount': 230.0,
      'Plan': 'Basic',
    },
    {
      'Invoice': 'INV014',
      'Billing Date': '2023-11-30',
      'Status': 'Paid',
      'Amount': 240.0,
      'Plan': 'Standard',
    },
    {
      'Invoice': 'INV015',
      'Billing Date': '2023-12-05',
      'Status': 'Overdue',
      'Amount': 350.0,
      'Plan': 'Premium',
    },
  ];

  final List<String> sortByList = ['Sort By', 'Invoice No', 'Billing Date', 'Status', 'Amount', 'Plan'];

  int currentPage = 0;
  final int pageSize = 10;
  late int pageEnd;

  Color headerColor = Colors.grey;
  String selectedSortBy = "Sort By";



  @override
  void initState() {
    super.initState();
    _filteredItems = data;
    pageEnd = (data.length / 10).ceil();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Get the current page data to show
  List<Map<String, dynamic>> get currentPageData {
    int startIndex = currentPage * pageSize;
    int endIndex = (startIndex + pageSize) > data.length ? data.length : startIndex + pageSize;
    // Return a slice of the filtered products based on pagination
    return _filteredItems.sublist(
        startIndex, endIndex > _filteredItems.length ? _filteredItems.length : endIndex);
  }

  // Handle the previous page
  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  // Handle the next page
  void nextPage() {
    if ((currentPage + 1) * pageSize < data.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  // Function to filter products based on the search query
  void filterProducts(String query) {
    setState(() {
      _filteredItems = data.where((product) {
        return product['Invoice']!.toLowerCase().contains(query.toLowerCase()) ||
            product['Status']!.toLowerCase().contains(query.toLowerCase()) || product['Billing Date']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      currentPage = 0; // Reset to the first page when filtering
    });
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
    oddRowColor = Theme.of(context).colorScheme.secondaryFixed;
    oddEvenColor = Theme.of(context).colorScheme.onPrimaryFixed;

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

  desktopDashboard(BuildContext context, double fiveWidth, double fiveHeight, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomHeaderWithoutFarmDropdown(mainPageHeading: "Welcome", subHeading: "View Your Transaction History"),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: boxHeadingColor.withOpacity(0.2),
              width: 0.5,
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Your Subscription",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: boxHeadingColor
                ),
              ),

              const SizedBox(height: 50,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Text(
                              "Plan: ",
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: boxHeadingColor
                              ),
                            ),
                            Text(
                              "Professional",
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: boxHeadingColor
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          "Take your farm to the next level with more features.",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: boxHeadingColor
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Text(
                          '\$9.99 / month',
                          style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: borderColor
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 45,
                      width: 170,
                      child:  ElevatedButton(
                        onPressed: () {
                          Get.toNamed(TRoutes.subscriptionPlans);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: borderColor, // Customize the button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4), // Rounded edges
                          ),
                          padding: const EdgeInsets.only(
                              top: 17, right: 16, left: 16, bottom: 17), // Adjust padding for size
                        ),
                        child: Text(
                          'Upgrade Plan',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.white, // White text
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                            ),
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

        const SizedBox(height: 10,),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: boxHeadingColor.withOpacity(0.2),
                width: 0.5,
              ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 48,
                      width: 250,
                      child: Column(
                        children: [
                          TextField(
                            controller: _searchController,
                            onChanged: filterProducts,
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.only(left: 30, right: 10),
                              hintText: "Search invoice here...",
                              hintStyle: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: boxHeadingColor,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: borderColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: borderColor,
                                ),
                              ),
                              filled: true,
                              fillColor: boxColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 250,
                      decoration: BoxDecoration(
                        color: boxColor, // Background fill color
                        borderRadius: BorderRadius.circular(5), // Rounded corners
                        border: Border.all(
                          color: borderColor, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0), // Padding inside the container
                        child: DropdownButton<String>(
                          value: selectedSortBy,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSortBy = newValue!;
                            });
                          },
                          items: sortByList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(color: boxHeadingColor),),
                            );
                          }).toList(),
                          isExpanded: true, // Ensures the dropdown takes up full width
                          style: TextStyle(
                            color: boxHeadingColor, // Text color
                          ),
                          underline: Container(), // Removes the default underline
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              currentPageData.isNotEmpty ?
              SizedBox(
                height: ( currentPageData.length * 60 ) + 50,
                child: DataTable2(
                  headingRowHeight: 50,
                  dataRowHeight: 60,
                  columnSpacing: 30,
                  horizontalMargin: 30,
                  dividerThickness: 1.0,
                  minWidth: 600,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Invoice',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: headerColor,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Billing Date',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: headerColor,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: headerColor,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: headerColor,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Plan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: headerColor,
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(''),
                    ),
                  ],
                  rows: currentPageData.asMap().map((index, product) {
                    Color rowColor = index % 2 == 0 ?  oddEvenColor : oddRowColor ;
                    return MapEntry(
                      index,
                      DataRow(
                        color: WidgetStateProperty.resolveWith((states) => rowColor),
                        cells: [
                          DataCell(
                            Text(
                              product['Invoice']!,
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
                            Text(
                              product['Billing Date']!,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: boxHeadingColor,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: product['Status'] == "Overdue" ? Colors.red : Colors.green,
                              ),
                              child: Text(
                                product['Status']!,
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              (product['Amount']!).toString(),
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: boxHeadingColor,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              product['Plan']!,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: boxHeadingColor,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.download, color: boxHeadingColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).values.toList(),
                ),
              ) :
              Center(
                child: Text("No transaction history found!", style: GoogleFonts.poppins(textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: boxHeadingColor,
                )),),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        currentPageData.isNotEmpty ?
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Tooltip(
                message:  currentPage+1 >= 2 ? "Show previous table data" : "No previous data to show!" ,
                child: ElevatedButton(
                  onPressed: currentPage+1 >= 2 ? previousPage : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage+1 >= 2 ? borderColor : Colors.grey, // Customize the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4), // Rounded edges
                      side: BorderSide(
                        color: currentPage+1 >= 2 ? boxHeadingColor : Colors.grey,
                        width: currentPage+1 >= 2 ? 0.5 : 0,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        top: 17, right: 16, left: 16, bottom: 17), // Adjust padding for size
                  ),
                  child: Text(
                    'Previous',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: currentPage+1 >= 2 ? Colors.white : Colors.white, // White text
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Text(
                    "Page ",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: boxHeadingColor
                      ),
                    ),
                  ),

                  Text(
                    (currentPage+1).toString(),
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: boxHeadingColor
                      ),
                    ),
                  ),

                  Text(
                    " of ",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: boxHeadingColor
                      ),
                    ),
                  ),

                  Text(
                    pageEnd.toString(),
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: boxHeadingColor
                      ),
                    ),
                  ),

                ],
              ),

              Tooltip(
                message: currentPage+1 < pageEnd ? "Show next table data" : "No next data to show!" ,
                child: ElevatedButton(
                  onPressed: currentPage+1 < pageEnd ? nextPage : (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage+1 < pageEnd ? borderColor : Colors.grey, // Customize the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(
                        color: currentPage+1 < pageEnd ? boxHeadingColor : Colors.grey ,
                        width: currentPage+1 < pageEnd ? 0.5 : 0,
                      ),// Rounded edges
                    ),
                    padding: const EdgeInsets.only(
                        top: 17, right: 16, left: 16, bottom: 17), // Adjust padding for size
                  ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color:  currentPage+1 < pageEnd ? Colors.white : Colors.white, // White text
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ) :
        Container()

        ],
    );
  }

  tabletDashboard(BuildContext context, double fiveWidth, double fiveHeight, double maxWidth) {}

  mobileDashboard(BuildContext context, double fiveWidth, double fiveHeight, double maxWidth) {}

  rowHeader(BuildContext context, double fiveWidth, double fiveHeight, double width){

  }
}
