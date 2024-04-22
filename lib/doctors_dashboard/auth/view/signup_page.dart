import '../../general/consts/consts.dart';
import '../../widgets/coustom_textfield.dart';
import '../controller/signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

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
                  8.heightBox, // Assuming this is a custom spacing method
                  AppString.signupNow.text
                      .size(AppFontSize.size18)
                      .semiBold
                      .make()
                ],
              ),
              15.heightBox, // Assuming this is a custom spacing method

              // Stylist Type Selection (Radio or Dropdown)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register as a:",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textcolor, // Corrected: Added semicolon
                    ),
                  ),
                  8.widthBox, // Assuming this is a custom spacing method
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Stylist',
                        groupValue: controller.stylistType.value,
                        onChanged: (value) =>
                            controller.stylistType.value = value!,
                      ),
                      Text('Stylist'),
                      8.widthBox, // Assuming this is a custom spacing method
                      Radio<String>(
                        value: 'Salon',
                        groupValue: controller.stylistType.value,
                        onChanged: (value) =>
                            controller.stylistType.value = value!,
                      ),
                      Text('Salon'),
                    ],
                  ),
                ],
              ),
              15.heightBox, // Assuming this is a custom spacing method

              Form(
                key: controller.formkey,
                child: Column(
                  children: [
                    CoustomTextField(
                      // Assuming this custom widget is defined
                      textcontroller: controller.nameController,
                      hint: AppString.fullName,
                      icon: const Icon(Icons.person),
                      validator: controller.validname,
                    ),
                    // Removed extra semicolon
                    15.heightBox, // Assuming this is a custom spacing method
                    CoustomTextField(
                      textcontroller: controller.phoneController,
                      icon: const Icon(Icons.phone),
                      hint: "Enter your phone number",
                    ), // Assuming this is a custom spacing method
                    CoustomTextField(
                      textcontroller: controller.emailController,
                      icon: const Icon(Icons.email_rounded),
                      hint: AppString.emailHint,
                      validator: controller.validateemail,
                    ),
                    15.heightBox, // Assuming this is a custom spacing method
                    CoustomTextField(
                      textcontroller: controller.passwordController,
                      icon: const Icon(Icons.key),
                      hint: AppString.passwordHint,
                      validator: controller.validpass,
                    ),
                    15.heightBox, // Assuming this is a custom spacing method
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
                    15.heightBox, // Assuming this is a custom spacing method
                    CoustomTextField(
                      textcontroller: controller.timeController,
                      icon: const Icon(Icons.timer),
                      hint: "write your service time",
                      validator: controller.validfield,
                    ),
                    15.heightBox, // Assuming this is a custom spacing method
                    CoustomTextField(
                      textcontroller: controller.aboutController,
                      icon: const Icon(Icons.person_rounded),
                      hint: "write something about yourself",
                      validator: controller.validfield,
                    ),
                    15.heightBox, // Assuming this is a custom spacing method
                    CoustomTextField(
                      textcontroller: controller.addressController,
                      icon: const Icon(Icons.home_rounded),
                      hint: "write your address",
                      validator: controller.validfield,
                    ),
                    15.heightBox, // Assuming this is a custom spacing method
                    CoustomTextField(
                      textcontroller: controller.serviceController,
                      icon: const Icon(Icons.type_specimen),
                      hint: "write something about your service",
                      validator: controller.validfield,
                    ),
                    15.heightBox, // Assuming this is a custom spacing method

                    // In-home service option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Offers Home Service",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textcolor,
                          ),
                        ),
                        Switch(
                          value: controller.offersHomeService.value,
                          onChanged: (value) =>
                              controller.offersHomeService.value = value,
                        ),
                      ],
                    ),

                    // Signup button
                    15.heightBox, // Assuming this is a custom spacing method
                    Obx(
                      () => controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () =>
                                  controller.signupStylist(context),
                              child: Text(AppString.signupNow),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primeryColor,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
