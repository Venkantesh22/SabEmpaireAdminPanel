import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/appoint/add_appoint/screen/add_new_appointment.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/models/user_enquiry_model/user_enquiry_model.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class UserEnquiryWidget extends StatefulWidget {
  final UserEnquiryModel userEnquiryModel;

  const UserEnquiryWidget({
    super.key,
    required this.userEnquiryModel,
  });

  @override
  State<UserEnquiryWidget> createState() => _UserEnquiryWidgetState();
}

class _UserEnquiryWidgetState extends State<UserEnquiryWidget> {
  final TextEditingController _reasonController = TextEditingController();

  void dispose() {
    super.dispose();
    _reasonController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _reasonController.text = widget.userEnquiryModel.reason!;
  }

  @override
  Widget build(BuildContext context) {
    return _buildUserContainer(widget.userEnquiryModel);
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    try {
      final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
      await launchUrl(whatsappUrl);
    } catch (e) {
      showBottonMessageError('Could not launch WhatsApp $e', context);
    }
  }

  Widget _buildUserContainer(UserEnquiryModel enquiry) {
    // Wrap ExpansionTile with a Container to apply border and rounded corners.
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        title: _buildTitle(enquiry),
        children: [
          // (Optional: add more details when expanded)
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            enquiry.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.dimenisonNo16,
                              fontWeight: FontWeight.bold,
                              height: 1.43,
                            ),
                          ),
                          Text(
                            enquiry.phone,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.dimenisonNo12,
                              fontWeight: FontWeight.w400,
                              height: 1.67,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.dimenisonNo8,
                          ),
                          Text.rich(
                            overflow: TextOverflow.fade,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Message : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.dimenisonNo14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                  ),
                                ),
                                TextSpan(
                                  text: enquiry.message,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.dimenisonNo12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.67,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.dimenisonNo8,
                          ),
                          Text.rich(
                            overflow: TextOverflow.fade,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Address : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.dimenisonNo14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                  ),
                                ),
                                TextSpan(
                                  text: enquiry.address,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.dimenisonNo12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.67,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.dimenisonNo8,
                          ),
                          if (enquiry.reason != null ||
                              enquiry.reason!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reason",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.dimenisonNo14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                  ),
                                ),
                                TextFormField(
                                  controller: _reasonController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Reason",
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            text: 'Add Appointment',
                            ontap: () {
                              Routes.instance.push(
                                  widget: AddNewAppointment(),
                                  context: context);
                            },
                            buttonColor: AppColor.buttonRedColor,
                          ),
                          SizedBox(
                            height: Dimensions.dimenisonNo16,
                          ),
                          CustomButton(
                            text: 'Enquiry',
                            ontap: () async {
                              showLoaderDialog(context);
                              UserEnquiryModel updateUserForm =
                                  enquiry.copyWith(
                                      state: GlobalVariable.justEnquiryState,
                                      reason: _reasonController.text);

                              await FirebaseFirestoreHelper.instance
                                  .updateSingleUserEnquiryForm(
                                      updateUserForm, context);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            buttonColor: AppColor.buttonRedColor,
                          ),
                        ],
                      ))
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildTitle(
    UserEnquiryModel enquiry,
  ) {
    return Row(
      children: [
        // User Avatar
        SizedBox(
          width: Dimensions.dimenisonNo50,
          child: CircleAvatar(
            radius: Dimensions.dimenisonNo20,
            backgroundColor: Colors.green[100],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
        ),
        SizedBox(width: Dimensions.dimenisonNo8),
        // User info (name and phone)
        SizedBox(
          width: Dimensions.dimenisonNo200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                enquiry.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.dimenisonNo16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                enquiry.phone,
                style: TextStyle(fontSize: Dimensions.dimenisonNo14),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Date and Time
        Column(
          children: [
            Text(
              DateFormat('hh:mm a').format(enquiry.timeStampModel.dateAndTime),
              style: TextStyle(fontSize: Dimensions.dimenisonNo14),
            ),
            Text(
              DateFormat('dd MMM yyyy')
                  .format(enquiry.timeStampModel.dateAndTime),
              style: TextStyle(fontSize: Dimensions.dimenisonNo14),
            ),
          ],
        ),
        const Spacer(),
        // "Call" Button
        CustomButton(
          text: "Call",
          ontap: () {
            openWhatsApp(enquiry.phone);
          },
          buttonColor: enquiry.state == GlobalVariable.pendingState
              ? AppColor.buttonRedColor
              : AppColor.greenColor,
        ),
        SizedBox(width: Dimensions.dimenisonNo16),
      ],
    );
  }
}
