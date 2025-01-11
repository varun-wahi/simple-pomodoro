import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_pomodoro/core/util/widgets/filter_selection_bar.dart';

import '../../data/repository/session_storage.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final SessionStorage sessionStorage = SessionStorage();
  List<Map<String, dynamic>> sessions = [];
  int totalFocusTime = 0; // In seconds
  int totalBreakTime = 0; // In seconds

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  /// Load all session data from SharedPreferences (via SessionStorage)
  Future<void> _loadSessionData() async {
    final data = await sessionStorage.retrieveSessionData();
    setState(() {
      sessions = data;
      totalFocusTime = data.fold(
        0,
        (sum, session) => sum + (session['totalFocusTime'] as int ?? 0),
      );
      totalBreakTime = data.fold(
        0,
        (sum, session) => sum + (session['totalBreakTime'] as int ?? 0),
      );
    });
  }

  /// Format a duration (in seconds) as HH:MM:SS
  String _formatDurationWithSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = secs.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  /// Format date/time with day, month, year, hours, minutes, seconds, and AM/PM
  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analytics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: sessions.isEmpty
            ? const Center(
                child: Text(
                  "No session data available.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const FilterSelectionBar(),
                  // Total Metrics
                  _buildTotalMetricsCard(),
                  const SizedBox(height: 20),

                  // Recent Sessions
                  const Text(
                    "Recent Sessions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // List of sessions in a scrollable ListView
                  Expanded(
                    child: ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return _buildSessionCard(session);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// A card that displays the **total** focus/break time in HH:MM:SS format
  Widget _buildTotalMetricsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMetric(
              "Total Focus Time",
              _formatDurationWithSeconds(totalFocusTime),
              Icons.timer,
              Colors.blue,
            ),
            _buildMetric(
              "Total Break Time",
              _formatDurationWithSeconds(totalBreakTime),
              Icons.coffee,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  /// A single metric block that shows an icon, time value, and a title
  Widget _buildMetric(String title, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 8),
        Text(
          value, // e.g. "00:25:30"
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  /// A more modern custom card (no ListTile) showing session details
  Widget _buildSessionCard(Map<String, dynamic> session) {
    final focusSecs = session['totalFocusTime'] ?? 0;
    final breakSecs = session['totalBreakTime'] ?? 0;

    // Decide which icon and color to emphasize
    final icon = focusSecs >= breakSecs ? Icons.timer : Icons.coffee;
    final iconColor = focusSecs >= breakSecs ? Colors.blue : Colors.green;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + Session ID
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Session: ${session['sessionId']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Start & End date-time
            RichText(
              text: TextSpan(
              children: [
                const TextSpan(
                text: "Start: ",
                style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                ),
                TextSpan(
                text: _formatDate(session['startDateTime']),
                style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
              ),
            ),
            RichText(
              text: TextSpan(
              children: [
                const TextSpan(
                text: "End:   ",
                style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                ),
                TextSpan(
                text: _formatDate(session['endDateTime']),
                style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
              ),
            ),
            const SizedBox(height: 8),

            // Focus and Break durations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Focus: ${_formatDurationWithSeconds(focusSecs)}",
                  // style: const TextStyle(fontSize: 14, color: Colors.white),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Break: ${_formatDurationWithSeconds(breakSecs)}",
                  // style: const TextStyle(fontSize: 14, color: Colors.white),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}