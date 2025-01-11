import 'package:flutter/material.dart';

/// An enumeration to identify the selected filter
enum FilterRange {
  today,
  thisWeek,
  thisMonth,
  lastMonth,
  thisYear,
}

class FilterSelectionBar extends StatefulWidget {
  const FilterSelectionBar({Key? key}) : super(key: key);

  @override
  State<FilterSelectionBar> createState() => _FilterSelectionBarState();
}

class _FilterSelectionBarState extends State<FilterSelectionBar> {
  // The currently selected filter
  FilterRange selectedFilter = FilterRange.today;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample Filter Bar"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildFilterSelectionBar(),
        ),
      ),
    );
  }

  /// Builds a segmented button row with five filter options.
  Widget _buildFilterSelectionBar() {
    return SegmentedButton<FilterRange>(
      segments: const [
        ButtonSegment(
          value: FilterRange.today,
          label: Text('Today'),
        ),
        ButtonSegment(
          value: FilterRange.thisWeek,
          label: Text('This Week'),
        ),
        ButtonSegment(
          value: FilterRange.thisMonth,
          label: Text('This Month'),
        ),
        ButtonSegment(
          value: FilterRange.lastMonth,
          label: Text('Last Month'),
        ),
        ButtonSegment(
          value: FilterRange.thisYear,
          label: Text('This Year'),
        ),
      ],
      selected: <FilterRange>{selectedFilter},
      onSelectionChanged: (newSelection) {
        setState(() {
          // Because this is a single-choice filter, 
          // we only use the first item in the newSelection set.
          selectedFilter = newSelection.first;
        });
        // Perform any actions based on the newly selected filter.
        debugPrint('Selected: $selectedFilter');
      },
    );
  }
}