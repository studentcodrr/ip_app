import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taskflow_app/models/task_model.dart';
import 'package:taskflow_app/models/group_model.dart';
import 'package:taskflow_app/utils/monday_theme.dart';
import 'package:taskflow_app/widgets/monday_group.dart';

class TaskWithGroup {
  final TaskModel task;
  final String groupName;
  TaskWithGroup(this.task, this.groupName);
}

class ProjectTimelineView extends ConsumerStatefulWidget {
  final String projectId;
  final List<GroupModel> groups;

  const ProjectTimelineView({
    super.key,
    required this.projectId,
    required this.groups,
  });

  @override
  ConsumerState<ProjectTimelineView> createState() => _ProjectTimelineViewState();
}

class _ProjectTimelineViewState extends ConsumerState<ProjectTimelineView> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TaskWithGroup> allTasks = [];
    bool isLoading = false;

    for (var group in widget.groups) {
      final tasksAsync = ref.watch(groupTasksProvider(ProjectGroupPair(widget.projectId, group.id)));
      
      tasksAsync.when(
        data: (tasks) {
          for (var task in tasks) {
            allTasks.add(TaskWithGroup(task, group.name));
          }
        },
        loading: () => isLoading = true, 
        error: (_, __) {}, 
      );
    }

    if (isLoading && allTasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (allTasks.isEmpty) {
      return const Center(child: Text("No tasks found. Add items to see the timeline."));
    }

    allTasks.sort((a, b) {
      final dateA = a.task.startDate ?? DateTime.now();
      final dateB = b.task.startDate ?? DateTime.now();
      return dateA.compareTo(dateB);
    });

    return Scrollbar(
      controller: _verticalController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _verticalController,
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _horizontalController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 16),
                child: _GanttChartRenderer(tasks: allTasks),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GanttChartRenderer extends StatelessWidget {
  final List<TaskWithGroup> tasks;

  const _GanttChartRenderer({required this.tasks});

  @override
  Widget build(BuildContext context) {
    DateTime minDate = DateTime.now();
    DateTime maxDate = DateTime.now().add(const Duration(days: 30));

    final validTasks = tasks.where((t) => t.task.startDate != null && t.task.endDate != null).toList();

    if (validTasks.isNotEmpty) {
      minDate = validTasks.map((e) => e.task.startDate!).reduce((a, b) => a.isBefore(b) ? a : b);
      maxDate = validTasks.map((e) => e.task.endDate!).reduce((a, b) => a.isAfter(b) ? a : b);
    }

    minDate = minDate.subtract(const Duration(days: 7));
    maxDate = maxDate.add(const Duration(days: 7));
    
    final int totalDays = maxDate.difference(minDate).inDays + 1;
    
    const double dayWidth = 40.0;
    const double headerHeight = 50.0; 
    const double rowHeight = 44.0;
    
    final double totalWidth = totalDays * dayWidth;
    final double totalHeight = (tasks.length * rowHeight) + headerHeight;

    return Container(
      height: totalHeight,
      width: totalWidth,
      color: Colors.white,
      child: Stack(
        children: [
          Row(
            children: List.generate(totalDays, (index) {
              return Container(
                width: dayWidth,
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey.shade100)),
                ),
              );
            }),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: _buildMonthHeaders(minDate, totalDays, dayWidth),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: List.generate(totalDays, (index) {
                      final date = minDate.add(Duration(days: index));
                      return Container(
                        width: dayWidth,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          Positioned.fill(
            top: headerHeight,
            child: Stack(
              children: List.generate(tasks.length, (index) {
                final item = tasks[index];
                final task = item.task;
                
                if (task.startDate == null || task.endDate == null) return const SizedBox();

                final startOffset = task.startDate!.difference(minDate).inDays * dayWidth;
                final durationDays = task.endDate!.difference(task.startDate!).inDays + 1;
                final width = durationDays * dayWidth;

                return Positioned(
                  top: index * rowHeight,
                  left: startOffset,
                  height: rowHeight,
                  child: Center(
                    child: Tooltip(
                      richMessage: TextSpan(
                        style: const TextStyle(color: Colors.black87, fontSize: 12),
                        children: [
                          TextSpan(
                            text: "${task.name}\n",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const TextSpan(
                            text: "Phase: ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: "${item.groupName}\n",
                            style: const TextStyle(
                              color: Color(0xFF0073EA), 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          TextSpan(
                            text: "${DateFormat('MMM d').format(task.startDate!)} - ${DateFormat('MMM d').format(task.endDate!)}",
                          ),
                        ],
                      ),
                      
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10, 
                            offset: const Offset(0, 5)
                          )
                        ],
                      ),
                      
                      child: Container(
                        height: 28, 
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: MondayTheme.getStatusColor(task.status),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3, offset: const Offset(0, 2))
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          task.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 11, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMonthHeaders(DateTime minDate, int totalDays, double dayWidth) {
    List<Widget> months = [];
    DateTime current = minDate;
    int daysAccumulated = 0;

    while (daysAccumulated < totalDays) {
      final nextMonth = DateTime(current.year, current.month + 1, 1);
      final daysInThisMonth = nextMonth.difference(current).inDays;
      final daysRemaining = totalDays - daysAccumulated;
      final daysToDraw = daysInThisMonth < daysRemaining ? daysInThisMonth : daysRemaining;
      
      months.add(
        Container(
          width: daysToDraw * dayWidth,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Colors.grey.shade300),
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Text(
            DateFormat('MMMM yyyy').format(current),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
          ),
        )
      );
      current = nextMonth;
      daysAccumulated += daysToDraw;
    }
    return months;
  }
}