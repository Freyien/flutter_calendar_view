import 'package:flutter/material.dart';

import '../../calendar_view.dart';

class ScheduleView<T> extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView<T>> createState() => _ScheduleViewState<T>();
}

class _ScheduleViewState<T> extends State<ScheduleView<T>> {
  final ScrollController scrollController = ScrollController();

  final List<Map<DateTime, List<CalendarEventData<T>>>> dataList = [];

  EventController<T>? eventController;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScrollPagination);
  }

  void loadInitialCalendar() {
    final date = DateTime.now();
    for (var i = 0; i < 10; i++) {
      if (eventController != null) {
        final currentDate = date.add(Duration(days: i));
        final events = eventController!.getEventsOnDay(currentDate);
        dataList.add({currentDate: events});
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    eventController ??= CalendarControllerProvider.of<T>(context).controller;
  }

  void onScrollPagination() {}

  @override
  Widget build(BuildContext context) {
    loadInitialCalendar();
    return SafeArea(
      child: ListView.separated(
        controller: ScrollController(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return DayWidget(data: dataList[index]);
        },
        itemCount: dataList.length,
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}

class DayWidget<T> extends StatelessWidget {
  const DayWidget({Key? key, required this.data}) : super(key: key);

  final Map<DateTime, List<CalendarEventData<T>>> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, __) => Container(
                margin: EdgeInsets.all(10),
                height: 20,
                width: MediaQuery.of(context).size.width - 10,
                color: Colors.indigoAccent,
              ),
              itemCount: data[1]?.length,
            ),
          ),
        ],
      ),
    );
  }
}
