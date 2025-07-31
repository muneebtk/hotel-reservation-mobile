import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constant/styles/sizedbox.dart';
import '../../../../../constant/styles/textstyle.dart';
import '../../../../../controller/api/profile_management/profile_user_api.dart';

class PersonalInfoForm extends StatelessWidget {
  PersonalInfoForm({super.key});

  final PersonalInfoController controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    ProfileUserApi profileUserController = Get.find();

    if (profileUserController.userData.value.gender.isNotEmpty) {
      controller.selectedGender.value =
          profileUserController.userData.value.gender;
    }

    if (profileUserController.userData.value.dateofbirth.isNotEmpty) {
      controller.selectedDOB.value =
          profileUserController.userData.value.dateofbirth;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//?------------------------------------------------------------------------------

        Text(
          "Gender *".tr,
          style: textBoldblack,
        ),
        height10,

        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Select Gender'.tr;
            }
            return null;
          },
          icon: const Icon(Icons.keyboard_arrow_down),
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          value: controller.selectedGender.value,
          hint: Text('Select Gender'.tr),
          onChanged: (String? newValue) {
            controller.selectedGender.value = newValue;
          },
          items: <String>["Male", "Female", "Other"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.tr),
            );
          }).toList(),
        ),

        height10,

        //?------------------------------------------------------------------------------

        Text(
          "Date of birth *".tr,
          style: textBoldblack,
        ),
        height10,
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
             String formattedDate =
                '${pickedDate!.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
            controller.selectedDOB.value = formattedDate; 
            }
          },
          child: AbsorbPointer(
            child: Obx(
              () => TextFormField(
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Date of birth".tr;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    hintText: "Enter Date of birth".tr,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                controller: TextEditingController(
                    text: profileUserController.userData.value.dateofbirth !=
                            "1500-01-01"
                        ? controller.selectedDOB.value
                        : controller.selectedDOB.value),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PersonalInfoController extends GetxController {
  var selectedGender = RxnString();
  var selectedDOB = ''.obs;
  var selectedNationality = "".obs;
  var selectedCountry = "".obs;
  var selectedFamilyStatus = RxnString();
}
