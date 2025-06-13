import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class Setup extends StatefulWidget {
  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  // Scroll controller for custom scrollbar
  final ScrollController _scrollController = ScrollController();
  
  // Image gallery state
  int _currentImageIndex = 0;
  int _thumbnailStartIndex = 0;
  int _thumbnailsPerPage = 7;
  int _maxThumbnailsPerPage = 7;
  int _minThumbnailsPerPage = 3;
  bool _hasRenderFlex = false;
  
  List<String> _imagePaths = [
    'assets/images/37.png',
    'assets/images/38.png',
    'assets/images/39.png',
    'assets/images/40.png',
    'assets/images/41.png',
    'assets/images/42.png',
    'assets/images/43.png',
    'assets/images/44.png',
    'assets/images/45.png',
    'assets/images/46.png',
    'assets/images/47.png',
    'assets/images/48.png',
    'assets/images/49.png',
    'assets/images/50.png',
    'assets/images/51.png',
    'assets/images/65.png',
    'assets/images/52.png',
    'assets/images/53.png',
    'assets/images/54.png',
    'assets/images/55.png',
    'assets/images/56.png',
    'assets/images/57.png',
    'assets/images/58.png',
    'assets/images/59.png',
    'assets/images/60.png',
    'assets/images/61.png',
    'assets/images/62.png',
    'assets/images/66.png',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayoutSpace();
    });
  }

  void _handleRenderFlexOverflow() {
    if (_thumbnailsPerPage > _minThumbnailsPerPage) {
      setState(() {
        _thumbnailsPerPage--;
        _hasRenderFlex = true;
        if (_thumbnailStartIndex + _thumbnailsPerPage > _imagePaths.length) {
          _thumbnailStartIndex = (_imagePaths.length - _thumbnailsPerPage).clamp(0, _imagePaths.length - 1);
        }
      });
    }
  }

  void _checkLayoutSpace() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasRenderFlex && _thumbnailsPerPage < _maxThumbnailsPerPage) {
        final screenWidth = MediaQuery.of(context).size.width;
        final availableWidth = screenWidth * 0.9 - 80;
        final thumbnailWidth = 92.0;
        final maxFittable = (availableWidth / thumbnailWidth).floor();
        
        if (maxFittable > _thumbnailsPerPage && _thumbnailsPerPage < _maxThumbnailsPerPage) {
          setState(() {
            _thumbnailsPerPage = (maxFittable).clamp(_minThumbnailsPerPage, _maxThumbnailsPerPage);
            if (_thumbnailsPerPage == _maxThumbnailsPerPage) {
              _hasRenderFlex = false;
            }
          });
        }
      }
    });
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

  void _launchURL(String url) {
    html.window.open(url, '_blank');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLayoutSpace());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Software Engineering', 
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 169, 169, 169),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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

                // Image Gallery Section
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
                      children: [
                        Text(
                          'Software Engineering Theory and Practice',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                            textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        

                                                   Text(
                                'This page showcases my software engineering theory and practice project completed as one of my university courseworks. For the planning of this project I worked in a group of 6 however one of our teammates did not participate in implementation, testing or review so for these parts we were a group of 5. We first chose the topic of sustainability then decided to make a recipe app. The app would generate recipes that use the ingredients that users enter. The purpose of the app is to reduce wastage by helping users to use the ingredients they have. We named the app Waste Away. We collaborated on the app using a github repository. The app was programmed on flutter/dart with a firebase backend. The recipe generation process uses an API from edamam, and takes ingredients as input and gives recipes as output. User information is stored on firebase including account details and ingredients.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              
                              
                              
                              Text(
                               'I altered the application by myself after submission before adding it to my portfolio. I improved the recipe generation algorithm. Before my changes it generated 5 recipes but I changed it to generate 8. Before it would only generate recipes that use every ingredient the user has, my changes allowed it to generate recipes with as many ingredients as possible. It will try combinations of all the ingredients, all ingredients - 1 ingredient so on. The recipe generation API was also expired so I had to get a new one. I also changed the firebase API and added a .env file so as not to post my API keys online. I also removed features that I did not think should be included: ability for users to add their own faqs, and ability for users to add their own recipes (as these recipes were not used in the recipe generation algorithm).',
                               style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                        

                        SizedBox(height: 12),

                              Text(
                               'Below are screenshots of the application and a running prototype. The app was originally made to be a mobile app however the running prototype is a web app. The screenshots show both the mobile and web versions of the application. The screenshots of the mobile version were captured on a pixel 6 emulator with Android 10 as operating system.',
                               style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                           SizedBox(height: 30),

                              Text(
                               'To access the application use details provided: Username:xxx@xxx.xxx | Password: 11111111!Aa',                              
                               style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),

                        SizedBox(height: 12),

                        Container(
                          child: GestureDetector(
                            onTap: () => _launchURL('https://harrytmiller.github.io/recipe_application/'), 
                            child: Text(
                              'Link to running prototype',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        
                        
                         SizedBox(height: 30),

                        _buildImageGallery(),

                      ],
                    ),
                  ),
                ),

                // Project Info Section
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 169, 169, 169),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Write Ups and Code Folder',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 16),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Text(
                                '- The \'View Plan Write Up\' button will open a pdf file that documents the planning of our app including choosing requirements and specifications.',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              Text(
                                '- The \'View Review Write Up\' button will open a pdf file that documents the review of our app and if/how it achieves requirements and specifications from our plan. Note- I believe Khadija Baffa was given 100 percent contribution for testing instead of 0 but I dont have access to a more up to date file.',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),

                                                          SizedBox(height: 12),
                              Text(
                                '- The \'Download Code Folder\' button will download our complete application code.',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _openPDFViewer('assets/files/cw plan.pdf', 'Setup Plan Write Up');
                                },
                                icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                                label: Text(
                                  'View Plan Write Up',
                                  style: TextStyle(
                                      fontSize: 16,  // Updated from 12 to 16
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),  // Updated from 8 to 12 for consistency
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _openPDFViewer('assets/files/cw review.pdf', 'Setup Review Write Up');
                                },
                                icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                                label: Text(
                                  'View Review Write Up',
                                  style: TextStyle(
                                      fontSize: 16,  // Updated from 12 to 16
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),  // Updated from 8 to 12 for consistency
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  try {
                                    final ByteData data = await rootBundle.load('assets/folders/Recipe.zip');
                                    final Uint8List bytes = data.buffer.asUint8List();
                                    
                                    final blob = html.Blob([bytes], 'application/zip');
                                    final url = html.Url.createObjectUrlFromBlob(blob);
                                    
                                    final anchor = html.AnchorElement()
                                      ..href = url
                                      ..download = 'Setup_Code_Files.zip'
                                      ..style.display = 'none';
                                    
                                    html.document.body!.append(anchor);
                                    anchor.click();
                                    anchor.remove();
                                    
                                    html.Url.revokeObjectUrl(url);
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Download started!')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Download failed: File not found'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(Icons.download, color: Colors.white),
                                label: Text(
                                  'Download Code Folder',
                                  style: TextStyle(
                                      fontSize: 16,  // Updated from 12 to 16
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        SizedBox(height: 4),
                      ],
                    ),
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

  Widget _buildImageGallery() {
    return Column(
      children: [
        // Main Image Display
        Container(
          width: 650, // Fixed consistent width for all images
          height: 500,
          decoration: BoxDecoration(
            color: Colors.white, // White background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    _imagePaths[_currentImageIndex],
                    fit: _imagePaths[_currentImageIndex].endsWith('.png') 
                        ? BoxFit.contain 
                        : BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Image not found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _imagePaths[_currentImageIndex].split('/').last,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Left Arrow
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _previousImage,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Right Arrow
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _nextImage,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Image Counter
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentImageIndex + 1} / ${_imagePaths.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 20),
        
        // Thumbnail Row with Navigation
        Center(
          child: Column(
            children: [
              Container(
                height: 80,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth - 80;
                    final thumbnailWidth = 92.0;
                    final maxFittable = (availableWidth / thumbnailWidth).floor();
                    
                    if (maxFittable < _thumbnailsPerPage && maxFittable >= _minThumbnailsPerPage) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _handleRenderFlexOverflow();
                      });
                    }
                    
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _thumbnailStartIndex > 0 ? _previousThumbnailPage : null,
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: _thumbnailStartIndex > 0 ? Colors.black : Colors.grey,
                            size: 20,
                          ),
                        ),
                        
                        Flexible(
                          child: Container(
                            width: _thumbnailsPerPage * 92.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _getVisibleThumbnailCount(),
                              itemBuilder: (context, index) {
                                int actualIndex = _thumbnailStartIndex + index;
                                bool isSelected = actualIndex == _currentImageIndex;
                                return GestureDetector(
                                  onTap: () => _selectImage(actualIndex),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    margin: EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                                        width: isSelected ? 3 : 1,
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.asset(
                                      _imagePaths[actualIndex],
                                      fit: _imagePaths[actualIndex].endsWith('.png') 
                                          ? BoxFit.contain 
                                          : BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.broken_image,
                                                size: 24,
                                                color: isSelected ? Colors.blue : Colors.grey.shade400,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${actualIndex + 1}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: isSelected ? Colors.blue : Colors.grey.shade600,
                                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        IconButton(
                          onPressed: _thumbnailStartIndex + _thumbnailsPerPage < _imagePaths.length ? _nextThumbnailPage : null,
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: _thumbnailStartIndex + _thumbnailsPerPage < _imagePaths.length ? Colors.black : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              SizedBox(height: 10),
              
              Text(
                'Images ${_thumbnailStartIndex + 1}-${_thumbnailStartIndex + _getVisibleThumbnailCount()} of ${_imagePaths.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectImage(int index) {
    setState(() {
      _currentImageIndex = index;
      _ensureThumbnailVisible(index);
    });
  }

  void _nextImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
      _ensureThumbnailVisible(_currentImageIndex);
    });
  }

  void _previousImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex - 1 + _imagePaths.length) % _imagePaths.length;
      _ensureThumbnailVisible(_currentImageIndex);
    });
  }

  void _nextThumbnailPage() {
    setState(() {
      _thumbnailStartIndex = (_thumbnailStartIndex + _thumbnailsPerPage).clamp(0, _imagePaths.length - _thumbnailsPerPage);
    });
  }

  void _previousThumbnailPage() {
    setState(() {
      _thumbnailStartIndex = (_thumbnailStartIndex - _thumbnailsPerPage).clamp(0, _imagePaths.length - 1);
    });
  }

  void _ensureThumbnailVisible(int imageIndex) {
    if (imageIndex < _thumbnailStartIndex || imageIndex >= _thumbnailStartIndex + _thumbnailsPerPage) {
      int targetPage = imageIndex ~/ _thumbnailsPerPage;
      _thumbnailStartIndex = (targetPage * _thumbnailsPerPage).clamp(0, _imagePaths.length - _thumbnailsPerPage);
    }
  }

  int _getVisibleThumbnailCount() {
    return (_imagePaths.length - _thumbnailStartIndex).clamp(1, _thumbnailsPerPage);  
  }
}