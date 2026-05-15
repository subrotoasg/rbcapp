import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/person_model.dart';
import '../providers/village_provider.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({super.key});

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _facebookController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();
  final _dobController = TextEditingController();
  final _dodController = TextEditingController();
  final _nidController = TextEditingController();
  final _profileImageController = TextEditingController();

  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _fatherId;
  String? _motherId;

  final List<String> _genders = ['Male', 'Female'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _whatsappController.dispose();
    _facebookController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    _dobController.dispose();
    _dodController.dispose();
    _nidController.dispose();
    _profileImageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required TextEditingController controller,
    required bool isPastOnly,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: isPastOnly ? DateTime.now() : DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text = pickedDate.toString().split(' ')[0];
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<VillageProvider>(context, listen: false);
final authController = context.read<AuthController>();
  final user = authController.user;
  

    final String userToken = user?.token ?? "";

    final Map<String, dynamic> personData = {
      "name": _nameController.text.trim(),
      "gender": _selectedGender,
      "fatherId": _fatherId,
      "motherId": _motherId,
      "mobile": _mobileController.text.trim(),
      "whatsapp": _whatsappController.text.trim(),
      "facebook": _facebookController.text.trim(),
      "email": _emailController.text.trim(),
      "occupation": _occupationController.text.trim(),
      "dateOfBirth": _dobController.text.trim(),
      "dateOfDeath": _dodController.text.trim(),
      "bloodGroup": _selectedBloodGroup,
      "nid": _nidController.text.trim(),
      "profileImage": _profileImageController.text.trim(),
    };

    final success = await provider.addPerson(personData, userToken);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("সদস্য সফলভাবে যুক্ত হয়েছে!")),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।")),
      );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VillageProvider>(context);

    final List<Person> fathers = provider.people.where((p) => p.gender == 'Male').toList();
    final List<Person> mothers = provider.people.where((p) => p.gender == 'Female').toList();

    return Scaffold(
      appBar: AppBar(title: const Text("নতুন সদস্য যুক্ত করুন")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("পুরো নাম *", Icons.person),
                validator: (v) => v == null || v.isEmpty ? "নাম আবশ্যক" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setState(() => _selectedGender = v),
                      decoration: _inputDecoration("লিঙ্গ", Icons.people),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                      onChanged: (v) => setState(() => _selectedBloodGroup = v),
                      decoration: _inputDecoration("ব্লাড গ্রুপ", Icons.bloodtype),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _fatherId,
                items: fathers.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => _fatherId = v),
                decoration: _inputDecoration("পিতা নির্বাচন করুন", Icons.man),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _motherId,
                items: mothers.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => _motherId = v),
                decoration: _inputDecoration("মাতা নির্বাচন করুন", Icons.woman),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("মোবাইল নম্বর", Icons.phone),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("WhatsApp নম্বর", Icons.message),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _facebookController,
                decoration: _inputDecoration("Facebook Link", Icons.facebook),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Email", Icons.email),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _occupationController,
                decoration: _inputDecoration("পেশা", Icons.work),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: _inputDecoration("জন্ম তারিখ", Icons.calendar_today),
                onTap: () => _pickDate(controller: _dobController, isPastOnly: true),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dodController,
                readOnly: true,
                decoration: _inputDecoration("মৃত্যুর তারিখ", Icons.event_busy),
                onTap: () => _pickDate(controller: _dodController, isPastOnly: true),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nidController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("NID নম্বর", Icons.badge),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _profileImageController,
                decoration: _inputDecoration("Profile Image URL", Icons.image),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RbcColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 24, width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Text(
                          "সদস্য যুক্ত করুন",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}