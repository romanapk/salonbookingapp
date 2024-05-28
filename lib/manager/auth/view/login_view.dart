import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonbookingapp/general/consts/colors.dart';

import '../../../general/consts/strings.dart';
import '../../../stylist_dashboard/widgets/coustom_textfield.dart';
import '../../manager_home_screen.dart';
import '../controller/login_controller.dart';

class ManagerLoginView extends StatelessWidget {
  const ManagerLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ManagerLoginController());
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f6),
      body: Container(
        margin: const EdgeInsets.only(top: 35),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Image.asset('assets/manager_login.png', width: 150),
            SizedBox(height: 15),
            Text("Admin Login", style: TextStyle(fontSize: 24)),
            SizedBox(height: 15),
            Form(
              key: controller.formkey,
              child: Column(
                children: [
                  CoustomTextField(
                    textcontroller: controller.emailController,
                    icon: const Icon(Icons.email_rounded),
                    hint: AppString.emailHint,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.endsWith('.com')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  CoustomTextField(
                    textcontroller: controller.passwordController,
                    icon: const Icon(Icons.lock),
                    hint: "Password",
                    obscureText: !controller.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    height: 44,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primeryColor,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () async {
                          await controller.loginManager(context);
                          if (controller.isLoggedIn) {
                            Get.offAll(() => ManagerHomeScreen());
                          }
                        },
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text("Login"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
