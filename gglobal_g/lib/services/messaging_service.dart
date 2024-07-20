import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class MessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getCombinedMessages(String user1Id, String user2Id) {
    var stream1 = _firestore
        .collection('messages')
        .where('senderId', isEqualTo: user1Id)
        .where('receiverId', isEqualTo: user2Id)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());

    var stream2 = _firestore
        .collection('messages')
        .where('senderId', isEqualTo: user2Id)
        .where('receiverId', isEqualTo: user1Id)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());

    var combinedStream = StreamZip([stream1, stream2]);

    return combinedStream.map((lists) {
      var combined = <Message>[];
      for (var list in lists) {
        combined.addAll(list);
      }
      combined.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return combined;
    });
  }

  Future<void> sendMessage(Message message) async {
    try {
      await _firestore.collection('messages').add(message.toMap());
    } catch (e) {
      // Replace with proper logging
      print(e.toString());
    }
  }
}
