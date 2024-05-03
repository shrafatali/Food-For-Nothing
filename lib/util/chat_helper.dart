class ChatHelper {
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "${user1.replaceAll(' ', '_')},${user2.replaceAll(' ', '_')}";
    } else {
      return "${user2.replaceAll(' ', '_')},${user1.replaceAll(' ', '_')}";
    }
  }
}
