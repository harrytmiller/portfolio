import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:convert';

class AI extends StatefulWidget {
  @override
  _AIState createState() => _AIState();
}

class _AIState extends State<AI> {
  // Scroll controller for custom scrollbar
  final ScrollController _scrollController = ScrollController();
  
  // Image gallery state
  int _currentImageIndex = 0;
  int _thumbnailStartIndex = 0;
  int _thumbnailsPerPage = 7;
  int _maxThumbnailsPerPage = 7;
  int _minThumbnailsPerPage = 3;
  bool _hasRenderFlex = false;
  
  // Add your AI project images here
  List<String> _imagePaths = [
    'assets/images/71.png',
    'assets/images/72.png',
    'assets/images/73.png',
    'assets/images/74.png',
    'assets/images/75.png',
    'assets/images/76.png',
    'assets/images/77.png',
    'assets/images/78.png',
    'assets/images/79.png',
    'assets/images/80.png',
    'assets/images/81.png',
    'assets/images/82.png',
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

  // Function to run Python files
  void _runPythonFile(int fileNumber) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading Python file $fileNumber...'),
              ],
            ),
          );
        },
      );

      String pythonCode;
      String description;
      bool needsDataset = false;
      String fileName = 'Q$fileNumber.py';

      // Load the appropriate Python file from pyfiles folder
      switch (fileNumber) {
        case 1:
          pythonCode = await rootBundle.loadString('pyfiles/Q1.py');
          description = 'Part A: Genetic Algorithm';
          break;
        case 2:
          pythonCode = await rootBundle.loadString('pyfiles/Q2.py');
          description = 'Part B: Genetic Algorithm';
          break;
        case 3:
          pythonCode = await rootBundle.loadString('pyfiles/Q3.py');
          description = 'Part C: Neural Network';
          break;
        case 4:
          pythonCode = await rootBundle.loadString('pyfiles/Q4.py');
          description = 'Part D: Neural Network (Requires Dataset)';
          needsDataset = true;
          break;
        default:
          throw Exception('Invalid file number');
      }

      // Close loading dialog
      Navigator.of(context).pop();

      // Show Python code in dialog with execution options
      _showPythonCodeDialog(fileNumber, pythonCode, description, needsDataset, fileName);

    } catch (e) {
      // Close loading dialog if it's open
      Navigator.of(context, rootNavigator: true).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading Q$fileNumber.py: File not found in pyfiles/'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showPythonCodeDialog(int fileNumber, String pythonCode, String description, bool needsDataset, String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                
                if (fileNumber == 4) ...[
                  SizedBox(height: 8),
                  Text(
                    'Note - For this file to run correctly it must be in the same folder as the dataset.',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
                if (fileNumber != 4)
                  SizedBox(height: 23),

                Expanded(
                  child: needsDataset 
                      ? Row(
                          children: [
                            // Python Code Section (Left Half)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Python Code',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: SingleChildScrollView(
                                        child: SelectableText(
                                          pythonCode,
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(width: 16),
                            
                            // Dataset Section (Right Half)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dataset File',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: FutureBuilder<String>(
                                        future: _loadDatasetContent(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 16),
                                                  Text('Loading dataset...'),
                                                ],
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.error, size: 48, color: Colors.red),
                                                  SizedBox(height: 8),
                                                  Text('Error loading dataset'),
                                                  SizedBox(height: 4),
                                                  Text('${snapshot.error}', 
                                                    style: TextStyle(fontSize: 12, color: Colors.red),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return SingleChildScrollView(
                                              child: SelectableText(
                                                snapshot.data ?? 'No dataset content',
                                                style: TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Python Code',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: SingleChildScrollView(
                                    child: SelectableText(
                                      pythonCode,
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                
                SizedBox(height: 16),
                
                // Buttons Section
                needsDataset 
                    ? Row(
                        children: [
                          // Code Buttons (Left)
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _downloadPythonFile(fileName, pythonCode),
                                    icon: Icon(Icons.download, size: 20),
                                    label: Text('Download Code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _copyToClipboard(pythonCode),
                                    icon: Icon(Icons.copy, size: 20),
                                    label: Text('Copy Code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(width: 16),
                          
                          // Dataset Buttons (Right)
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _downloadDataset(),
                                    icon: Icon(Icons.download, size: 20),
                                    label: Text('Download Dataset', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _copyDatasetToClipboard(),
                                    icon: Icon(Icons.copy, size: 20),
                                    label: Text('Copy Dataset', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _downloadPythonFile(fileName, pythonCode),
                            icon: Icon(Icons.download),
                            label: Text('Download Code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          
                          ElevatedButton.icon(
                            onPressed: () => _copyToClipboard(pythonCode),
                            icon: Icon(Icons.copy),
                            label: Text('Copy Code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _loadDatasetContent() async {
    try {
      // Load the dataset file from pyfiles folder
      final String datasetContent = await rootBundle.loadString('pyfiles/dataset.csv');
      return datasetContent;
    } catch (e) {
      throw Exception('Dataset file not found in pyfiles/dataset.csv');
    }
  }

  void _downloadDataset() async {
    try {
      // Load the dataset file from pyfiles folder
      final String datasetContent = await rootBundle.loadString('pyfiles/dataset.csv');
      
      final bytes = utf8.encode(datasetContent);
      final blob = html.Blob([bytes], 'text/csv');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      final anchor = html.AnchorElement()
        ..href = url
        ..download = 'dataset.csv'
        ..style.display = 'none';
      
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      
      html.Url.revokeObjectUrl(url);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dataset downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dataset download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyDatasetToClipboard() async {
    try {
      final String datasetContent = await rootBundle.loadString('pyfiles/dataset.csv');
      Clipboard.setData(ClipboardData(text: datasetContent));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dataset copied to clipboard!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to copy dataset: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _downloadPythonFile(String fileName, String pythonCode) async {
    try {
      final bytes = utf8.encode(pythonCode);
      final blob = html.Blob([bytes], 'text/plain');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      final anchor = html.AnchorElement()
        ..href = url
        ..download = fileName
        ..style.display = 'none';
      
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      
      html.Url.revokeObjectUrl(url);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$fileName downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Code copied to clipboard!')),
    );
  }

  // Widget for creating Python runner buttons
  Widget _buildPythonButton(int fileNumber, String label, Color color) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _runPythonFile(fileNumber),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLayoutSpace());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Artificial Intelligence', 
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

                // Main Content Section
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
                          'Genetic Algorithms and Neural Networks',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 16),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                           'This page documents coursework completed for my Artificial Intelligence module. Working as a group of 4, we developed 4 AI applications using python. Each application scenario had set requirements of what it should do. Parts A and B are genetic algorithms and parts C and D neural networks. All applications include visual representations using matplotlib to show results. All applications run through terminal with interactive prompts allowing users to adjust parameters. Click the buttons below to view the python files with the option to download or copy code. There are also screenshots of the requirements, terminal output, and visual output.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        SizedBox(height: 30),
                        
                        // First row of buttons
                        Row(
                          children: [
                            _buildPythonButton(1, 'Part A', Colors.blue),
                            SizedBox(width: 12),
                            _buildPythonButton(2, 'Part B', Colors.blue),
                          ],
                        ),
                        
                        SizedBox(height: 15),
                        
                        // Second row of buttons
                        Row(
                          children: [
                            _buildPythonButton(3, 'Part C', Colors.blue),
                            SizedBox(width: 12),
                            _buildPythonButton(4, 'Part D', Colors.blue),
                          ],
                        ),
                        
                        SizedBox(height: 42),
                        
                        // Image Gallery
                        _buildImageGallery(),
                        
                      ],
                    ),
                  ),
                ),

                // Download Section
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
                          'Submission Folder',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 16),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'The \'Download Submission Folder\' button will download the complete project submission folder. This folder contains all the code files, dataset, brief, documentation, and contributions.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                final ByteData data = await rootBundle.load('folders/AI_Submission.zip');
                                final Uint8List bytes = data.buffer.asUint8List();
                                
                                final blob = html.Blob([bytes], 'application/zip');
                                final url = html.Url.createObjectUrlFromBlob(blob);
                                
                                final anchor = html.AnchorElement()
                                  ..href = url
                                  ..download = 'AI_Submission_Folder.zip'
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
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
          width: 1000,
          height: 600,
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
                  borderRadius: BorderRadius.circular(12),
                  child: _imagePaths.isNotEmpty
                      ? Image.asset(
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
                        )
                      : Center(
                          child: Text(
                            'No images available',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              
              if (_imagePaths.isNotEmpty) ...[
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
            ],
          ),
        ),
        
        if (_imagePaths.length > 1) ...[
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