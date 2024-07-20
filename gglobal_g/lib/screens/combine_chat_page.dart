import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as CustomUser;
import 'package:gglobal_g/models/message.dart';
import 'package:gglobal_g/services/messaging_service.dart';

class CombineChatPage extends StatefulWidget {
  final CustomUser.User user;
  final String adminId;

  const CombineChatPage({Key? key, required this.user, required this.adminId}) : super(key: key);

  @override
  _CombineChatPageState createState() => _CombineChatPageState();
}

class _CombineChatPageState extends State<CombineChatPage> {
  final MessagingService _messagingService = MessagingService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<List<Message>> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = _messagingService.getCombinedMessages(widget.user.uid, widget.adminId);
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Message message = Message(
        senderId: widget.user.uid,
        receiverId: widget.adminId,
        content: _messageController.text,
        timestamp: DateTime.now(),
      );
      _messagingService.sendMessage(message).then((_) {
        // Mesaj gönderildikten sonra Stream'i güncelleyerek sayfayı yenile
        setState(() {
          _messagesStream = _messagingService.getCombinedMessages(widget.user.uid, widget.adminId);
        });
        // Mesaj gönderildikten sonra ScrollController ile ekranı en alta kaydır
        _scrollToBottom();
      }).catchError((error) {
        print("Hata oluştu: $error");
        // Hata durumunda uygun bir geri bildirim gösterilebilir
      });

      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anlık Mesajlaşma'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Message> messages = snapshot.data!;
                messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Message message = messages[index];
                    bool isUserMessage = message.senderId == widget.user.uid;

                    return Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isUserMessage ? 'gglobal' : 'gglobal',
                              style: TextStyle(fontWeight: FontWeight.bold, color: isUserMessage ? Colors.white : Colors.black),
                            ),
                            Text(
                              message.content,
                              style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                            ),
                            Text(
                              message.timestamp.toString(),
                              style: TextStyle(fontSize: 12, color: isUserMessage ? Colors.white70 : Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Mesajınızı yazın'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
