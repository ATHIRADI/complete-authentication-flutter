import 'package:complete_auth/utils/colors.dart';
import 'package:complete_auth/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  CustomTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: AppColors.Background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.Background,
          foregroundColor: AppColors.BlackColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          prefixIconColor: AppColors.Primary,
          hintStyle: const TextStyle(
            color: AppColors.BlackColor,
            fontSize: AppSizes.fontSm,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.Primary,
              width: AppSizes.borderWidth,
            ),
            borderRadius: BorderRadius.circular(
              AppSizes.borderRadius,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.errorColor,
              width: AppSizes.borderWidth,
            ),
            borderRadius: BorderRadius.circular(
              AppSizes.borderRadius,
            ),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: AppColors.BlackColor, width: AppSizes.borderWidth * 1.5),
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          filled: true,
          fillColor: AppColors.WhiteColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
        textTheme: TextTheme(
          displayMedium: GoogleFonts.poppins().copyWith(
            color: AppColors.Primary,
          ),
          headlineLarge: GoogleFonts.poppins().copyWith(
            color: AppColors.Primary,
            fontSize: AppSizes.fontLg,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: GoogleFonts.poppins().copyWith(
            color: AppColors.Primary,
            fontSize: AppSizes.fontMd,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.poppins().copyWith(
            color: AppColors.BlackColor,
            fontSize: AppSizes.fontMd,
          ),
          bodySmall: GoogleFonts.poppins().copyWith(
            color: AppColors.BlackColor,
            fontSize: AppSizes.fontSm,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.WhiteColor,
          insetPadding: const EdgeInsets.all(25),
          contentTextStyle: GoogleFonts.poppins().copyWith(
            color: AppColors.BlackColor,
            fontSize: AppSizes.fontSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: GoogleFonts.poppins().copyWith(
              color: AppColors.Primary,
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            iconSize: AppSizes.iconSm,
            foregroundColor: AppColors.Primary,
          ),
        ),
      );
}
