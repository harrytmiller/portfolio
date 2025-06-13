import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class Design extends StatefulWidget {
  @override
  _DesignState createState() => _DesignState();
}

class _DesignState extends State<Design> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  String _errorMessage = '';
  bool _isLoading = true;
  
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
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
    'assets/images/5.jpg',
    'assets/images/6.jpg',
    'assets/images/7.jpg',
    'assets/images/8.png',
    'assets/images/9.png',
    'assets/images/10.png',
    'assets/images/11.png',
    'assets/images/12.png',
        'assets/images/64.png',

    'assets/images/13.png',
    'assets/images/14.png',
    'assets/images/15.png',
    'assets/images/16.png',
    'assets/images/17.png',
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
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

  void _initializeVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      List<String> videoSources = [
        'assets/videos/render.mp4',
      ];

      VideoPlayerController? workingController;
      
      for (String source in videoSources) {
        try {
          workingController = VideoPlayerController.asset(source);
          await workingController.initialize();
          break;
        } catch (e) {
          workingController?.dispose();
          workingController = null;
        }
      }

      if (workingController != null) {
        setState(() {
          _controller = workingController;
          _isVideoInitialized = true;
          _isLoading = false;
        });
      } else {
        throw Exception('No compatible video format found');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Video format not supported by browser';
        _isVideoInitialized = false;
        _isLoading = false;
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
    _controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLayoutSpace());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Design and Animation', 
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

                // Video Section
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
                          'Animation Render',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                                                SizedBox(height: 16),

                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'This page showcases my 3D design and animation project completed as one of my university courseworks. The project explores key aspects of both design and animation including modeling, texturing, lighting, rigging and animation using Autodesk\'s 3Ds Max. This is my first and only time modeling or animating, however it is a side of computing that I am interested in. I would be very open to completing or taking part in modelling and animation projects in my future.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'The video below is my final render for the animation side of my project and depicts my character model as the subject of an ice skating animation. I created the model, scene and animation. ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                              SizedBox(height: 12),

                        Center(
                          child: Container(
                            width: 768,
                            height: 452,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: _buildVideoPlayer(),
                          ),
                        ),
                        
                        SizedBox(height: 30),
                        _buildVideoControls(),
                      ],
                    ),
                  ),
                ),

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
                          'Project Gallery',
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
                            'These are the images related to the design side of the project. Images 1-7 are renderings of my character model in a scene of a log cabin in the mountains. I created my character and scene models but not the textures used for my scene. Images 8-17 are screenshots of biped poses demonstrating the rigging of my character model.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        SizedBox(height: 16),
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
                          'Write Ups and Submission Folder',
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
                                '-The \'View design write up\' button will open a pdf file that documents my design process in a new tab.',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              Text(
                                '-The \'View animation write up\' button will open a pdf file that documents my animation process in a new tab.',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              Text(
                                '-The \'Download submission folder\' button will download my submission folder. This folder contains: intermediate and final .max files, both animation and design write ups, supporting files, rederings, and screenshots of rigged model poses.',
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
                                  _openPDFViewer('assets/files/design_writeup.pdf', 'Design Write-up');
                                },
                                icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                                label: Text(
                                  'View Design Write Up',
                                  style: TextStyle(
                                      fontSize: 16,  // Updated from 14 to 16
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
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _openPDFViewer('assets/files/animation_writeup.pdf', 'Animation Write-up');
                                },
                                icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                                label: Text(
                                  'View Animation Write Up',
                                  style: TextStyle(
                                      fontSize: 16,  // Updated from 14 to 16
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
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  try {
                                    final ByteData data = await rootBundle.load('assets/folders/Coursework.zip');
                                    final Uint8List bytes = data.buffer.asUint8List();
                                    
                                    final blob = html.Blob([bytes], 'application/zip');
                                    final url = html.Url.createObjectUrlFromBlob(blob);
                                    
                                    final anchor = html.AnchorElement()
                                      ..href = url
                                      ..download = 'Coursework_Submission.zip'
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
                                  'Download Submission Folder',
                                  style: TextStyle(
                                      fontSize: 16,  // Updated from 14 to 16
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

  Widget _buildVideoPlayer() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_isVideoInitialized && _controller != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover, 
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library, color: Colors.white, size: 50),
          SizedBox(height: 15),
          Text(
            '3D Animation Demo Reel',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            _errorMessage.isNotEmpty
                ? 'Video preview not available in browser'
                : 'Loading video...',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 8),
          Text(
            'Contact me to view the full demo reel',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: _initializeVideo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Retry',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _isVideoInitialized && _controller != null
              ? () {
                  setState(() {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                }
              : null,
          icon: Icon(
            _isVideoInitialized &&
                    _controller != null &&
                    _controller!.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
            color: _isVideoInitialized ? Colors.black : Colors.grey,
            size: 30,
          ),
        ),
        SizedBox(width: 20),
        IconButton(
          onPressed: _isVideoInitialized && _controller != null
              ? () {
                  _controller!.seekTo(Duration.zero);
                  _controller!.pause();
                }
              : null,
          icon: Icon(
            Icons.stop,
            color: _isVideoInitialized ? Colors.black : Colors.grey,
            size: 30,
          ),
        ),
        SizedBox(width: 20),
        IconButton(
          onPressed: _initializeVideo,
          icon: Icon(
            Icons.refresh,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
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