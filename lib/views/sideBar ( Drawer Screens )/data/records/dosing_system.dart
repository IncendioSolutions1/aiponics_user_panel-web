import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../models/records models/dosing_table_model.dart';

class DosingSystem extends StatefulWidget {
  const DosingSystem({super.key});

  @override
  State<DosingSystem> createState() => _DosingSystemState();
}

class _DosingSystemState extends State<DosingSystem> {
    double fontSize = 13;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // List of display forms
  List<String> displayForm = ['Tabular', 'Graphs'];

  // List of farms and devices
  List<String> farms = ['Farm 1', 'Farm 2', 'Farm 3', 'Farm 4'];

  // List of farms and devices
  List<String> devices = ['Device 1', 'Device 2', 'Device 3', 'Device 4'];

  // Initially, no display form is selected
  String? selectedDisplayForm;

  // Initially, no farm is selected
  String? selectedFarm;

  // Initially, no device is selected
  String? selectedDevice;

  List<_ChartData> graphData = [
    _ChartData(DateTime(2023, 9, 1), 50, 7, 10),
    _ChartData(DateTime(2023, 9, 2), 60, 6, 80),
    _ChartData(DateTime(2023, 9, 3), 70, 8, 67),
    _ChartData(DateTime(2023, 9, 4), 60, 13, 20),
    // Add more data points
  ];

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  @override
  void initState() {
    selectedDisplayForm = displayForm.first;
    selectedFarm = farms.first;
    selectedDevice = devices.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size to make the layout responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final fiveWidth = screenWidth * 0.003434;

    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = MediaQuery.of(context).size.width;
            if (constraints.maxWidth >= 900) {
              return mainHomeWidget(fiveWidth, context, 'desktop', width);
            } else if ((constraints.maxWidth < 900 &&
                    constraints.maxWidth >= 750) ||
                width >= 750) {
              return mainHomeWidget(fiveWidth, context, 'tablet', width);
            } else {
              return mainHomeWidget(fiveWidth, context, 'mobile', width);
            }
          },
        ),
      ),
    );
  }

  Widget mainHomeWidget(
      double fiveWidth, BuildContext context, String responsive, double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 50, left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mainTopHeading(responsive),
          const SizedBox(
            height: 80,
          ),
          dropDownSelectorsAndLiveDate(fiveWidth, context, responsive),
          const SizedBox(
            height: 50,
          ),
          if (selectedDisplayForm == 'Tabular')
            SizedBox(
              height: 500,
              child: showDataInTabularForm(),
            )
          else
            graphDataForm(fiveWidth, context, responsive)
        ],
      ),
    );
  }

  Widget mainTopHeading(String responsiveMode) {
    return Text(
      "Dosing System",
      style: GoogleFonts.poppins(
        fontSize: responsiveMode == "desktop"
            ? 30
            : responsiveMode == "tablet"
                ? 30
                : 25,
      ),
    );
  }

  SfDataGrid showDataInTabularForm() {
    Color headerColor = Theme.of(context).colorScheme.surfaceContainer;
    final DosingTableData dosingTableData = DosingTableData(context);

    return SfDataGrid(
      source: dosingTableData,
      // Enables the dragging of columns to rearrange them
      allowColumnsDragging: true,
      // Allows resizing columns by dragging the column header
      allowColumnsResizing: true,
      // Ensures the scrollbar is always visible (helpful if you have a large data set)
      isScrollbarAlwaysShown: true,
      // Automatically adjusts the column width to fit the content
      columnWidthMode: ColumnWidthMode.fill,

      footer: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "You have reached at the end!",
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // Allows columns to be frozen on the left side, so they stay visible during horizontal scroll
      frozenColumnsCount: 2, // Freezes the first column
      // Enables horizontal scrolling for larger grids with many columns
      horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
      // Enables vertical scrolling
      verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
      // Controls whether or not row selection is enabled
      selectionMode: SelectionMode.single, // Allows single row selection
      // Enables row highlighting when the user hovers over a row
      highlightRowOnHover: true,
      // Customize how each row behaves
      rowHeight: 50, // Sets a custom row height
      headerRowHeight: 60, // Sets a custom header row height

      // Enables column sorting indicators
      sortingGestureType: SortingGestureType.tap,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'Date',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'Date',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        GridColumn(
          columnName: 'Time',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'Time',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        GridColumn(
          columnName: 'TDS',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'TDS',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GridColumn(
          columnName: 'PH Level',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'PH Level',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GridColumn(
          columnName: 'Water Level',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'Water Level',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget dropDownSelectorsAndLiveDate(double fiveWidth, BuildContext context, responsiveMode) {
    if (responsiveMode == 'desktop') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show today's date
          Row(
            children: [
              Text(
                "Today's Date: ",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Column(
            children: [
              // Date Selector
              SizedBox(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dateSelector(fiveWidth, context, isStartDate: true),
                    Text("to", style: GoogleFonts.poppins(fontSize: 12)),
                    dateSelector(fiveWidth, context, isStartDate: false),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              farmDeviceAndDisplaySelectors(),
            ],
          ),
        ],
      );
    } else if (responsiveMode == 'tablet') {
      // Tablet layout
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Today's Date: ",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Date Selector
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dateSelector(fiveWidth, context, isStartDate: true),
                Text("to", style: GoogleFonts.poppins(fontSize: 12)),
                dateSelector(fiveWidth, context, isStartDate: false),
              ],
            ),
          ),
          const SizedBox(height: 40),
          farmDeviceAndDisplaySelectors(),
        ],
      );
    } else {
      // Mobile layout
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Today's Date: ",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Date Selector
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dateSelector(fiveWidth, context, isStartDate: true),
                Text("to", style: GoogleFonts.poppins(fontSize: 12)),
                dateSelector(fiveWidth, context, isStartDate: false),
              ],
            ),
          ),
          const SizedBox(height: 40),
          farmDeviceAndDisplaySelectorsOfMobile(),
        ],
      );
    }
  }

  // Date selector widget
  Widget dateSelector(double fiveWidth, BuildContext context,
      {required bool isStartDate}) {
    return SizedBox(
      width: 175,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff4f5f7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            isStartDate ? _selectStartDate(context) : _selectEndDate(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.grey,
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 13,
                ),
              ),
              SizedBox(width: fiveWidth * 3),
              Text(
                isStartDate
                    ? (_selectedStartDate == null
                        ? DateFormat('MMM dd, yyyy').format(DateTime.now())
                        : DateFormat.yMd().format(_selectedStartDate!))
                    : (_selectedEndDate == null
                        ? DateFormat('MMM dd, yyyy').format(DateTime.now())
                        : DateFormat.yMd().format(_selectedEndDate!)),
                style: GoogleFonts.poppins(
                    textStyle:
                        const TextStyle(fontSize: 13, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Farm and Display selectors
  Widget farmDeviceAndDisplaySelectors() {
    return SizedBox(
      width: 600,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Farm selector
          dropdownField("Select Farm", farms, selectedFarm, (newValue) {
            setState(() {
              selectedFarm = newValue;
            });
          }),
          // Device Selector
          dropdownField("Select Device", devices, selectedDevice, (newValue) {
            setState(() {
              selectedDevice = newValue;
            });
          }),
          // Display selector
          dropdownField("Select Display Form", displayForm, selectedDisplayForm,
              (newValue) {
            setState(() {
              selectedDisplayForm = newValue;
            });
          }),
        ],
      ),
    );
  }

  Widget farmDeviceAndDisplaySelectorsOfMobile() {
    return SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Farm selector
              dropdownField("Select Farm", farms, selectedFarm, (newValue) {
                setState(() {
                  selectedFarm = newValue;
                });
              }),
              // Device Selector
              dropdownField("Select Device", devices, selectedDevice,
                  (newValue) {
                setState(() {
                  selectedDevice = newValue;
                });
              }),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          // Display selector
          dropdownField("Select Display Form", displayForm, selectedDisplayForm,
              (newValue) {
            setState(() {
              selectedDisplayForm = newValue;
            });
          }),
        ],
      ),
    );
  }

  // Dropdown field widget
  Widget dropdownField(String labelText, List<String> items,
      String? selectedItem, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 175,
      height: 45,
      child: DropdownSearch<String>(
        onChanged: onChanged,
        items: (filter, infiniteScrollProps) => items,
        selectedItem: selectedItem,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          constraints: const BoxConstraints(maxHeight: 300),
          menuProps: const MenuProps(
            backgroundColor: Colors.white,
            elevation: 8,
          ),
          itemBuilder: (context, item, isSelected, boolAgain) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGraphDataForm({
    required double fiveWidth,
    required List<_ChartData> chartData,
    required String responsive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLineChartWithoutDifference<_ChartData>(
          title: "TDS",
          dataSource: graphData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.tds,
          seriesName: "TDS",
          color: Colors.orange,
          height: fiveWidth * 80,
        ),
        const SizedBox(height: 10),
        CustomLineChartWithoutDifference<_ChartData>(
          title: "PH Level",
          dataSource: graphData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.phLevel,
          seriesName: "PH Level",
          color: Colors.yellow,
          height: fiveWidth * 80,
        ),
        const SizedBox(height: 10),
        CustomLineChartWithoutDifference<_ChartData>(
          title: "Water Level",
          dataSource: graphData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.waterLevel,
          seriesName: "Water Level",
          color: Colors.orangeAccent,
          height: fiveWidth * 80,
        ),
      ],
    );
  }

  Widget graphDataForm(
      double fiveWidth, BuildContext context, String responsive) {
    return buildGraphDataForm(
        fiveWidth: fiveWidth, chartData: graphData, responsive: responsive);
  }
}

class CustomLineChartWithoutDifference<T> extends StatelessWidget {
  final String title;
  final List<T> dataSource;
  final ChartValueMapper<T, DateTime> xValueMapper; // Use ChartValueMapper
  final ChartValueMapper<T, num> yValueMapper; // Use ChartValueMapper
  final String seriesName;
  final Color color;
  final double height;

  const CustomLineChartWithoutDifference({
    super.key,
    required this.title,
    required this.dataSource,
    required this.xValueMapper,
    required this.yValueMapper,
    required this.seriesName,
    required this.color,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;

    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    primaryXAxis: const DateTimeAxis(),
                    legend: const Legend(isVisible: true),
                    series: <CartesianSeries>[
                      LineSeries<T, DateTime>(
                        name: seriesName,
                        dataSource: dataSource,
                        xValueMapper: xValueMapper,
                        yValueMapper: yValueMapper,
                        color: color,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.tds, this.phLevel, this.waterLevel);
  final DateTime date;
  final double tds;
  final double phLevel;
  final double waterLevel;
}
