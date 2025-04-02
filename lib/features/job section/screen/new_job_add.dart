import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/models/job_model/job_model.dart';
import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:provider/provider.dart';

class JobAddPage extends StatefulWidget {
  const JobAddPage({super.key});

  @override
  State<JobAddPage> createState() => _JobAddPageState();
}

class _JobAddPageState extends State<JobAddPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field.
  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _decsController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  bool isLoading = false;
  bool isLoadingPage = false;

  Future<void> _saveJob() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      AppProvider appProvider =
          Provider.of<AppProvider>(context, listen: false);
      try {
        TimeStampModel time = TimeStampModel(
            id: "", dateAndTime: GlobalVariable.today, updateBy: "Sab");

        JobModel job = JobModel(
            id: '',
            jobName: _jobNameController.text.trim(),
            desc: _decsController.text.trim(),
            salary: double.parse(_salaryController.text.trim()),
            timeStampModel: time);

        await FirebaseFirestoreHelper.instance.createJob(job, context);

        if (mounted) {
          _formKey.currentState?.reset();
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving footer: ${e.toString()}")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    _decsController.dispose();
    _salaryController.dispose();

    super.dispose();
  }

  // Simple URL validation: checks if it starts with "http" or "https"
  String? _validateUrl(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Please enter $fieldName URL";
    }
    if (!value.startsWith("http://") && !value.startsWith("https://")) {
      return "Please enter a valid URL for $fieldName";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New job"),
        backgroundColor: AppColor.whiteColor,
      ),
      body: isLoadingPage
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.dimenisonNo16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _jobNameController,
                      decoration: const InputDecoration(
                        hintText: "Enter job name",
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Please enter about job name"
                          : null,
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _decsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "description ",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description";
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _salaryController,
                      decoration: const InputDecoration(
                        labelText: "Salary",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an Salary";
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    ElevatedButton(
                      onPressed: isLoading ? null : _saveJob,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonRedColor,
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimenisonNo16),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Job",
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
