import 'package:complete_auth/utils/constants/colors.dart';
import 'package:complete_auth/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  CustomTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.lightBlackColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: AppColors.lightBlackColor,
            fontSize: AppSizes.fontSm,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.lightPrimary,
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
                color: AppColors.lightBlackColor,
                width: AppSizes.borderWidth * 1.5),
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          filled: true,
          fillColor: AppColors.lightWhiteColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
        textTheme: TextTheme(
          displayMedium: GoogleFonts.poppins().copyWith(
            color: AppColors.lightPrimary,
          ),
          headlineLarge: GoogleFonts.poppins().copyWith(
            color: AppColors.lightPrimary,
            fontSize: AppSizes.fontLg,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: GoogleFonts.poppins().copyWith(
            color: AppColors.lightPrimary,
            fontSize: AppSizes.fontMd,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.poppins().copyWith(
            color: AppColors.lightBlackColor,
            fontSize: AppSizes.fontMd,
          ),
          bodySmall: GoogleFonts.poppins().copyWith(
            color: AppColors.lightBlackColor,
            fontSize: AppSizes.fontSm,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.lightWhiteColor,
          insetPadding: const EdgeInsets.all(25),
          contentTextStyle: GoogleFonts.poppins().copyWith(
            color: AppColors.lightBlackColor,
            fontSize: AppSizes.fontSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: GoogleFonts.poppins().copyWith(
              color: AppColors.lightPrimary,
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
  static ThemeData get darkTheme => ThemeData();
}
