import 'package:flutter/material.dart';
import '../models/user_data.dart';

class BMICalculator {
  static double calculateBMI(double height, double weight) {
    if (height <= 0 || weight <= 0) return 0;
    return weight / ((height / 100) * (height / 100));
  }

  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  static Color getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  static String getHealthAdvice(double bmi) {
    if (bmi < 18.5) {
      return 'You are underweight. Consider increasing your calorie intake with nutrient-rich foods.';
    } else if (bmi < 25) {
      return 'Great! You have a normal weight. Maintain your healthy lifestyle.';
    } else if (bmi < 30) {
      return 'You are overweight. Regular exercise and balanced diet can help.';
    } else {
      return 'Consult a healthcare provider for guidance on weight management.';
    }
  }

  static double calculateIdealWeight(double height, Gender gender) {
    // Simple ideal weight calculation
    if (gender == Gender.male) {
      return (height - 100) * 0.9;
    } else {
      return (height - 100) * 0.85;
    }
  }
}