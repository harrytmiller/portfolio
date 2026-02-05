import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final ScrollController _scrollController = ScrollController();

  int _currentImageIndex = 0;
  int _thumbnailStartIndex = 0;
  int _thumbnailsPerPage = 4;
  int _maxThumbnailsPerPage = 4;
  int _minThumbnailsPerPage = 3;
  bool _hasRenderFlex = false;

  List<String> _imagePaths = [
    'assets/images/151.png',
    'assets/images/151.1.png',
    'assets/images/152.png',
    'assets/images/153.png',
    'assets/images/154.png',
    'assets/images/155.png',
    'assets/images/156.png',
    'assets/images/157.png',
    'assets/images/158.png',
  ];

  void _launchURL(String url) {
    html.window.open(url, '_blank');
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
          _thumbnailStartIndex =
              (_imagePaths.length - _thumbnailsPerPage).clamp(0, _imagePaths.length - 1);
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

        if (maxFittable > _thumbnailsPerPage &&
            _thumbnailsPerPage < _maxThumbnailsPerPage) {
          setState(() {
            _thumbnailsPerPage =
                (maxFittable).clamp(_minThumbnailsPerPage, _maxThumbnailsPerPage);
            if (_thumbnailsPerPage == _maxThumbnailsPerPage) {
              _hasRenderFlex = false;
            }
          });
        }
      }
    });
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
        title: Text(
          'Message App',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                          'Message App',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          child: Text(
                            'I programmed this app using Javascript with React, I also used JSX and inline styling. It uses Firebase for authentication and Firestore for real-time data storage. Users can create an account and sign in to create a profile with a unique username. Users can search for other users by username and send friend requests. When a friend request is accepted, a chat is automatically created between the two users. Messages are sent and received in real-time using Firestore listeners. Users can view all their conversations on the main dashboard and delete chats they no longer need. The app also includes a dark/light mode toggle that saves to local storage.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _launchURL(
                                  'https://harrytmiller.github.io/message-app/'),
                              child: Text(
                                'Live Demo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(width: 24),
                            GestureDetector(
                              onTap: () => _launchURL(
                                  'https://github.com/harrytmiller/message-app'),
                              child: Text(
                                'GitHub Repository',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        _buildImageGallery(),
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
        Container(
          width: 768,
          height: 364,
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
                    fit: BoxFit.contain,
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
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

                    if (maxFittable < _thumbnailsPerPage &&
                        maxFittable >= _minThumbnailsPerPage) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _handleRenderFlexOverflow();
                      });
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed:
                              _thumbnailStartIndex > 0 ? _previousThumbnailPage : null,
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
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey.shade300,
                                        width: isSelected ? 3 : 1,
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.asset(
                                      _imagePaths[actualIndex],
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 24,
                                            color: isSelected
                                                ? Colors.blue
                                                : Colors.grey.shade400,
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
                          onPressed: _thumbnailStartIndex + _thumbnailsPerPage < _imagePaths.length
                              ? _nextThumbnailPage
                              : null,
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: _thumbnailStartIndex + _thumbnailsPerPage < _imagePaths.length
                                ? Colors.black
                                : Colors.grey,
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
      _currentImageIndex =
          (_currentImageIndex - 1 + _imagePaths.length) % _imagePaths.length;
      _ensureThumbnailVisible(_currentImageIndex);
    });
  }

  void _nextThumbnailPage() {
    setState(() {
      _thumbnailStartIndex = (_thumbnailStartIndex + _thumbnailsPerPage)
          .clamp(0, _imagePaths.length - _thumbnailsPerPage);
    });
  }

  void _previousThumbnailPage() {
    setState(() {
      _thumbnailStartIndex = (_thumbnailStartIndex - _thumbnailsPerPage)
          .clamp(0, _imagePaths.length - 1);
    });
  }

  void _ensureThumbnailVisible(int imageIndex) {
    if (imageIndex < _thumbnailStartIndex ||
        imageIndex >= _thumbnailStartIndex + _thumbnailsPerPage) {
      int targetPage = imageIndex ~/ _thumbnailsPerPage;
      _thumbnailStartIndex = (targetPage * _thumbnailsPerPage)
          .clamp(0, _imagePaths.length - _thumbnailsPerPage);
    }
  }

  int _getVisibleThumbnailCount() {
    return (_imagePaths.length - _thumbnailStartIndex).clamp(1, _thumbnailsPerPage);
  }
}