import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/palette.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        height: 46.h,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            _customRadioButton,
            SizedBox(width: 10.w),
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? Palette.primaryColor : null,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? Palette.primaryColor : Colors.grey[300]!,
          width: 2.w,
        ),
      ),
      child: Text(
        leading,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600]!,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}
