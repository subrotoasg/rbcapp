

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // নতুন ইম্পোর্ট
import '../models/family_tree_model.dart';
import '../models/person_model.dart';
import '../providers/village_provider.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

class PersonDetailsScreen extends StatelessWidget {
  final String id;
  const PersonDetailsScreen({super.key, required this.id});

  // লিঙ্ক খোলার জন্য কমন ফাংশন
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  String _formatDateWithoutYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'তথ্য নেই';
    try {
      DateTime date = DateTime.parse(dateString);
      List<String> months = [
        'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
        'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
      ];
      return "${date.day} ${months[date.month - 1]}";
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateFull(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'তথ্য নেই';
    try {
      DateTime date = DateTime.parse(dateString);
      List<String> months = [
        'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
        'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
      ];
      return "${date.day} ${months[date.month - 1]}, ${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VillageProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("প্রোফাইল ডিটেইলস", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: RbcColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<FamilyTree?>(
        future: provider.fetchFamilyTree(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: RbcColors.primary));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("তথ্য লোড করা সম্ভব হয়নি"));
          }

          final tree = snapshot.data!;
          final person = tree.person;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildProfileHeader(person),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("ব্যক্তিগত তথ্য", Icons.info_outline),
                      _buildInfoCard([
                        _buildInfoRow(Icons.cake, "জন্ম তারিখ", _formatDateWithoutYear(person.dateOfBirth)),
                        _buildInfoRow(Icons.work, "পেশা", person.occupation),
                        _buildInfoRow(Icons.badge, "NID নম্বর", person.nid),
                        if (!person.isAlive)
                          _buildInfoRow(Icons.event_busy, "মৃত্যুর তারিখ", _formatDateFull(person.dateOfDeath), isAlert: true),
                      ]),
                      const SizedBox(height: 16),

                      _buildSectionHeader("যোগাযোগ", Icons.contact_phone_outlined),
                      _buildInfoCard([
                        // মোবাইল কল
                        _buildLinkRow(
                          Icons.phone, 
                          "মোবাইল", 
                          person.mobile, 
                          () => _launchUrl("tel:${person.mobile}"),
                          Colors.blue
                        ),
                        // হোয়াটসঅ্যাপ মেসেজ
                        _buildLinkRow(
                          Icons.message, 
                          "WhatsApp", 
                          person.whatsapp, 
                          () => _launchUrl("https://wa.me/${person.whatsapp}"),
                          Colors.green
                        ),
                        // ইমেইল পাঠানো
                        _buildLinkRow(
                          Icons.email, 
                          "ইমেইল", 
                          person.email, 
                          () => _launchUrl("mailto:${person.email}"),
                          Colors.redAccent
                        ),
                        // ফেসবুক প্রোফাইল
                        _buildLinkRow(
                          Icons.facebook, 
                          "ফেসবুক", 
                          person.facebook, 
                          () => _launchUrl(person.facebook ?? ""),
                          Colors.blue.shade800
                        ),
                      ]),
                      const SizedBox(height: 16),

                      _buildSectionHeader("পরিবার", Icons.family_restroom),
                      _buildInfoCard([
                        _buildRelationTile(context, "পিতা", tree.father?.name, tree.father?.id, Icons.man),
                        const Divider(height: 1),
                        _buildRelationTile(context, "মাতা", tree.mother?.name, tree.mother?.id, Icons.woman),
                      ]),
                      const SizedBox(height: 16),

                      if (tree.spouses.isNotEmpty) ...[
                        _buildSectionHeader("স্বামী/স্ত্রী", Icons.favorite_border),
                        _buildInfoCard(
                          tree.spouses.map((s) => Column(
                            children: [
                              _buildRelationTile(context, null, s.name, s.id, Icons.favorite, iconColor: Colors.pink),
                              if (s != tree.spouses.last) const Divider(height: 1),
                            ],
                          )).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (tree.children.isNotEmpty) ...[
                        _buildSectionHeader("সন্তানাদি", Icons.child_care),
                        _buildInfoCard(
                          tree.children.map((c) => Column(
                            children: [
                              _buildRelationTile(context, null, c.name, c.id, Icons.face, iconColor: Colors.teal),
                              if (c != tree.children.last) const Divider(height: 1),
                            ],
                          )).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // লিঙ্ক যুক্ত রো তৈরির জন্য নতুন উইজেট
  Widget _buildLinkRow(IconData icon, String label, String? value, VoidCallback onTap, Color themeColor) {
    bool hasValue = value != null && value.isNotEmpty;
    return ListTile(
      onTap: hasValue ? onTap : null,
      dense: true,
      leading: CircleAvatar(
        backgroundColor: themeColor.withOpacity(0.1),
        child: Icon(icon, color: themeColor, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      subtitle: Text(
        value ?? "N/A", 
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w600, 
          color: hasValue ? Colors.grey : Colors.black87,
        )
      ),
      trailing: hasValue ? Icon(Icons.open_in_new, size: 16, color: Colors.blue.shade300) : null,
    );
  }

  Widget _buildProfileHeader(Person person) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      decoration: const BoxDecoration(
        color: RbcColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white24,
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.white,
                  backgroundImage: (person.profileImage != null && person.profileImage!.isNotEmpty)
                      ? NetworkImage(person.profileImage!)
                      : null,
                  child: (person.profileImage == null || person.profileImage!.isEmpty)
                      ? Icon(
                          person.gender == 'Female' ? Icons.face_3 : Icons.person,
                          size: 60,
                          color: Colors.grey.shade400,
                        )
                      : null,
                ),
              ),
              if (person.bloodGroup != null && person.bloodGroup!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    person.bloodGroup!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            person.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(person.gender == 'Female' ? Icons.female : Icons.male, color: Colors.white70, size: 20),
              const SizedBox(width: 4),
              Text(
                person.gender == 'Female' ? "মেয়ে" : "পুরুষ",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              if (!person.isAlive) ...[
                const SizedBox(width: 8),
                const Text("| প্রয়াত", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Column(children: children)),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value, {bool isAlert = false}) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: isAlert ? Colors.red.shade50 : Colors.indigo.shade50,
        child: Icon(icon, color: isAlert ? Colors.red : Colors.indigo, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      subtitle: Text(value ?? "N/A", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isAlert ? Colors.red : Colors.grey)),
    );
  }

  Widget _buildRelationTile(BuildContext context, String? label, String? name, String? relativeId, IconData icon, {Color iconColor = Colors.indigo}) {
    final bool hasId = relativeId != null && relativeId.isNotEmpty;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(name ?? "তথ্য নেই", style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: label != null ? Text(label) : null,
      trailing: hasId ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey) : null,
      onTap: hasId
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonDetailsScreen(id: relativeId),
                ),
              );
            }
          : null,
    );
  }
}