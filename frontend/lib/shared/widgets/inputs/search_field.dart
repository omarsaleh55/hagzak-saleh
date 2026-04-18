import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.hint = AppStrings.searchHint,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      style: AppTextStyles.bodyMd,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textHint),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textSecondary,
          size: AppDimensions.iconMd,
        ),
        suffixIcon: controller != null && (controller!.text.isNotEmpty)
            ? IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: AppDimensions.iconMd,
                ),
                color: AppColors.textSecondary,
                onPressed: () {
                  controller!.clear();
                  onChanged?.call('');
                },
              )
            : const Icon(
                Icons.tune_rounded,
                color: AppColors.textSecondary,
                size: AppDimensions.iconMd,
              ),
      ),
    );
  }
}
