import 'dart:math'; // Importing the math library for random number generation
import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:google_fonts/google_fonts.dart'; // Importing Google Fonts package
import 'package:intl/intl.dart'; // Importing package for date formatting
import 'package:syncfusion_flutter_datagrid/datagrid.dart'; // Importing Syncfusion DataGrid package

import '../../theme/table_theme.dart'; // Importing custom table theme

// MonitoringTableData class that extends DataGridSource for managing monitoring data
class MonitoringTableData extends DataGridSource {
  double fontSize = 12; // Default font size for table cells
  final BuildContext context; // Build context for accessing theme and widget tree

  // Generate a list of maps containing random monitoring data for the table
  final List<Map<String, dynamic>> _data = List.generate(
    60, // Generate 60 entries
        (index) {
      DateTime randomDate = DateTime(2024, 9, Random().nextInt(30) + 1); // Generate a random date in September 2024
      String formattedDate = DateFormat("dd MMM, yyyy hh:mm:ss a").format(randomDate); // Format the random date to "dd MMM, yyyy hh:mm:ss a"
      // Parse back the formatted date as DateTime
      DateTime parsedDate = DateFormat("dd MMM, yyyy hh:mm:ss a").parse(formattedDate);

      // Create a DateTime object with the time set to midnight (00:00:00)
      String dateWithoutTime = DateFormat("dd MMM, yyyy").format(DateTime(parsedDate.year, parsedDate.month, parsedDate.day)); // Get the date without time
      String onlyTime = DateFormat("hh:mm:ss a").format(DateTime(parsedDate.year, parsedDate.month, parsedDate.day)); // Extract only the time

      return {
        "Date": dateWithoutTime,  // Store the formatted date without time
        "Time": onlyTime,  // Store the formatted time without date
        "Farm Temperature": Random().nextInt(100), // Generate random Farm Temperature
        "Farm Humidity": Random().nextInt(100), // Generate random Farm Humidity
        "External Temperature": Random().nextInt(100), // Generate random External Temperature
        "External Humidity": Random().nextInt(100), // Generate random External Humidity
        "Energy Consumption": Random().nextInt(100), // Generate random Energy Consumption
        "Light Intensity": Random().nextInt(100), // Generate random Light Intensity
        "Farm CO₂ Levels": Random().nextInt(100), // Generate random Farm CO₂ Levels
      };
    },
  );

  // Initialize DataGridRows based on _data
  List<DataGridRow> _rows = []; // List to hold DataGridRows

  // Constructor to initialize _rows using the generated data
  MonitoringTableData(this.context) {
    _rows = _data
        .map<DataGridRow>((data) => DataGridRow( // Map each data entry to a DataGridRow
        cells: [
          DataGridCell<String>(columnName: 'Date', value: data['Date']), // Create cell for Date
          DataGridCell<String>(columnName: 'Time', value: data['Time']), // Create cell for Time
          DataGridCell<int>( // Create cell for Farm Temperature
              columnName: 'Farm Temperature',
              value: data['Farm Temperature']),
          DataGridCell<int>( // Create cell for Farm Humidity
              columnName: 'Farm Humidity', value: data['Farm Humidity']),
          DataGridCell<int>( // Create cell for External Temperature
              columnName: 'External Temperature',
              value: data['External Temperature']),
          DataGridCell<int>( // Create cell for External Humidity
              columnName: 'External Humidity',
              value: data['External Humidity']),
          DataGridCell<int>( // Create cell for Energy Consumption
              columnName: 'Energy Consumption',
              value: data['Energy Consumption']),
          DataGridCell<int>( // Create cell for Light Intensity
              columnName: 'Light Intensity',
              value: data['Light Intensity']),
          DataGridCell<int>( // Create cell for Farm CO₂ Levels
              columnName: 'Farm CO₂ Levels',
              value: data['Farm CO₂ Levels']),
        ]),)
        .toList(); // Convert to list of DataGridRows
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // Alternate row colors for better readability
    bool isEvenRow = _rows.indexOf(row) % 2 == 0; // Check if the row index is even
    final tableColors = Theme.of(context).extension<TableColors>(); // Get table colors from theme

    return DataGridRowAdapter(
      color: isEvenRow ? tableColors?.evenRowColor : tableColors?.oddRowColor, // Set row color based on even/odd
      cells: row.getCells().map<Widget>((dataCell) { // Map each cell to a widget
        return Container(
          padding: const EdgeInsets.all(8.0), // Add padding to each cell
          alignment: Alignment.center, // Center align the cell content
          child: Text(
            dataCell.value.toString(), // Display the cell value as text
            style: GoogleFonts.poppins(fontSize: 12, color: tableColors?.textColor), // Set text style
          ),
        );
      }).toList(), // Convert the cell widgets to a list
    );
  }

  @override
  List<DataGridRow> get rows => _rows; // Getter for the rows
}
