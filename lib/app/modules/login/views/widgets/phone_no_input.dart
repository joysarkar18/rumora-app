import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInputField extends StatefulWidget {
  final Function(String phoneNumber)? onChanged;
  final String? initialPhoneNumber;

  const PhoneNumberInputField({
    super.key,
    this.onChanged,
    this.initialPhoneNumber,
  });

  @override
  State<PhoneNumberInputField> createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);

    _phoneController.addListener(() {
      // Close keyboard when 10 digits are entered
      if (_phoneController.text.length == 10) {
        FocusScope.of(context).unfocus();
      }

      if (widget.onChanged != null) {
        widget.onChanged!(_phoneController.text);
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Fixed Country Code for India
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Row(
            children: const [
              Text(
                '+91',
                style: TextStyle(
                  color: Color(0xFFB91C4C),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Phone Number Input
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              cursorHeight: 27,
              cursorColor: AppColors.primary,
              cursorRadius: Radius.circular(4),
              cursorWidth: 2.4,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20, right: 20, top: 3),
                hintText: '0000000000',
                hintStyle: TextStyle(
                  color: Color(0xFFE5A3B3),
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
