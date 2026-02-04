import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:html' as html;

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

  void _openPDFViewer(String pdfPath, String title) async {
    try {
      final ByteData data = await rootBundle.load(pdfPath);
      final Uint8List bytes = data.buffer.asUint8List();
      
      if (bytes.length == 0) {
        throw Exception('PDF file is empty');
      }
      
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      final windowName = title.replaceAll(' ', '_').replaceAll('-', '_');
      html.window.open(url, windowName);
      
      Future.delayed(Duration(seconds: 1), () {
        html.Url.revokeObjectUrl(url);
      });
      
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('PDF Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Could not load PDF file:'),
                SizedBox(height: 8),
                Text(
                  pdfPath,
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
                SizedBox(height: 12),
                Text('Error: ${e.toString()}'),
                SizedBox(height: 12),
                Text('Please check:'),
                Text('• PDF file exists in assets/files/'),
                Text('• PDF is not corrupted or password-protected'),
                Text('• File is properly referenced in pubspec.yaml'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
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

                // AZ900 Certification Container
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
                          'Azure Fundamentals (AZ-900)',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(height: 10),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'I achieved my AZ900 as an introduction to the cloud. I didn\'t find it to be challenging and achieved it on my first attempt.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              _openPDFViewer('assets/files/AZ900.pdf', 'AZ-900 Certificate');
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
                              'Open PDF',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // AZ104 Certification Container
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
                          'Azure Administrator (AZ-104)',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(height: 10),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'I achieved my AZ104 as it was the natural next step after completing the AZ900. I found the content to be more vast and complex but I studied to get an understanding of the services offered by Azure and completed it on my first attempt.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              _openPDFViewer('assets/files/AZ104.pdf', 'AZ-104 Certificate');
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
                              'Open PDF',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // AWS Cloud Practitioner Certification Container
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
                          'AWS Cloud Practitioner (CLF-C02)',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(height: 10),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'I achieved my AWS CLF-C02 to better round my cloud certification. I didn\'t find this to be challenging as the content was similar to Azure and I achieved it on my first attempt.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              _openPDFViewer('assets/files/AWS Certified Cloud Practitioner certificate (2).pdf', 'AWS Cloud Practitioner Certificate');
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
                              'Open PDF',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Project 1 Container
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
                          'Task Manager',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, ),
                        ),
                        SizedBox(height: 20),
                        
                        Center(
                          child: Container(
                            width: 575,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/120.png', 
width: 575,
      fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'An application that helps users plan their daily tasks.',
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
                              Navigator.pushNamed(context, '/Project1');
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

                // Project 2 Container
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
                          'Application Tracker',
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, ),
                        ),
                        SizedBox(height: 20),
                        
                        Center(
                          child: Container(
                            width: 575,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/135.png', 
      fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'An application that allows users to add and view jobs they\'ve applied for with insights.',
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
                              Navigator.pushNamed(context, '/Project2');
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

                // Project 3 Container
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
                          'API Intel',
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
                              'assets/images/147.png', 
                              height: 300,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'An application that allows users to see analytics on REST APIs that have OpenAPI specification and traffic data.',
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
                              Navigator.pushNamed(context, '/Project3');
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