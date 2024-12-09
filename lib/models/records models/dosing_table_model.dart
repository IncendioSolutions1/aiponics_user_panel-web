import 'dart:math'; // Importing the math library for random number generation
import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:google_fonts/google_fonts.dart'; // Importing Google Fonts package
import 'package:intl/intl.dart'; // Importing package for date formatting
import 'package:syncfusion_flutter_datagrid/datagrid.dart'; // Importing Syncfusion DataGrid package

import '../../theme/table_theme.dart'; // Importing custom table theme

// DosingTableData class that extends DataGridSource for managing table data
class DosingTableData extends DataGridSource {
  double fontSize = 12; // Default font size for table cells
  final BuildContext context; // Build context for accessing theme and widget tree

  // Generate a list of maps containing random data for the table
  final List<Map<String, dynamic>> _data = List.generate(
    60, // Generate 60 entries
        (index) {
      DateTime randomDate =
      DateTime(2024, 9, Random().nextInt(30) + 1); // Generate a random date in September 2024
      String formattedDate = DateFormat("dd MMM, yyyy hh:mm:ss a")
          .format(randomDate); // Format the random date to "dd MMM, yyyy hh:mm:ss a"
      // Parse back the formatted date as DateTime
      DateTime parsedDate =
      DateFormat("dd MMM, yyyy hh:mm:ss a").parse(formattedDate);

      // Create a DateTime object with the time set to midnight (00:00:00)
      String dateWithoutTime = DateFormat("dd MMM, yyyy")
          .format(DateTime(parsedDate.year, parsedDate.month, parsedDate.day)); // Get the date without time
      String onlyTime = DateFormat("hh:mm:ss a")
          .format(DateTime(parsedDate.year, parsedDate.month, parsedDate.day)); // Extract only the time

      return {
        "Date": dateWithoutTime, // Store the formatted date
        "Time": onlyTime, // Store the formatted time
        "TDS": Random().nextInt(100), // Generate random TDS value
        "PH Level": Random().nextInt(100), // Generate random PH Level value
        "Water Level": Random().nextInt(100), // Generate random Water Level value
      };
    },
  );

  // Initialize DataGridRows based on _data
  List<DataGridRow> _rows = []; // List to hold DataGridRows

  // Constructor to initialize _rows using the generated data
  DosingTableData(this.context) {
    _rows = _data
        .map<DataGridRow>( // Map each data entry to a DataGridRow
          (data) => DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Date', value: data['Date']), // Create cell for Date
        DataGridCell<String>(columnName: 'Time', value: data['Time']), // Create cell for Time
        DataGridCell<int>(columnName: 'TDS', value: data['TDS']), // Create cell for TDS
        DataGridCell<int>(columnName: 'PH Level', value: data['PH Level']), // Create cell for PH Level
        DataGridCell<int>(columnName: 'Water Level', value: data['Water Level']), // Create cell for Water Level
      ]),
    )
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
