import 'package:flutter/material.dart';
import '../widgets/gender_selector.dart';
import '../widgets/height_selector.dart';
import '../widgets/weight_age_selector.dart';
import '../widgets/bmi_card.dart';
import '../utils/bmi_calculator.dart';
import '../models/user_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserData userData = UserData();
  double _bmi = 0;
  String _category = 'Normal';
  Color _bmiColor = Colors.green;
  String _advice = 'Enter your details to calculate BMI';

  void _calculateBMI() {
    final bmi = BMICalculator.calculateBMI(userData.height, userData.weight);
    final category = BMICalculator.getBMICategory(bmi);
    final color = BMICalculator.getBMIColor(bmi);
    final advice = BMICalculator.getHealthAdvice(bmi);

    setState(() {
      _bmi = bmi;
      _category = category;
      _bmiColor = color;
      _advice = advice;
    });

    _showResultDialog(bmi, category);
  }

  void _showResultDialog(double bmi, String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('BMI Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BMI: ${bmi.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _bmiColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Category: $category',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(_advice),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitCalc'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BMI Result Card
              BMICard(
                bmi: _bmi,
                category: _category,
                color: _bmiColor,
                advice: _advice,
              ),
              const SizedBox(height: 24),
              // Gender Selector
              GenderSelector(
                selectedGender: userData.gender,
                onGenderChanged: (gender) {
                  setState(() => userData.gender = gender);
                },
              ),
              const SizedBox(height: 24),
              // Height Selector
              HeightSelector(
                height: userData.height,
                onHeightChanged: (height) {
                  setState(() => userData.height = height);
                },
              ),
              const SizedBox(height: 24),
              // Weight & Age Selector
              WeightAgeSelector(
                weight: userData.weight,
                age: userData.age,
                onWeightChanged: (weight) {
                  setState(() => userData.weight = weight);
                },
                onAgeChanged: (age) {
                  setState(() => userData.age = age);
                },
              ),
              const SizedBox(height: 32),
              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'CALCULATE BMI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Ideal Weight Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ideal Weight',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'For your height (${userData.height.toStringAsFixed(0)} cm), '
                            'ideal weight is ${BMICalculator.calculateIdealWeight(userData.height, userData.gender).toStringAsFixed(1)} kg',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Footer
              const Center(
                child: Text(
                  'Note: BMI is a screening tool, not a diagnostic measure.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}