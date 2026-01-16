import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';

class ProfileSaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileSaveButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallet.mainColor,
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 15.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          'Save',
          style: TextStyle(
            color: AppPallet.whiteColor,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
