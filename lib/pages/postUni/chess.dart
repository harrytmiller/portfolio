import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class Chess extends StatefulWidget {
  const Chess({Key? key}) : super(key: key);

  @override
  _ChessState createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  // Scroll controller for custom scrollbar
  final ScrollController _scrollController = ScrollController();
  
  // Image gallery state
  int _currentImageIndex = 0;
  int _thumbnailStartIndex = 0;
  int _thumbnailsPerPage = 5;
  int _maxThumbnailsPerPage = 3;
  int _minThumbnailsPerPage = 3;
  bool _hasRenderFlex = false;
  
  List<String> _imagePaths = [
    'assets/images/100.png',
    'assets/images/101.png',
    'assets/images/101.1.png',
    'assets/images/102.png',
    'assets/images/103.png',
    'assets/images/104.png',
    'assets/images/105.png',
        'assets/images/106.png',
    'assets/images/107.png',
    'assets/images/108.png',
    'assets/images/109.png',
    'assets/images/110.png',
    'assets/images/111.png',
    'assets/images/112.png',

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
    return BoxFit.contain;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLayoutSpace());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chess Game', 
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 169, 169, 169),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[800],
      body: RawScrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 8.0,
        radius: const Radius.circular(6),
        interactive: true,
        thumbColor: Colors.grey.shade700,
        trackColor: const Color.fromARGB(255, 169, 169, 169),
        trackRadius: const Radius.circular(6),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Image Gallery Section
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 169, 169, 169),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'AI Chess Game',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                          "I developed a chess application featuring both local multiplayer and AI opponents with three difficulty levels. The game implements all standard chess rules including interactive piece movement with validation, check/checkmate detection, and pawn promotion. The AI system uses evaluation and decision-making algorithms regarding all potential moves.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 12),

                        Text(
                          "The backend was developed using Java and Spring Boot framework. I created comprehensive chess logic with turn management, game state handling, and complete move validation for all piece types. The backend also includes an AI decision-making system that chooses moves based on piece value algorithms and positional analysis with strategic move selection across three difficulty levels. I configured GraphQL with queries for game state retrieval and mutations for game creation and move processing, with CORS configuration for frontend communication.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                                            SizedBox(height: 12),

                         Text(
                          'The frontend was developed using JavaScript with React functional components, Next.js framework, JSX/HTML for markup, and CSS-in-JS for styling. I created an interactive chess board component with click-based piece selection and movement. The responsive UI design also includes game mode selection as well as visual check and checkmate notifications. I implemented real-time game state synchronization using Apollo Client for GraphQL communication with the backend, including automatic polling to detect and get AI moves in real-time.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 12),

                        Text(
                          'The application is built using Docker containerization with Docker Compose for multi-service orchestration. It uses Maven for automated backend builds and dependency management. It follows microservices architecture with separate frontend and backend containers communicating through GraphQL APIs.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                                            SizedBox(height: 12),
                      Text(
                          'All chess rules, AI algorithms, game logic, and board mechanics were programmed without using external APIs or chess libraries.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),



                      const SizedBox(height: 16),

                      Container(
                        child: GestureDetector(
                          onTap: () => _launchURL('https://github.com/harrytmiller/chess'),
                          child: const Text(
                            'Link to GitHub Repository',
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
                      
                      const SizedBox(height: 30),

                      _buildImageGallery(),

                    ],
                  ),
                ),
              ),

              // Project Info Section
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 169, 169, 169),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Code Folder',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Column(
                          children: [
                            Text(
                              '-The \'Download Code Folder\' button downloads the complete code for my chess application.',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                 
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final ByteData data = await rootBundle.load('assets/folders/chess.zip');
                              final Uint8List bytes = data.buffer.asUint8List();
                              
                              final blob = html.Blob([bytes], 'application/zip');
                              final url = html.Url.createObjectUrlFromBlob(blob);
                              
                              final anchor = html.AnchorElement()
                                ..href = url
                                ..download = 'chess.zip'
                                ..style.display = 'none';
                              
                              html.document.body!.append(anchor);
                              anchor.click();
                              anchor.remove();
                              
                              html.Url.revokeObjectUrl(url);
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Download started!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Download failed: File not found'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.download,
                                color: Colors.white,
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

              const SizedBox(height: 50),
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
                    fit: _getImageFit(_currentImageIndex),
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
                              const SizedBox(height: 16),
                              Text(
                                'Image not found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
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
                      icon: const Icon(
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
                      icon: const Icon(
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentImageIndex + 1} / ${_imagePaths.length}',
                    style: const TextStyle(
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
        
        const SizedBox(height: 20),
        
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
                                    margin: const EdgeInsets.only(right: 12),
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
                                      fit: _getImageFit(actualIndex),
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
                                              const SizedBox(height: 4),
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
              
              const SizedBox(height: 10),
              
              Text(
                'Images ${_thumbnailStartIndex + 1}-${_thumbnailStartIndex + _getVisibleThumbnailCount()} of ${_imagePaths.length}',
                style: const TextStyle(
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