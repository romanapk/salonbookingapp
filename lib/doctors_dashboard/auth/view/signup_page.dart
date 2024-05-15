import '../../../admin_dashboard/bottombar_screen.dart';
import '../../general/consts/consts.dart';
import '../../widgets/coustom_textfield.dart';
import '../controller/signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SignupController());
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset(
                    AppAssets.imgWelcome,
                    width: context.screenHeight * .23,
                  ),
                  const SizedBox(height: 8),
                  AppString.signupNow.text
                      .size(AppFontSize.size18)
                      .semiBold
                      .make()
                ],
              ),
              const SizedBox(height: 15),
              Form(
                key: controller.formkey,
                child: Column(
                  children: [
                    CoustomTextField(
                      textcontroller: controller.nameController,
                      hint: AppString.fullName,
                      icon: const Icon(Icons.person),
                      validator: controller.validname,
                    ),
                    const SizedBox(height: 15),
                    CoustomTextField(
                      textcontroller: controller.phoneController,
                      icon: const Icon(Icons.phone),
                      hint: "Enter your phone number",
                    ),
                    const SizedBox(height: 15),
                    CoustomTextField(
                      textcontroller: controller.emailController,
                      icon: const Icon(Icons.email_rounded),
                      hint: AppString.emailHint,
                      validator: controller.validateemail,
                    ),
                    const SizedBox(height: 15),
                    CoustomTextField(
                      textcontroller: controller.passwordController,
                      icon: const Icon(Icons.key),
                      hint: AppString.passwordHint,
                      validator: controller.validpass,
                    ),
                    15.heightBox,
                    GestureDetector(
                      onTapDown: (details) {
                        controller.showDropdownMenu(context);
                      },
                      child: TextFormField(
                        controller: controller.categoryController,
                        readOnly: true,
                        onTap: () {
                          controller.showDropdownMenu(context);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Select Category',
                          prefixIcon: Icon(Icons.more_vert),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          border: OutlineInputBorder(borderSide: BorderSide()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: controller.timeController,
                      readOnly: true,
                      onTap: () {
                        _selectServiceTime(context, controller);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select Service Time',
                        prefixIcon: Icon(Icons.timer),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CoustomTextField(
                      textcontroller: controller.aboutController,
                      icon: const Icon(Icons.person_rounded),
                      hint: "write something about yourself",
                      validator: controller.validfield,
                    ),
                    const SizedBox(height: 15),
                    CoustomTextField(
                      textcontroller: controller.addressController,
                      icon: const Icon(Icons.home_rounded),
                      hint: "write your address",
                      validator: controller.validfield,
                    ),
                    const SizedBox(height: 15),
                    CoustomTextField(
                      textcontroller: controller.serviceController,
                      icon: const Icon(Icons.type_specimen),
                      hint: "write something about your service",
                      validator: controller.validfield,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: context.screenWidth * .7,
                      height: 44,
                      child: Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primeryColor,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () async {
                            await controller.signupUser(context);
                            if (controller.userCredential != null) {
                              Get.offAll(() => AdminHomeScreen());
                            }
                          },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : const Text("Signup"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppString.alreadyHaveAccount.text.make(),
                        const SizedBox(width: 8),
                        AppString.login.text.make().onTap(() {
                          Get.back();
                        }),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectServiceTime(BuildContext context, SignupController controller) {
    DateTime currentTime = DateTime.now();
    DateTime initialStartTime = currentTime;
    DateTime initialEndTime = currentTime.add(const Duration(
        hours: 1)); // Initial end time is 1 hour after the current time

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Service Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTimePicker(
                context,
                initialStartTime,
                (time) {
                  initialStartTime = time;
                },
                'Start Time',
              ),
              const SizedBox(height: 16),
              _buildTimePicker(
                context,
                initialEndTime,
                (time) {
                  initialEndTime = time;
                },
                'End Time',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String formattedStartTime =
                    "${initialStartTime.hour}:${initialStartTime.minute}";
                String formattedEndTime =
                    "${initialEndTime.hour}:${initialEndTime.minute}";
                controller.timeController.text =
                    '$formattedStartTime to $formattedEndTime';
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimePicker(BuildContext context, DateTime initialTime,
      Function(DateTime) onTimeChanged, String labelText) {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialTime),
        );
        if (pickedTime != null) {
          onTimeChanged(DateTime(
            initialTime.year,
            initialTime.month,
            initialTime.day,
            pickedTime.hour,
            pickedTime.minute,
          ));
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        child: Text(
          '${initialTime.hour}:${initialTime.minute}',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}

// import '../../../admin_dashboard/bottombar_screen.dart';
// import '../../general/consts/consts.dart';
// import '../../widgets/coustom_textfield.dart';
// import '../controller/signup_controller.dart';
//
// class SignupView extends StatelessWidget {
//   const SignupView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(SignupController());
//     return Scaffold(
//       body: Container(
//         margin: const EdgeInsets.only(top: 15),
//         padding: const EdgeInsets.all(8),
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   Image.asset(
//                     AppAssets.imgWelcome,
//                     width: context.screenHeight * .23,
//                   ),
//                   8.heightBox,
//                   AppString.signupNow.text
//                       .size(AppFontSize.size18)
//                       .semiBold
//                       .make()
//                 ],
//               ),
//               15.heightBox,
//               Form(
//                 key: controller.formkey,
//                 child: Column(
//                   children: [
//                     CoustomTextField(
//                       textcontroller: controller.nameController,
//                       hint: AppString.fullName,
//                       icon: const Icon(Icons.person),
//                       validator: controller.validname,
//                     ),
//                     15.heightBox,
//                     CoustomTextField(
//                       textcontroller: controller.phoneController,
//                       icon: const Icon(Icons.phone),
//                       hint: "Enter your phone number",
//                     ),
//                     15.heightBox,
//                     CoustomTextField(
//                       textcontroller: controller.emailController,
//                       icon: const Icon(Icons.email_rounded),
//                       hint: AppString.emailHint,
//                       validator: controller.validateemail,
//                     ),
//                     15.heightBox,
//                     CoustomTextField(
//                       textcontroller: controller.passwordController,
//                       icon: const Icon(Icons.key),
//                       hint: AppString.passwordHint,
//                       validator: controller.validpass,
//                     ),
//                     15.heightBox,
//                     GestureDetector(
//                       onTapDown: (details) {
//                         controller.showDropdownMenu(context);
//                       },
//                       child: TextFormField(
//                         controller: controller.categoryController,
//                         readOnly: true,
//                         onTap: () {
//                           controller.showDropdownMenu(context);
//                         },
//                         decoration: const InputDecoration(
//                           labelText: 'Select Category',
//                           prefixIcon: Icon(Icons.more_vert),
//                           suffixIcon: Icon(Icons.arrow_drop_down),
//                           border: OutlineInputBorder(borderSide: BorderSide()),
//                         ),
//                       ),
//                     ),
//                     15.heightBox,
//                     CoustomTextField(
//                       textcontroller: controller.timeController,
//                       icon: const Icon(Icons.timer),
//                       hint: "write your service time",
//                       validator: controller.validfield,
//                     ),
//                     15.heightBox,
//                     CoustomTextField(
//                       textcontroller: controller.aboutController,
//                       icon: const Icon(Icons.person_rounded),
//                       hint: "write some thing yourself",
//                       validator: controller.validfield,
//                     ),
//                     15.heightBox,
//                     CoustomTextField(
//                       textcontroller: controller.addressController,
//                       icon: const Icon(Icons.home_rounded),
//                       hint: "write your address",
//                       validator: controller.validfield,
//                     ),
//                     15.heightBox,
//                     CoustomTextField(
//                       textcontroller: controller.serviceController,
//                       icon: const Icon(Icons.type_specimen),
//                       hint: "write some thing about your service",
//                       validator: controller.validfield,
//                     ),
//                     20.heightBox,
//                     SizedBox(
//                       width: context.screenWidth * .7,
//                       height: 44,
//                       child: Obx(
//                         () => ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primeryColor,
//                               shape: const StadiumBorder(),
//                             ),
//                             onPressed: () async {
//                               await controller.signupUser(context);
//                               if (controller.userCredential != null) {
//                                 Get.offAll(() => AdminHomeScreen());
//                               }
//                             },
//                             child: controller.isLoading.value
//                                 ? const CircularProgressIndicator()
//                                 : const Text("Signup")
//                             // ? const LoadingIndicator()
//                             // : AppString.signup.text.white.make(),
//                             ),
//                       ),
//                     ),
//                     20.heightBox,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AppString.alreadyHaveAccount.text.make(),
//                         8.widthBox,
//                         AppString.login.text.make().onTap(() {
//                           Get.back();
//                         }),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
