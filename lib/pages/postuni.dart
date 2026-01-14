import 'package:flutter/material.dart';

class PostUni extends StatefulWidget {
  @override
  _PostUniState createState() => _PostUniState();
}

class _PostUniState extends State<PostUni> {
  final GlobalKey _menuKey = GlobalKey();
  bool _isMenuOpen = false;
  
  // Scroll controller for custom scrollbar
  final ScrollController _scrollController = ScrollController();

  void _onMenuSelect(BuildContext context, String page) {
    setState(() {
      _isMenuOpen = false;
    });
    Navigator.pushNamed(context, page);
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      Navigator.pop(context);
      setState(() {
        _isMenuOpen = false;
      });
    } else {
      final RenderBox renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      
showMenu(
  context: context,
  color: const Color.fromARGB(255, 169, 169, 169),
  position: RelativeRect.fromLTRB(
    position.dx,
    position.dy + renderBox.size.height + 8,
    position.dx + renderBox.size.width,
    position.dy + renderBox.size.height + 8,
  ),
  items: [
    PopupMenuItem(value: '/Intro', child: Text('Introduction', style: TextStyle(color: Colors.black))),
    PopupMenuItem(value: '/Y2', child: Text('Year 2', style: TextStyle(color: Colors.black))),
    PopupMenuItem(value: '/Y3', child: Text('Year 3', style: TextStyle(color: Colors.black))),
    PopupMenuItem(value: '/WriteUps', child: Text('Reports', style: TextStyle(color: Colors.black))),
  ],
).then((value) {
        setState(() {
          _isMenuOpen = false;
        });
        if (value != null) {
          _onMenuSelect(context, value);
        }
      });
      
      setState(() {
        _isMenuOpen = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Uni', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 169, 169, 169),
        leading: IconButton(
          key: _menuKey,
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: _toggleMenu,
        ),
      ),
      backgroundColor: Colors.grey[800],
      body: RawScrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 8.0,
        radius: Radius.circular(6),
        interactive: true,
        thumbColor: Colors.grey.shade700,
        trackColor: const Color.fromARGB(255, 169, 169, 169),
        trackRadius: Radius.circular(6),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 169, 169, 169),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Portfolio',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(height: 10),
                        
                        // Text content only
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'This portfolio was the first project I completed after finishing my degree, however It didn\'t seem necessary to give it a dedicated page.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                                                SizedBox(height: 10),

                      ],
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 169, 169, 169),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'AI Image Generator',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, ),
                        ),
                        SizedBox(height: 20),
                        
                        // Centered Image
                        Center(
                          child: Container(
                            width: 575,
                            height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/85.png', 
                              height: 300,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'An AI image generation application that creates images from text prompts. Built using modern AI models and integrated with a user-friendly interface.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/AiImageGen');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ),
                            child: Text(
                              'Open Project',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 169, 169, 169),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'AI Model Generator',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, ),
                        ),
                        SizedBox(height: 20),
                        
                        Center(
                          child: Container(
                            width: 575,
                            height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/94.png', 
                              height: 300,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'An AI 3D model generation application that creates models from text prompts or images. Built using modern AI models and integrated with a user-friendly interface.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/AiModelGen');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ),
                            child: Text(
                              'Open Project',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 169, 169, 169),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'AI Chess Game',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, ),
                        ),
                        SizedBox(height: 20),
                        
                        Center(
                          child: Container(
                            width: 575,
                            height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/105.png', 
                              height: 300,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Text below image
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                          "A chess application featuring both local multiplayer and AI opponents. The game implements an interactive board and peices with all standard chess rules.",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/Chess');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ),
                            child: Text(
                              'Open Project',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Navigation Buttons
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Quick Navigation',
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Intro');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Introduction',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Y2');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Year 2',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Y3');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Year 3',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/WriteUps');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Reports',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}