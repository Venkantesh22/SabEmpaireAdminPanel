import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/job_model/job_model.dart';
import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field.
  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _decsController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  bool isLoading = false;

  final CollectionReference jobsCollection =
      FirebaseFirestore.instance.collection('Job');

  Future<void> deleteJob(String id, BuildContext context) async {
    await FirebaseFirestoreHelper.instance.deleteJob(id, context);
  }

  void editJob(String id, JobModel jobModel) {
    showDialog(
      context: context,
      builder: (context) {
        _jobNameController.text = jobModel.jobName;
        _decsController.text = jobModel.desc;
        _salaryController.text = jobModel.salary.toString();

        Future<void> _editJobSave(JobModel jobModel) async {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() {
              isLoading = true;
            });
            AppProvider appProvider =
                Provider.of<AppProvider>(context, listen: false);
            try {
              // Print old job name (optional debugging)
              print("Old job name: ${jobModel.jobName}");

              // Create new timestamp with updated info
              TimeStampModel time = TimeStampModel(
                id: jobModel.id,
                dateAndTime: GlobalVariable.today,
                updateBy: "Edit by Sab",
              );

              // Build a new job model with updated values from controllers.
              JobModel updatedJob = JobModel(
                id: jobModel.id,
                jobName: _jobNameController.text.trim(),
                desc: _decsController.text.trim(),
                salary: double.parse(_salaryController.text.trim()),
                timeStampModel: time,
              );

              // Now pass the updated job to your update function.
              await FirebaseFirestoreHelper.instance
                  .updateJob(updatedJob, context);

              // Reset form if needed.
              if (mounted) {
                _formKey.currentState?.reset();
              }
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error updating job: ${e.toString()}")),
              );
            } finally {
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop();
            }
          }
        }

        return AlertDialog(
          title: Text(
            "Edit Job",
            style: TextStyle(
                fontSize: Dimensions.dimenisonNo24,
                fontWeight: FontWeight.w600),
          ),
          // content:  Text('The salon is closed on the selected date.'),
          content: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.dimenisonNo16),
            child: SizedBox(
              width: Dimensions.screenWidth / 1.3,
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
                    ElevatedButton(
                      onPressed:
                          isLoading ? null : () => _editJobSave(jobModel),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: jobsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No jobs available'));
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              final jobModel =
                  JobModel.fromJson(job.data() as Map<String, dynamic>);
              final time = TimeStampModel.fromJson(
                  job['timeStampModel']); // Convert to TimeStampModel
              return Card(
                margin: EdgeInsets.all(Dimensions.dimenisonNo10),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.dimenisonNo10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            job['jobName'] ?? 'No Title',
                            style: TextStyle(
                              fontSize: Dimensions.dimenisonNo18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                              "${GlobalVariable.formatDateToString(time.dateAndTime)}, ${GlobalVariable.formatTimeToString(time.dateAndTime)}")
                        ],
                      ),
                      SizedBox(height: Dimensions.dimenisonNo5),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Dimensions.dimenisonNo5,
                          left: Dimensions.dimenisonNo12,
                          right: Dimensions.dimenisonNo12,
                          bottom: Dimensions.dimenisonNo10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${job['desc'] ?? 'N/A'}'),
                            SizedBox(height: Dimensions.dimenisonNo5),
                            Text('Salary: ${job['salary'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => editJob(job.id, jobModel),
                            child: Text('Edit'),
                          ),
                          TextButton(
                            onPressed: () => deleteJob(job.id, context),
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
