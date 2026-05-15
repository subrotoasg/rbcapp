import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/person_model.dart';
import '../providers/village_provider.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';

class EditPersonScreen extends StatefulWidget {
  final Person person;
  const EditPersonScreen({super.key, required this.person});

  @override
  State<EditPersonScreen> createState() => _EditPersonScreenState();
}

class _EditPersonScreenState extends State<EditPersonScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _whatsappController;
  late TextEditingController _facebookController;
  late TextEditingController _emailController;
  late TextEditingController _occupationController;
  late TextEditingController _dobController;
  late TextEditingController _dodController;
  late TextEditingController _nidController;
  late TextEditingController _profileImageController;

  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _fatherId;
  String? _motherId;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    final p = widget.person;

    // Initializing controllers with existing data
    _nameController = TextEditingController(text: p.name);
    _mobileController = TextEditingController(text: p.mobile ?? "");
    _whatsappController = TextEditingController(text: p.whatsapp ?? "");
    _facebookController = TextEditingController(text: p.facebook ?? "");
    _emailController = TextEditingController(text: p.email ?? "");
    _occupationController = TextEditingController(text: p.occupation ?? "");
    _dobController = TextEditingController(text: p.dateOfBirth ?? "");
    _dodController = TextEditingController(text: p.dateOfDeath ?? "");
    _nidController = TextEditingController(text: p.nid ?? "");
    _profileImageController = TextEditingController(text: p.profileImage ?? "");

    // Safety check for Dropdowns to avoid "Assertion Error"
    _selectedGender = (p.gender == 'Male' || p.gender == 'Female') ? p.gender : null;
    _selectedBloodGroup = _bloodGroups.contains(p.bloodGroup) ? p.bloodGroup : null;
    
    _fatherId = p.fatherId;
    _motherId = p.motherId;
  }

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

  Future<void> _pickDate({required TextEditingController controller}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  Future<void> _updateData() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authController = context.read<AuthController>();
    final String userToken = authController.user?.token ?? "";

    final Map<String, dynamic> data = {
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

    final success = await context.read<VillageProvider>().updatePerson(widget.person.id, data, userToken);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("তথ্য সফলভাবে আপডেট হয়েছে")));
      Navigator.pop(context);
    }
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VillageProvider>(context);
    
    // Filter lists for Father and Mother dropdowns
    final List<Person> fathers = provider.people.where((p) => p.gender == 'Male' && p.id != widget.person.id).toList();
    final List<Person> mothers = provider.people.where((p) => p.gender == 'Female' && p.id != widget.person.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("তথ্য এডিট"),
        backgroundColor: RbcColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _dec("পুরো নাম *", Icons.person),
                validator: (v) => v == null || v.isEmpty ? "নাম আবশ্যক" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('ছেলে')),
                        DropdownMenuItem(value: 'Female', child: Text('মেয়ে')),
                      ],
                      onChanged: (v) => setState(() => _selectedGender = v),
                      decoration: _dec("লিঙ্গ", Icons.people),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                      onChanged: (v) => setState(() => _selectedBloodGroup = v),
                      decoration: _dec("ব্লাড গ্রুপ", Icons.bloodtype),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _fatherId,
                items: fathers.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => _fatherId = v),
                decoration: _dec("পিতা নির্বাচন করুন", Icons.man),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _motherId,
                items: mothers.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => _motherId = v),
                decoration: _dec("মাতা নির্বাচন করুন", Icons.woman),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: _dec("মোবাইল নম্বর", Icons.phone),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                decoration: _dec("WhatsApp নম্বর", Icons.message),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _facebookController,
                decoration: _dec("Facebook Link", Icons.link),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _dec("Email", Icons.email),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _occupationController,
                decoration: _dec("পেশা", Icons.work),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: _dec("জন্ম তারিখ", Icons.calendar_today),
                onTap: () => _pickDate(controller: _dobController),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dodController,
                readOnly: true,
                decoration: _dec("মৃত্যুর তারিখ", Icons.event_busy),
                onTap: () => _pickDate(controller: _dodController),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nidController,
                keyboardType: TextInputType.number,
                decoration: _dec("NID নম্বর", Icons.badge),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _profileImageController,
                decoration: _dec("Profile Image URL", Icons.image),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _updateData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RbcColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "আপডেট করুন",
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