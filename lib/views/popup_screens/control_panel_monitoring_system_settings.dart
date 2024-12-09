import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/control_panel_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ControlPanelMonitoringSystemSettings extends ConsumerWidget {


  const ControlPanelMonitoringSystemSettings({super.key,});


  Future<void> _selectStartTime(BuildContext context, WidgetRef ref) async {
    final pickedContext = context; // Capture context locally before async call
    TimeOfDay? picked = await showTimePicker(
      context: pickedContext,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null &&
        (picked.hour > TimeOfDay.now().hour ||
            (picked.hour == TimeOfDay.now().hour &&
                picked.minute >= TimeOfDay.now().minute))) {
      ref.read(controlPanelInfoProvider.notifier).updateStartTimeTimer(picked);
    } else {
      _showErrorDialog(pickedContext, "Starting time must be greater than or equal to the current time.");
    }
  }

  Future<void> _selectEndTime(BuildContext context, WidgetRef ref) async {
    final pickedContext = context; // Capture context locally before async call
    final startTime = ref.watch(controlPanelInfoProvider).startTimeTimerProvider;
    if (startTime == null) {
      _showErrorDialog(pickedContext, "Please select a starting time first.");
      return;
    }

    TimeOfDay? picked = await showTimePicker(
      context: pickedContext,
      initialTime: startTime,
    );

    if (picked != null &&
        (picked.hour > startTime.hour ||
            (picked.hour == startTime.hour && picked.minute > startTime.minute))) {
      ref.read(controlPanelInfoProvider.notifier).updateEndTimeTimer(picked);

      // Calculate the countdown duration in seconds
      final startTimeInSeconds = startTime.hour * 3600 + startTime.minute * 60;
      final endTimeInSeconds = picked.hour * 3600 + picked.minute * 60;
      final countdownDurationInSeconds = endTimeInSeconds - startTimeInSeconds;

      // Set the countdown duration and end time
      ref.read(controlPanelInfoProvider.notifier).updateCountdownTimeInSeconds(countdownDurationInSeconds);
      ref.read(controlPanelInfoProvider.notifier).updateCountdownRemainingTimeInMilliSeconds(
          DateTime.now().millisecondsSinceEpoch + countdownDurationInSeconds * 1000);
    } else {
      _showErrorDialog(pickedContext, "Ending time must be greater than starting time.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ThemeColors themeColors = ThemeColors(context);

    final switchValue = ref.watch(controlPanelInfoProvider).isMonitoringSystemManual;
    final countdownDurationInSeconds = ref.watch(controlPanelInfoProvider).countdownTimeInSeconds;
    final endTime = ref.watch(controlPanelInfoProvider).countdownRemainingTimeInMilliSeconds;
    final screenResponsive = ref.watch(dashboardScreenInfoProvider)['screenResponsiveness'];

    final boxHeadingColor = themeColors.boxHeadingColor;
    final buttonColor = themeColors.borderColor;
    final boxColor = themeColors.boxColor;

    TextEditingController startTimeController = TextEditingController();
    TextEditingController endTimeController = TextEditingController();

    final startTimeFormatted = ref.watch(controlPanelInfoProvider).startTimeTimerProvider;
    final endTimeFormatted = ref.watch(controlPanelInfoProvider).endTimeTimerProvider;

    if (startTimeFormatted != null) {
      startTimeController.text = MaterialLocalizations.of(context).formatTimeOfDay(startTimeFormatted);
    }

    if (endTimeFormatted != null) {
      endTimeController.text = MaterialLocalizations.of(context).formatTimeOfDay(endTimeFormatted);
    }


    return Scaffold(
      backgroundColor: boxColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: screenResponsive == "mobile" ?
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Monitoring System Mode:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: boxHeadingColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Auto',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: boxHeadingColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: switchValue,
                  onChanged: (value) {
                    ref.read(controlPanelInfoProvider.notifier).toggleMonitoringSystemManual();
                  },
                  activeColor: buttonColor,
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(
                  'Manual',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: boxHeadingColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 10),
            const SizedBox(height: 20),
            Text(
              'Set Timer',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: boxHeadingColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            Tooltip(
              message: switchValue ? "Please switch to auto mode for setting timer." : "",
              child: AbsorbPointer(
                absorbing: switchValue,
                child: TextField(
                  controller: startTimeController,
                  readOnly: true,
                  onTap: () => _selectStartTime(context, ref),
                  decoration: const InputDecoration(
                    labelText: 'Starting Time',
                    suffixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Tooltip(
              message: switchValue ? "Please switch to auto mode for setting timer." : "",
              child: AbsorbPointer(
                absorbing: switchValue,
                child: TextField(
                  controller: endTimeController,
                  readOnly: true,
                  onTap: () => _selectEndTime(context, ref),
                  decoration: const InputDecoration(
                    labelText: 'Ending Time',
                    suffixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (countdownDurationInSeconds > 0 && !switchValue) // Only show timer if end time is set
              Center(
                child: CountdownTimer(
                  endTime: endTime,
                  widgetBuilder: (BuildContext context, time) {
                    if (time != null) {
                      final hours = (time.min ?? 0) ~/ 60;
                      final minutes = (time.min ?? 0) % 60;
                      final seconds = time.sec ?? 0;

                      final remainingTimeString = '$hours:$minutes:${seconds.toString().padLeft(2, '0')}';

                      Future.microtask((){
                        // Update the remaining time in the provider
                        ref.read(controlPanelInfoProvider.notifier).updateRemainingTime(remainingTimeString);
                      });

                    }

                    double progress = time == null
                        ? 1.0
                        : ((time.min ?? 0) * 60 + (time.sec ?? 0)) / countdownDurationInSeconds;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: 1.0 - progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        if (time != null)
                          Text(
                            '${time.min ?? 0}:${time.sec?.toString().padLeft(2, '0') ?? '00'}',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                        else
                          Text(
                            'Times up!',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ) :
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monitoring System Mode:',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: boxHeadingColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Auto',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: boxHeadingColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Switch(
                      value: switchValue,
                      onChanged: (value) {
                        ref.read(controlPanelInfoProvider.notifier).toggleMonitoringSystemManual();
                      },
                      activeColor: buttonColor,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Manual',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: boxHeadingColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 1, height: 20),
            const SizedBox(height: 40),
            Text(
              'Set Timer',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: boxHeadingColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            Tooltip(
              message: switchValue ? "Please switch to auto mode for setting timer." : "",
              child: AbsorbPointer(
                absorbing: switchValue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startTimeController,
                        readOnly: true,
                        onTap:  () => _selectStartTime(context, ref),
                        decoration: const InputDecoration(
                          labelText: 'Starting Time',
                          suffixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: endTimeController,
                        readOnly: true,
                        onTap: () => _selectEndTime(context, ref),
                        decoration: const InputDecoration(
                          labelText: 'Ending Time',
                          suffixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            if (countdownDurationInSeconds > 0 && !switchValue) // Only show timer if end time is set
              Center(
                child: CountdownTimer(
                  endTime: endTime,
                  widgetBuilder: (BuildContext context, time) {
                    if (time != null) {
                      final hours = (time.min ?? 0) ~/ 60;
                      final minutes = (time.min ?? 0) % 60;
                      final seconds = time.sec ?? 0;

                      final remainingTimeString = '$hours:$minutes:${seconds.toString().padLeft(2, '0')}';

                      Future.microtask((){
                        // Update the remaining time in the provider
                        ref.read(controlPanelInfoProvider.notifier).updateRemainingTime(remainingTimeString);
                      });
                    }

                    double progress = time == null
                        ? 1.0
                        : ((time.min ?? 0) * 60 + (time.sec ?? 0)) / countdownDurationInSeconds;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: 1.0 - progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        if (time != null)
                          Text(
                            '${time.min ?? 0}:${time.sec?.toString().padLeft(2, '0') ?? '00'}',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                        else
                          Text(
                            'Times up!',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
