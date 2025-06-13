import 'package:flutter/material.dart';

class PostUni extends StatefulWidget {
  @override
  _PostUniState createState() => _PostUniState();
}

class _PostUniState extends State<PostUni> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Uni', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 169, 169, 169),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
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
                        'Professional Machine Learning Implementation',
                        style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                      SizedBox(height: 30),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 16), // Left spacing for text
                          Expanded(
                            flex: 2,
                            child: Text(
                              'This comprehensive professional project involved the development and deployment of a machine learning system for a Fortune 500 company, focusing on predictive analytics for supply chain optimization. Working as part of a cross-functional team, I designed and implemented neural network architectures using TensorFlow and PyTorch, processing over 10 million data points to identify patterns in inventory management and demand forecasting. The system achieved a 94% accuracy rate in predicting supply chain disruptions, resulting in cost savings of approximately \$2.3 million annually for the client. The project required extensive data preprocessing, feature engineering, and model validation across multiple business units. I also developed a real-time dashboard using React and D3.js that allows stakeholders to visualize predictions and adjust parameters dynamically. The implementation included robust error handling, automated model retraining pipelines, and comprehensive documentation for future maintenance. This project demonstrated the practical application of advanced machine learning techniques in enterprise environments and showcased my ability to translate complex algorithms into business value.',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 450,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Image',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(width: 16), // Right spacing for image
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 0),
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Download started!')),
                            );
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
                            'Download File',
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
                        'More Works Coming Soon',
                        style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                      SizedBox(height: 30),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 16), // Left spacing for text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.construction,
                                  size: 80,
                                  color: Colors.black54,
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'This section is currently under development as I continue to work on exciting new projects in my professional career. Check back soon for updates on my latest accomplishments, research contributions, and professional milestones. I am actively working on several innovative projects that will be showcased here once completed.',
                                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Stay tuned for more content!',
                                  style: TextStyle(fontSize: 16, color: Colors.black54, fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16), // Right spacing
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 0),
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No files available yet - check back soon!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          child: Text(
                            'Coming Soon',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }
}