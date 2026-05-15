import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import '../models/person_model.dart';
import '../providers/village_provider.dart';
import 'person_details_screen.dart';
import 'add_person_screen.dart';
import 'edit_person_screen.dart';

class VillagePeopleListScreen extends StatefulWidget {
  const VillagePeopleListScreen({super.key});

  @override
  State<VillagePeopleListScreen> createState() => _VillagePeopleListScreenState();
}

class _VillagePeopleListScreenState extends State<VillagePeopleListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VillageProvider>(context);
    final authController = context.read<AuthController>();
    
    // অ্যাডমিন রোল চেক
    final bool isAdmin = authController.user?.role == 'admin';
    
    // শুরুতেই সব মেম্বার লোড হবে, সার্চ করলে ফিল্টার হবে
    final List<Person> displayPeople = provider.people.where((person) {
      final nameMatch = person.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final phoneMatch = (person.mobile ?? "").contains(_searchQuery);
      return nameMatch || phoneMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('গ্রামের সদস্যবৃন্দ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: RbcColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // সার্চ বার সেকশন
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: RbcColors.primary,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "নাম বা মোবাইল নম্বর দিয়ে খুঁজুন...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() { _searchQuery = ""; });
                      },
                    )
                  : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // মেম্বার লিস্ট সেকশন
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator(color: RbcColors.primary))
                : displayPeople.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        itemCount: displayPeople.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final person = displayPeople[index];
                          return _buildPersonCard(context, person, isAdmin);
                        },
                      ),
          ),
        ],
      ),
      
      // শুধুমাত্র অ্যাডমিনদের জন্য ফ্লোটিং বাটন
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPersonScreen()),
              ),
              backgroundColor: RbcColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("নতুন সদস্য", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  // মেম্বার কার্ড ডিজাইন
  Widget _buildPersonCard(BuildContext context, Person person, bool isAdmin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: person.id,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: RbcColors.primary.withOpacity(0.1),
            backgroundImage: (person.profileImage != null && person.profileImage!.isNotEmpty)
                ? NetworkImage(person.profileImage!)
                : null,
            child: (person.profileImage == null || person.profileImage!.isEmpty)
                ? Icon(Icons.person, color: RbcColors.primary, size: 30)
                : null,
          ),
        ),
        title: Text(
          person.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(Icons.phone_android, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(person.mobile ?? "তথ্য নেই", style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAdmin)
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.edit_outlined, color: Colors.blue, size: 18),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditPersonScreen(person: person)),
                ),
              ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PersonDetailsScreen(id: person.id)),
        ),
      ),
    );
  }

  // ফাঁকা অবস্থার ডিজাইন
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? "কোনো সদস্য পাওয়া যায়নি" : "এই নামে কাউকে খুঁজে পাওয়া যায়নি",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}