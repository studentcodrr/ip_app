import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_app/widgets/sidebar.dart';
import 'create_project_controller.dart';
import 'project_review_screen.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  final String? initialDescription;
  final String? initialStrategy;

  const CreateProjectScreen({
    super.key, 
    this.initialDescription, 
    this.initialStrategy
  });

  @override
  ConsumerState<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  late TextEditingController _descCtrl;
  late TextEditingController _strategyCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(text: widget.initialDescription ?? '');
    _strategyCtrl = TextEditingController(text: widget.initialStrategy ?? '');
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _strategyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(createProjectControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'), 
            backgroundColor: Colors.red
          ),
        );
      }
    });

    final state = ref.watch(createProjectControllerProvider);

    return Scaffold(
      drawer: const Sidebar(currentPage: 'CreateProject'),
      appBar: AppBar(
        title: const Text("New AI Project"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: "Project Description",
                  hintText: "Make a marketing plan for a coffee shop",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _strategyCtrl,
                decoration: const InputDecoration(
                  labelText: "Strategy",
                  hintText: "Aggressive growth, low budget...",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: state.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: state.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Generate & Preview"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final proposal = await ref
          .read(createProjectControllerProvider.notifier)
          .generateProjectProposal(
            description: _descCtrl.text,
            strategy: _strategyCtrl.text,
          );

      if (mounted && proposal != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProjectReviewScreen(proposal: proposal),
          ),
        );
      }
    }
  }
}