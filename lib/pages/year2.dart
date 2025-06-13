import 'package:flutter/material.dart';

class Y2 extends StatefulWidget {
  @override
  _Y2State createState() => _Y2State();
}

class _Y2State extends State<Y2> {
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
    PopupMenuItem(value: '/Y3', child: Text('Year 3', style: TextStyle(color: Colors.black))),
    //PopupMenuItem(value: '/PostUni', child: Text('Post Uni', style: TextStyle(color: Colors.black))),
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
        title: Text('Year 2', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '3D Design and Animation',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 20),
                        
                        // Centered Image
                        Center(
                          child: Container(
                            width: 575,
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/2.jpg',
                              fit: BoxFit.fitHeight,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    'Image',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Text below image
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'This page showcases my 3D design and animation project completed as one of my university courseworks. The project explores key aspects of both design and animation including modeling, texturing, lighting, rigging and animation using autodesk\'s 3Ds Max.',
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
                              Navigator.pushNamed(context, '/Design');
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
                          'Software Engineering',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 20),
                        
                        // Centered Image
                        Center(
                          child: Container(
                            width: 575,
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/58.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    'Image',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Text below image
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'This page showcases my software engineering theory and practice project completed as one of my university courseworks. For this project I worked in a group and we made a recipe generation app. The app generates recipes with ingredients inputted by the user.',
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
                              Navigator.pushNamed(context, '/Setup');
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
                          'My First App',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
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
                              'assets/images/67.png',
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
                            'This page shows a decision map based movie recommender I made for the implementation side of my user experience design and implementation module. It is my first time making an app.',
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
                              Navigator.pushNamed(context, '/App');
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
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Container()), // Left spacer
                          Expanded(
                            flex: 2,
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
                          Expanded(flex: 1, child: Container()), // Right spacer
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