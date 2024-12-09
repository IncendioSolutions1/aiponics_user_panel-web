import 'package:aiponics_web_app/models/records%20models/monitoring_table_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MonitoringSystem extends StatefulWidget {
  const MonitoringSystem({super.key});

  @override
  State<MonitoringSystem> createState() => _MonitoringSystemState();
}

class _MonitoringSystemState extends State<MonitoringSystem> {
  double fontSize = 13;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // List of display forms
  List<String> displayForm = ['Tabular', 'Graphs'];

  // List of farms and devices
  List<String> farms = ['Farm 1', 'Farm 2', 'Farm 3', 'Farm 4'];

  // Initially, no display form is selected
  String? selectedDisplayForm;

  // Initially, no farm is selected
  String? selectedFarm;

  double desktopGraphHeight = 100;
  double tabletGraphHeight = 100;
  double mobileGraphHeight = 100;

  List<_ChartData> graphData = [
    _ChartData(DateTime(2023, 9, 1), 50, 7, 10),
    _ChartData(DateTime(2023, 9, 2), 60, 6, 80),
    _ChartData(DateTime(2023, 9, 3), 70, 8, 67),
    _ChartData(DateTime(2023, 9, 4), 60, 13, 20),
    // Add more data points
  ];

  List<_TempData> tempData = [
    _TempData(DateTime(2023, 9, 1), 50, 60),
    _TempData(DateTime(2023, 9, 2), 40, 55),
    _TempData(DateTime(2023, 9, 3), 40, 38),
    _TempData(DateTime(2023, 9, 4), 60, 65),
    // Add more data points
  ];

  List<_HumiData> humiData = [
    _HumiData(DateTime(2023, 9, 1), 50, 35),
    _HumiData(DateTime(2023, 9, 2), 60, 61),
    _HumiData(DateTime(2023, 9, 3), 70, 49),
    _HumiData(DateTime(2023, 9, 4), 60, 28),
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
    Color? boxHeadingColor = Theme.of(context).textTheme.labelLarge!.color;

    return Text(
      "Monitoring System",
      style: GoogleFonts.poppins(
        fontSize: responsiveMode == "desktop"
            ? 30
            : responsiveMode == "tablet"
                ? 30
                : 25,
        color: boxHeadingColor,
      ),
    );
  }

  SfDataGrid showDataInTabularForm() {
    final MonitoringTableData monitoringTableData =
        MonitoringTableData(context);

    Color headerColor = Theme.of(context).colorScheme.surfaceContainer;

    return SfDataGrid(
      source: monitoringTableData,
      // Enables the dragging of columns to rearrange them
      allowColumnsDragging: true,
      // Allows resizing columns by dragging the column header
      allowColumnsResizing: true,
      // Ensures the scrollbar is always visible (helpful if you have a large data set)
      isScrollbarAlwaysShown: true,
      // Automatically adjusts the column width to fit the content
      columnWidthMode: ColumnWidthMode.auto,

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
          columnName: 'Farm Temperature',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'Farm Temperature',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GridColumn(
          columnName: 'Farm Humidity',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'Farm Humidity',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GridColumn(
          columnName: 'External Temperature',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'External Temperature',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GridColumn(
          columnName: 'External Humidity',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'External Humidity',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GridColumn(
          columnName: 'Energy Consumption',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'Energy Consumption',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GridColumn(
          columnName: 'Light Intensity',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'Light Intensity',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GridColumn(
          columnName: 'Farm CO₂ Levels',
          label: Container(
            color: headerColor,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              'Farm CO₂ Levels',
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget dropDownSelectorsAndLiveDate(
      double fiveWidth, BuildContext context, responsiveMode) {
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
              farmAndDisplaySelectors(),
            ],
          ),
        ],
      );
    } else {
      // Mobile and tablet layout
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
          farmAndDisplaySelectors(),
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
  Widget farmAndDisplaySelectors() {
    return SizedBox(
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Farm selector
          dropdownField("Select Farm", farms, selectedFarm, (newValue) {
            setState(() {
              selectedFarm = newValue;
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
    required List<_TempData> tempData,
    required List<_HumiData> humiData,
    required List<_ChartData> graphData,
    required String responsive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLineChartWithDifference<_TempData>(
          title: "Internal and External Temperature",
          dataSource: tempData,
          xValueMapper: (_TempData data, _) => data.date,
          yValueMapper: (_TempData data, _) => data.exTemp,
          seriesName: "External Temperature",
          color: Colors.blue,
          xValueMapper2: (_TempData data, _) => data.date,
          yValueMapper2: (_TempData data, _) => data.inTemp,
          seriesName2: "Internal Temperature",
          color2: Colors.purple,
          height: responsive == "desktop" ? fiveWidth * 90 : 100,
        ),
        const SizedBox(height: 10),
        CustomLineChartWithDifference<_HumiData>(
          title: "Internal and External Humidity",
          dataSource: humiData,
          xValueMapper: (_HumiData data, _) => data.date,
          yValueMapper: (_HumiData data, _) => data.exHumi,
          seriesName: "External Humidity",
          color: Colors.green,
          xValueMapper2: (_HumiData data, _) => data.date,
          yValueMapper2: (_HumiData data, _) => data.inHumi,
          seriesName2: "Internal Humidity",
          color2: Colors.purple,
          height: fiveWidth * 80,
        ),
        const SizedBox(height: 10),
        CustomLineChartWithoutDifference<_ChartData>(
          title: "Energy Consumption",
          dataSource: graphData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.energyConsumption,
          seriesName: "Energy Consumption",
          color: Colors.orange,
          height: fiveWidth * 80,
        ),
        const SizedBox(height: 10),
        CustomLineChartWithoutDifference<_ChartData>(
          title: "Light Intensity",
          dataSource: graphData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.lightIntensity,
          seriesName: "Light Intensity",
          color: Colors.yellow,
          height: fiveWidth * 80,
        ),
        const SizedBox(height: 10),
        CustomLineChartWithoutDifference<_ChartData>(
          title: "CO2 Level",
          dataSource: graphData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.coLevel,
          seriesName: "CO2 Level",
          color: Colors.orangeAccent,
          height: fiveWidth * 80,
        ),
      ],
    );
  }

  Widget graphDataForm(
      double fiveWidth, BuildContext context, String responsive) {
    return buildGraphDataForm(
        fiveWidth: fiveWidth,
        tempData: tempData,
        humiData: humiData,
        graphData: graphData,
        responsive: responsive);
  }
}

class CustomLineChartWithDifference<T> extends StatelessWidget {
  final String title;
  final List<T> dataSource;
  final ChartValueMapper<T, DateTime> xValueMapper; // Use ChartValueMapper
  final ChartValueMapper<T, num> yValueMapper; // Use ChartValueMapper
  final ChartValueMapper<T, DateTime> xValueMapper2; // Use ChartValueMapper
  final ChartValueMapper<T, num> yValueMapper2;
  final String seriesName;
  final String seriesName2;
  final Color color;
  final Color color2;
  final double height;

  const CustomLineChartWithDifference({
    super.key,
    required this.title,
    required this.dataSource,
    required this.xValueMapper,
    required this.yValueMapper,
    required this.xValueMapper2,
    required this.yValueMapper2,
    required this.seriesName,
    required this.seriesName2,
    required this.color,
    required this.color2,
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
                      LineSeries<T, DateTime>(
                        name: seriesName2,
                        dataSource: dataSource,
                        xValueMapper: xValueMapper2,
                        yValueMapper: yValueMapper2,
                        color: color2,
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

class _TempData {
  _TempData(this.date, this.inTemp, this.exTemp);
  final DateTime date;
  final double inTemp;
  final double exTemp;
}

class _HumiData {
  _HumiData(this.date, this.inHumi, this.exHumi);
  final DateTime date;
  final double inHumi;
  final double exHumi;
}

class _ChartData {
  _ChartData(
      this.date, this.energyConsumption, this.lightIntensity, this.coLevel);
  final DateTime date;
  final double energyConsumption;
  final double lightIntensity;
  final double coLevel;
}
