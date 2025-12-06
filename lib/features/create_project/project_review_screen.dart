import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskflow_app/providers/app_providers.dart';
import 'package:taskflow_app/features/create_project/create_project_controller.dart'; 
import 'package:taskflow_app/models/task_model.dart'; 

class ProjectReviewScreen extends ConsumerStatefulWidget {
  final ProjectProposal proposal;

  const ProjectReviewScreen({super.key, required this.proposal});

  @override
  ConsumerState<ProjectReviewScreen> createState() => _ProjectReviewScreenState();
}

class _ProjectReviewScreenState extends ConsumerState<ProjectReviewScreen> {
  bool _isSaving = false;

  Future<void> _onApprove() async {
    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final finalProject = widget.proposal.project.copyWith(ownerId: user.uid);

      await ref.read(projectRepoProvider).saveGeneratedPlan(
            finalProject,
            widget.proposal.groups,
            widget.proposal.tasksByGroup,
          );

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.proposal.project;
    final groups = widget.proposal.groups;
    final tasksMap = widget.proposal.tasksByGroup;

    final int score = project.auditScore;
    final String feedback = project.auditFeedback;
    
    final Color statusColor = score >= 80 ? Colors.green 
                            : score >= 50 ? Colors.orange 
                            : Colors.red;

    return Scaffold(
      appBar: AppBar(title: const Text("Review Plan")),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.redAccent),
                    foregroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  child: const Text("Discard & Retry"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0073EA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isSaving ? null : _onApprove,
                  child: _isSaving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Approve Plan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //AUDIT REPORT
            if (score > 0)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          score >= 80 ? Icons.verified : Icons.warning_amber_rounded,
                          color: statusColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Accuracy Score: $score%",
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold, 
                                color: statusColor
                              ),
                            ),
                            Text(
                              score >= 80 ? "This plan looks solid." : "Review dates carefully.",
                              style: TextStyle(
                                fontSize: 12, 
                                color: statusColor.withOpacity(0.8),
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    if (feedback.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        "AI Feedback:",
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black87.withOpacity(0.6)
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      ...feedback
                          .split(RegExp(r'(?=Step \d+:)')) 
                          .where((s) => s.trim().isNotEmpty)
                          .map((step) {
                            //Remove the "Step X:" 
                            final cleanStep = step.replaceAll(RegExp(r'Step \d+:'), '').trim();
                            
                            return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4.0, right: 8.0),
                                      child: Icon(Icons.arrow_right, size: 16, color: Colors.blue),
                                    ),
                                    Expanded(
                                      child: Text(
                                        cleanStep.isEmpty ? step.trim() : cleanStep, // Fallback if regex fails
                                        style: const TextStyle(fontSize: 13, height: 1.4),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                          }),
                    ]
                  ],
                ),
              ),

            //PROJECT TITLE
            Text(
              project.name, 
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 16),

            //PROMPTS DISPLAY
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPromptRow(Icons.lightbulb_outline, "Goal:", widget.proposal.userDescription),
                  const SizedBox(height: 8),
                  _buildPromptRow(Icons.construction, "Strategy:", widget.proposal.userStrategy),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 4. GROUPS LIST ---
            ...groups.map((group) {
              final tasks = tasksMap[group.id] ?? [];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      group.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0073EA)),
                    ),
                    children: tasks.map((task) => _buildReviewTaskRow(task)).toList(),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Text(
          "$label ",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
        Expanded(
          child: Text(
            value, 
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewTaskRow(TaskModel task) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        leading: const Icon(Icons.circle_outlined, size: 16, color: Colors.grey),
        title: Text(task.name, style: const TextStyle(fontSize: 14)),
        trailing: Text(
          "${task.durationDays}d",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}