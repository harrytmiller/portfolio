import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Scroll controller for custom scrollbar
  final ScrollController _scrollController = ScrollController();
  
  // Image gallery state
  int _currentImageIndex = 0;
  int _thumbnailStartIndex = 0;
  int _thumbnailsPerPage = 4;
  int _maxThumbnailsPerPage = 3;
  int _minThumbnailsPerPage = 3;
  bool _hasRenderFlex = false;
  
  List<String> _imagePaths = [
    'assets/images/67.png',
    'assets/images/68.png',
    'assets/images/69.png',
    'assets/images/70.png', // Added image 70
  ];

  void _launchURL(String url) {
    html.window.open(url, '_blank');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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

  // Helper method to determine BoxFit for specific images
  BoxFit _getImageFit(int imageIndex) {
    String imagePath = _imagePaths[imageIndex];
    if (imagePath.contains('70.png')) {
      return BoxFit.fitWidth;
    }
    return BoxFit.cover;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLayoutSpace());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My First App', 
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
                        'Movie Recommender',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(height: 16),
                      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        child: Text(
                          'This is the first app I ever made. I made a decision map based movie recommender. I made it during my second year at university and It was completed for the implementation side of my user experience design and implementation module. I made the app on flutter/dart and it uses a CSV decision map. Each row in the CSV represents a node containing text, image path and navigation IDs for different user choices (yes/no/back/restart). Below is a link to a running prototype of the app as well as screenshots of the interface and CSV file. I made some changes after submission as when I made this I was new to software engineering and I was still experimenting with building Interfaces and making apps.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      SizedBox(height: 16),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        child: GestureDetector(
                          onTap: () => _launchURL('https://harrytmiller.github.io/movie_recommender-/'),
                          child: Text(
                            'Link to running prototype',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              height: 1.4,
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
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Code Folder',
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
                              '-The \'Download Code Folder\' button downloads the code folder for my app.',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                 
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final ByteData data = await rootBundle.load('assets/folders/movie_recommender.zip');
                              final Uint8List bytes = data.buffer.asUint8List();
                              
                              final blob = html.Blob([bytes], 'application/zip');
                              final url = html.Url.createObjectUrlFromBlob(blob);
                              
                              final anchor = html.AnchorElement()
                                ..href = url
                                ..download = 'movie_recommender.zip'
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.download,
                                color: Colors.white,
                                // Removed size: 16 to use default size for consistency
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Download Code Folder',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
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
          width: 768,
          height: 432,
          decoration: BoxDecoration(
            color: Colors.white,
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
                    fit: _getImageFit(_currentImageIndex), // Use conditional fit
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
                                      fit: _getImageFit(actualIndex), // Use conditional fit for thumbnails too
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