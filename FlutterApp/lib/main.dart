import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InputData {
  final int age;
  final int gender;
  final int ethnicity;
  final int parentalEducation;
  final double studyTimeWeekly;
  final int absences;
  final int tutoring;
  final int parentalSupport;
  final int extracurricular;
  final int sports;
  final int music;
  final int volunteering;

  InputData({
    required this.age,
    required this.gender,
    required this.ethnicity,
    required this.parentalEducation,
    required this.studyTimeWeekly,
    required this.absences,
    required this.tutoring,
    required this.parentalSupport,
    required this.extracurricular,
    required this.sports,
    required this.music,
    required this.volunteering,
  });

  Map<String, dynamic> toJson() {
    return {
      'Age': age,
      'Gender': gender,
      'Ethnicity': ethnicity,
      'ParentalEducation': parentalEducation,
      'StudyTimeWeekly': studyTimeWeekly,
      'Absences': absences,
      'Tutoring': tutoring,
      'ParentalSupport': parentalSupport,
      'Extracurricular': extracurricular,
      'Sports': sports,
      'Music': music,
      'Volunteering': volunteering,
    };
  }
}

Future<double> getPredictedGPA(InputData data) async {
  final url = Uri.parse('https://ml-summative-0cuq.onrender.com/predict');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data.toJson()),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['predicted_GPA'];
  } else {
    throw Exception('Failed to load prediction');
  }
}

class PredictionPageState extends State<PredictionPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  final TextEditingController _parentalEducationController =
      TextEditingController();
  final TextEditingController _studyTimeController = TextEditingController();
  final TextEditingController _absencesController = TextEditingController();
  final TextEditingController _tutoringController = TextEditingController();
  final TextEditingController _parentalSupportController =
      TextEditingController();
  final TextEditingController _extracurricularController =
      TextEditingController();
  final TextEditingController _sportsController = TextEditingController();
  final TextEditingController _musicController = TextEditingController();
  final TextEditingController _volunteeringController = TextEditingController();

  String _predictedGPA = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPA Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_ageController, 'Age (15-18)', 'Enter your age'),
              SizedBox(height: 16),
              _buildTextField(
                _genderController,
                'Gender (0=Male, 1=Female)',
                'Enter 0 for Male, 1 for Female',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _ethnicityController,
                'Ethnicity (0=Caucasian, 1=African American, 2=Asian, 3=Other)',
                'Enter a number representing your ethnicity',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _parentalEducationController,
                'Parental Education (0=None, 1=High School, 2=Some College, 3=Bachelor\'s, 4=Higher)',
                'Enter a number for parental education level',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _studyTimeController,
                'Study Time Weekly (0-20 hours)',
                'Enter weekly study time in hours',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _absencesController,
                'Absences (0-30)',
                'Enter the number of absences',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _tutoringController,
                'Tutoring (0=No, 1=Yes)',
                'Enter 0 for No, 1 for Yes',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _parentalSupportController,
                'Parental Support (0=None, 1=Low, 2=Moderate, 3=High, 4=Very High)',
                'Enter a number for level of parental support',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _extracurricularController,
                'Extracurricular (0=No, 1=Yes)',
                'Enter 0 for No, 1 for Yes',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _sportsController,
                'Sports (0=No, 1=Yes)',
                'Enter 0 for No, 1 for Yes',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _musicController,
                'Music (0=No, 1=Yes)',
                'Enter 0 for No, 1 for Yes',
              ),
              SizedBox(height: 16),
              _buildTextField(
                _volunteeringController,
                'Volunteering (0=No, 1=Yes)',
                'Enter 0 for No, 1 for Yes',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    Colors.blueAccent,
                  ),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
                onPressed: () async {
                  final inputData = InputData(
                    age: int.tryParse(_ageController.text) ?? 0,
                    gender: int.tryParse(_genderController.text) ?? 0,
                    ethnicity: int.tryParse(_ethnicityController.text) ?? 0,
                    parentalEducation:
                        int.tryParse(_parentalEducationController.text) ?? 0,
                    studyTimeWeekly:
                        double.tryParse(_studyTimeController.text) ?? 0,
                    absences: int.tryParse(_absencesController.text) ?? 0,
                    tutoring: int.tryParse(_tutoringController.text) ?? 0,
                    parentalSupport:
                        int.tryParse(_parentalSupportController.text) ?? 0,
                    extracurricular:
                        int.tryParse(_extracurricularController.text) ?? 0,
                    sports: int.tryParse(_sportsController.text) ?? 0,
                    music: int.tryParse(_musicController.text) ?? 0,
                    volunteering:
                        int.tryParse(_volunteeringController.text) ?? 0,
                  );

                  try {
                    final predictedGPA = await getPredictedGPA(inputData);
                    setState(() {
                      _predictedGPA = predictedGPA.toStringAsFixed(2);
                    });
                  } catch (e) {
                    setState(() {
                      _predictedGPA = 'Error: $e';
                    });
                  }
                },
                child: Text('Predict GPA'),
              ),
              SizedBox(height: 20),
              Text(
                _predictedGPA.isEmpty ? '' : 'Predicted GPA: $_predictedGPA',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});
  @override
  PredictionPageState createState() => PredictionPageState();
}

void main() {
  runApp(MaterialApp(home: PredictionPage()));
}
