import 'package:latlong2/latlong.dart';
import 'package:salonbookingapp/stylist_dashboard/auth/view/message.dart';

import '../../general/consts/consts.dart';
import '../../widgets/coustom_textfield.dart';
import '../addresspicker.dart';
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Please enter alphabets only';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CoustomTextField(
                      textcontroller: controller.phoneController,
                      icon: const Icon(Icons.phone),
                      hint: "Enter your phone number",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^[0-9+\-]+$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    Obx(
                      () => CoustomTextField(
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
                      textcontroller: controller.basePriceController,
                      icon: const Icon(Icons.attach_money),
                      hint: "Base Price",
                      prefixText: "PKR ",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your base price';
                        }
                        final priceRegExp = RegExp(r'^[0-9]+$');
                        if (!priceRegExp.hasMatch(value)) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: CoustomTextField(
                            textcontroller: controller.addressController,
                            icon: const Icon(Icons.home_rounded),
                            hint: "Write your address",
                            validator: controller.validfield,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () async {
                            LatLng? location = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressPickerMap(),
                              ),
                            );
                            if (location != null) {
                              controller.addressController.text =
                                  '${location.latitude}, ${location.longitude}';
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: controller.serviceController.text.isNotEmpty
                          ? controller.serviceController.text
                          : null,
                      onChanged: (value) {
                        controller.serviceController.text = value!;
                      },
                      items: [
                        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                        DropdownMenuItem(value: 'No', child: Text('No')),
                      ],
                      decoration: const InputDecoration(
                        labelText: "Available for home services?",
                        prefixIcon: Icon(Icons.check_circle_outline),
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
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
                              Get.offAll(() => MessagePage());
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
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
