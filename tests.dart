import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: WhatsappClone(),
    debugShowCheckedModeBanner: false,
  ));
}

class WhatsappClone extends StatefulWidget {
  @override
  _WhatsappClone createState() => _WhatsappClone();
}

class _WhatsappClone extends State<WhatsappClone> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    ChatsScreen(),
    StatusScreen(),
    CallsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp Clone"),
        backgroundColor: Color(0xFF075E54),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF075E54),
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
        ],
      ),
    );
  }
}

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Number of chats
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/Images/boylogo.png'),
          ),
          title: Text('Contact Name'),
          subtitle: Text('Last message'),
          trailing: Text('Time'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatDetailScreen()),
            );
          },
        );
      },
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = []; // Store messages

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      setState(() {
        messages.add(text);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Name"),
        backgroundColor: Color(0xFF075E54),
        actions: [
          IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length, // Number of messages
              reverse: true,
              itemBuilder: (context, index) {
                return ChatBubble(
                  isUserMessage: index % 2 == 0,
                  message: messages[messages.length - 1 - index],
                  onLike: () {
                    // Handle like
                  },
                  onShare: () {
                    // Handle share
                  },
                  onComment: () {
                    // Handle comment
                  },
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: "Type a message"),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send, color: Color(0xFF075E54)),
          onPressed: () => _handleSubmitted(_controller.text),
        ),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isUserMessage;
  final String message;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onComment;

  ChatBubble({
    required this.isUserMessage,
    required this.message,
    required this.onLike,
    required this.onShare,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.all(10.0),
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: isUserMessage ? Color(0xFFDCF8C6) : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(

        crossAxisAlignment:
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                color: isUserMessage ? Colors.black : Colors.black87),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up_alt_outlined),
                onPressed: onLike,
                color: Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: onComment,
                color: Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: onShare,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Status Screen'),
    );
  }
}

class CallsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Calls Screen'),
    );
  }
}
