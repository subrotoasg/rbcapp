import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/shared/widgets/app_network_image.dart';

class MessageBubble extends StatelessWidget {
  final String text, senderName, senderPhoto, time;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.text,
    required this.senderName,
    required this.senderPhoto,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            AppNetworkAvatar(url: senderPhoto, size: 36),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      senderName,
                      style: const TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.black54,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isMe 
                        ? const LinearGradient(colors: [Color(0xFF2A5298), Color(0xFF1E3C72)]) 
                        : const LinearGradient(colors: [Colors.white, Colors.white]),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06), 
                        blurRadius: 8, 
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87, 
                      fontSize: 15, 
                      height: 1.3,
                    ),
                  ),
                ),
                if (time.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 6, left: isMe ? 0 : 4, right: isMe ? 4 : 0),
                    child: Text(
                      time, 
                      style: const TextStyle(fontSize: 10, color: Colors.black45),
                    ),
                  ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 40),
        ],
      ),
    );
  }
}