import 'package:salonbookingapp/Utils/app_style.dart';
import 'package:salonbookingapp/general/consts/consts.dart';
import 'package:salonbookingapp/stylist_dashboard/auth/controller/signup_controller.dart';

import '../widgets/custom_new.dart';

class StylistProfileScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  StylistProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        title: "Profile".text.make(),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await controller.signout();
              Get.offAllNamed(
                  '/login'); // Navigate to login screen after signout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('pendingStylists')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                child: "No profile data found".text.make(),
              );
            } else {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              controller.nameController.text = data['stylistName'] ?? '';
              controller.phoneController.text = data['stylistPhone'] ?? '';
              controller.emailController.text = data['stylistEmail'] ?? '';
              controller.categoryController.text =
                  data['stylistCategory'] ?? '';
              controller.timeController.text = data['stylistTiming'] ?? '';
              controller.basePriceController.text = data['stylistAbout'] ?? '';
              controller.addressController.text = data['stylistAddress'] ?? '';
              controller.serviceController.text = data['stylistService'] ?? '';

              return Form(
                key: controller.formkey,
                child: ListView(
                  children: [
                    CoustomTextField(
                      controller: controller.nameController,
                      hint: 'Name',
                      label: 'Name',
                      validator: controller.validname,
                    ),
                    10.heightBox,
                    CoustomTextField(
                      controller: controller.phoneController,
                      hint: 'Phone',
                      label: 'Phone',
                      validator: controller.validfield,
                    ),
                    10.heightBox,
                    CoustomTextField(
                      controller: controller.emailController,
                      hint: 'Email',
                      label: 'Email',
                      validator: controller.validateemail,
                      readOnly: true, // Email should be read-only
                    ),
                    10.heightBox,
                    CoustomTextField(
                      controller: controller.categoryController,
                      hint: 'Category',
                      label: 'Category',
                      validator: controller.validfield,
                    ),
                    10.heightBox,
                    CoustomTextField(
                      controller: controller.timeController,
                      hint: 'Available Timing',
                      label: 'Available Timing',
                      validator: controller.validfield,
                    ),
                    10.heightBox,
                    CoustomTextField(
                      controller: controller.basePriceController,
                      hint: 'Base Price',
                      label: 'Base Price',
                      validator: controller.validfield,
                    ),
                    10.heightBox,
                    CoustomTextField(
                      controller: controller.addressController,
                      hint: 'Address',
                      label: 'Address',
                      validator: controller.validfield,
                    ),
                    10.heightBox,
                    CoustomTextField(
                      controller: controller.serviceController,
                      hint: 'Home Service (Yes/No)',
                      label: 'Home Service (Yes/No)',
                      validator: controller.validfield,
                    ),
                    20.heightBox,
                    Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator().centered()
                          : ElevatedButton(
                              onPressed: () async {
                                if (controller.formkey.currentState!
                                    .validate()) {
                                  controller.isLoading(true);
                                  await FirebaseFirestore.instance
                                      .collection('pendingStylists')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    'stylistName':
                                        controller.nameController.text,
                                    'stylistPhone':
                                        controller.phoneController.text,
                                    'stylistCategory':
                                        controller.categoryController.text,
                                    'stylistTiming':
                                        controller.timeController.text,
                                    'stylistAbout':
                                        controller.basePriceController.text,
                                    'stylistAddress':
                                        controller.addressController.text,
                                    'stylistService':
                                        controller.serviceController.text,
                                  });
                                  controller.isLoading(false);
                                  VxToast.show(context,
                                      msg: "Profile updated successfully");
                                }
                              },
                              child: "Update Profile".text.make(),
                            );
                    }),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
