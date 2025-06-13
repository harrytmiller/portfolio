import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
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

  Widget _buildContainer({
    required String title,
    required List<Widget> children,
    Color? backgroundColor,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromARGB(255, 169, 169, 169),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
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
        title: Text('Introduction', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                SizedBox(height: 30),

                // Portfolio Introduction Container
                _buildContainer(
                  title: 'Portfolio Introduction',
                  children: [
                    Text(
                      'This portfolio serves to showcase projects I have completed during and after my university studies. ',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Portfolio Structure',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Introduction: Portfolio introduction, personal introduction, curriculum vitae and grade breakdown',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Year 2: Projects and coursework completed during my second year at university\n'
                      '       -3D Design and Animation: Modelling and animation showcase page, including video and picture renders\n'
                      '       -Software Engineering: Recipe generation app showcase page, including screenshots and running prototype\n'
                      '       -My First App: Movie recommender app showcase page, including screenshots and running prototype',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                    ),                    
                    SizedBox(height: 6),
                    Text(
                      '• Year 3: Projects and coursework completed during my final year at university\n'
                      '       -Dissertaion: Math app showcase page, including screenshots and running prototype\n'
                      '       -Artificial intelligence: Genetic algorithm and neural networks showcase page, including python coad and output screenshots',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                    ),                    
                    SizedBox(height: 6),
                    Text(
                      '• Reports: Academic reports and research studies completed during my time at university (these reports dont have dedicated pages but there are buttons to view pdfs)',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Navigation',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Use the dropdown menu in the top-left corner or quick navigation at the bottom of pages to navigate between sections (if a project is open you must navigate back before changing section).',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),

                // Personal Introduction Container
                _buildContainer(
                  title: 'Personal Introduction',
                  children: [
                    Text(
                      'My name is Harry Miller, I am 21 years old, and I recently graduated with First Class Honours in Computing from the University of Portsmouth. I\'m passionate about computing and expressing creativity through making things. I like turning ideas into reality by combining technical skills with creative thinking. I also enjoy complex problem solving as it allows for critical thinking, as well as satisfaction of finding the solution. I believe in continuous learning and personal development, I like to challenge myself both academically and personally to reach my full potential.',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'My degree is broad and covers different topics such as: usability, user interface design, security, software engineering, 3d design and animation, artificial intelligence, networks and databases (some of which are covered in my portfolio). I have coded with python, flutter/dart, sql and some java. I have made multiple applications, the most relevant of which are accessible through this portfolio. It has been a goal of mine to achieve as highly as I am capable of at university. This includes both learning and understanding academic knowledge to score highly in exams, and applying what I know to produce high quality courseworks.',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'My academic success reflects my commitment to excellence. I\'m excited to apply both my technical skills and creative perspective to meaningful projects that challenge me to grow.',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Please note: I have visible tattoos including on my face, neck, and hands, which are part of my personal expression and authentic identity.',
                      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            'images/83.jpeg',
                            height: 400,
                            width: 400,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.grey.shade600,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Image not found',
                                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Curriculum Vitae Container
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 169, 169, 169),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Curriculum Vitae',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                         'My CV contains details about my educational background, work history, technical and soft skills, and achievements. It provides an overview of my academic journey that demonstrates my qualifications and readiness for future opportunities.',                          style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/CV');
                          },
                          icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                          label: Text(
                            'View CV',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                        ),
                      ),
                    ],
                  ),
                ),

                // Grade Breakdown Container
                _buildContainer(
                  title: 'Grade Breakdown',
                  children: [
                    Text(
                      'Academic Standing',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 150, 150, 150),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Overall GPA:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              Text('[X.XX]', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Year 2 Average:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              Text('74.4%.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Year 3 Average:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              Text('[XX%]', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Year 2 Modules Table
                    Text(
                      'Year 2 Modules With Grades',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('USER EXPERIENCE DESIGN AND IMPLEMENTATION', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('70.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('SOFTWARE ENGINEERING THEORY AND PRACTICE', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('78.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('3D COMPUTER GRAPHICS AND ANIMATION', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('78.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('OPERATING SYSTEMS AND INTERNETWORKING', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('81.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('DATABASE PRINCIPLES', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('70.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('BUSINESS INFORMATION SYSTEMS SECURITY', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('70.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Year 3 Modules Table
                    Text(
                      'Year 3 Modules With Grades',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('ARTIFICIAL INTELLIGENCE', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('75.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('ADVANCED NETWORKS', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('75.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('SECURITY AND CRYPTOGRAPHY', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('[Grade]', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('USABILITY TESTING', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('64.00%', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('INDIVIDUAL PROJECT (ENGINEERING)', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('[Grade]', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.right),
                          ),
                        ]),
                      ],
                    ),
                  ],
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

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}