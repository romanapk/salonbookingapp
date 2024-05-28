import 'package:salonbookingapp/customer_dashboard/auth/controller/signup_controller.dart';
import 'package:salonbookingapp/customer_dashboard/widgets/loading_indicator.dart';
import 'package:salonbookingapp/splash_screen/splashscreen.dart';

import '../../Utils/app_style.dart';
import '../../general/consts/consts.dart';
import '../../stylist_dashboard/widgets/coustom_textfield.dart';

class ProfileScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Styles.bgColor,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 35),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Column(
              children: [
                Image.asset(
                  AppAssets.imgWelcome,
                  width: context.screenHeight * .23,
                ),
                8.heightBox,
                'Profile'.text.size(AppFontSize.size18).semiBold.make(),
              ],
            ),
            15.heightBox,
            Expanded(
              flex: 2,
              child: Form(
                key: controller.formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CoustomTextField(
                        textcontroller: controller.nameController,
                        hint: 'Full Name',
                        icon: const Icon(Icons.person),
                        validator: controller.validname,
                      ),
                      15.heightBox,
                      CoustomTextField(
                        textcontroller: controller.emailController,
                        icon: const Icon(Icons.email_outlined),
                        hint: 'Email',
                        validator: controller.validateemail,
                      ),
                      15.heightBox,
                      Obx(() => CoustomTextField(
                            textcontroller: controller.passwordController,
                            icon: const Icon(Icons.lock),
                            hint: 'Password',
                            obscureText: !controller.isPasswordVisible.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                controller.togglePasswordVisibility();
                              },
                            ),
                            validator: controller.validpass,
                          )),
                      20.heightBox,
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
                              if (controller.formkey.currentState!.validate()) {
                                await controller.updateUser(context);
                              }
                            },
                            child: controller.isLoading.value
                                ? const LoadingIndicator()
                                : 'Update Profile'.text.white.make(),
                          ),
                        ),
                      ),
                      20.heightBox,
                      SizedBox(
                        width: context.screenWidth * .7,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primeryColor,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () async {
                            await controller.signout();
                            Get.offAll(() => SalonSplashScreen());
                          },
                          child: 'Logout'.text.white.make(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
