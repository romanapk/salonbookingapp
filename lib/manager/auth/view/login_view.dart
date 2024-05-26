import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../customer_dashboard/widgets/text_field_header.dart';
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
            SizedBox(height: 20),
            Text("Manager Login", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Form(
              key: controller.formkey,
              child: Column(
                children: [
                  CustomTextField(
                    validator: controller.validateEmail,
                    textController: controller.emailController,
                    icon: Icons.email_outlined,
                    hint: "Manager Email",
                  ),
                  SizedBox(height: 18),
                  CustomTextField(
                    validator: controller.validatePassword,
                    textController: controller.passwordController,
                    icon: Icons.key,
                    hint: "Manager Password",
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    height: 44,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
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
