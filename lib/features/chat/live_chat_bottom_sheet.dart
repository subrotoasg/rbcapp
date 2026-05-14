import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/chat/widgets/message_bubble.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';

class LiveChatBottomSheet extends StatefulWidget {
const LiveChatBottomSheet({super.key});

@override
State<LiveChatBottomSheet> createState() => _LiveChatBottomSheetState();
  }

  class _LiveChatBottomSheetState extends State<LiveChatBottomSheet> {
    final TextEditingController _messageController = TextEditingController();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    bool _isSending = false;

    Future<void> _sendMessage() async {
      final user = context.read<AuthController>().user;
        final text = _messageController.text.trim();

        if (user == null || text.isEmpty || _isSending) return;

        setState(() => _isSending = true);
        _messageController.clear();

        try {
        await _firestore.collection('group_chats').add({
        'text': text,
        'senderName': user.name ?? 'Unknown',
        'senderEmail': user.email ?? '',
        'senderPhoto': user.photo ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        });
        try {
        await ApiClient.instance.post(
        '/api/v1/chat/notification',
        data: {
        'title': 'লাইভ আড্ডা',
        'message': text,
        'senderId': user.email ?? '',
        'senderName': user.name ?? 'Unknown',
        'deepLink': 'rbc://chat',
        },
        );
        } catch (apiError) {
        debugPrint('❌ নোটিফিকেশন পাঠাতে সমস্যা: $apiError');
        }

        } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error sending message!')));
        } finally {
        if (mounted) setState(() => _isSending = false);
        }
        }

        @override
        Widget build(BuildContext context) {
        final currentUser = context.watch<AuthController>().user;

          return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollController) {
          return Container(
          decoration: const BoxDecoration(
          color: Color(0xFFF4F6F9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
          children: [
          // Header
          Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF1E3C72), Color(0xFF2A5298)]),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Row(
          children: [
          Stack(
          alignment: Alignment.topRight,
          children: [
          const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.groups, color: Colors.white)),
          Container(
          width: 12, height: 12,
          decoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
          ),
          ],
          ),
          const SizedBox(width: 12),
          const Expanded(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('গ্রুপ চ্যাটিং', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text('রিয়েল টাইম সবাই দেখবে', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
          ),
          ),
          IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
          ],
          ),
          ),


          // Messages Area
          Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
            .collection('group_chats')
            .orderBy('timestamp', descending: true)
            .limit(50)
            .snapshots(),
            builder: (context, snapshot) {
            // ১. যদি কোনো এরর আসে, তবে লোডিং না দেখিয়ে এরর দেখাবে
            if (snapshot.hasError) {
            return Center(
            child: Text(
            'সমস্যা হয়েছে: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
            ),
            );
            }

            // ২. ডেটা লোড হওয়ার সময় লোডিং দেখাবে
            if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
            }

            // ৩. যদি কোনো মেসেজ না থাকে
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
            'কোনো মেসেজ নেই।\nপ্রথম মেসেজটি আপনিই দিন!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
            ),
            ],
            ),
            );
            }

            // ৪. মেসেজগুলো লিস্ট আকারে দেখাবে
            final docs = snapshot.data!.docs;
            return ListView.builder(
            controller: scrollController,
            reverse: true, // নতুন মেসেজ নিচে থাকার জন্য
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
              final time = data['timestamp'] != null
              ? DateFormat('hh:mm a').format((data['timestamp'] as Timestamp).toDate())
              : 'Sending...';

              return MessageBubble(
              text: data['text'] ?? '',
              senderName: data['senderName'] ?? 'Unknown',
              senderPhoto: data['senderPhoto'] ?? '',
              time: time,
              isMe: data['senderEmail'] == currentUser?.email,
              );
              },
              );
              },
              ),
              ),

              // Input
              Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16, top: 12, left: 16, right: 16),
              color: Colors.white,
              child: Row(
              children: [
              Expanded(
              child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
              hintText: 'মেসেজ লিখুন...',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
              ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
              onTap: _sendMessage,
              child: CircleAvatar(
              backgroundColor: const Color(0xFF1E3C72),
              child: _isSending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send, color: Colors.white, size: 20),
              ),
              ),
              ],
              ),
              ),
              ],
              ),
              );
              },
              );
              }
              }