import 'package:flutter/material.dart';
import 'preview_page.dart';

class ScannedDocument {
  final String id;
  final String imagePath;
  final String title;
  final DateTime scanDate;

  ScannedDocument({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.scanDate,
  });
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  List<ScannedDocument> scannedDocuments = [];

  void _captureImage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PreviewPage(),
      ),
    );

    if (result != null && result is ScannedDocument) {
      setState(() {
        scannedDocuments.add(result);
      });
    }
  }

  void _pickImageFromGallery() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PreviewPage(),
      ),
    );

    if (result != null && result is ScannedDocument) {
      setState(() {
        scannedDocuments.add(result);
      });
    }
  }

  void _showDocumentsGallery() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scanned Documents (${scannedDocuments.length})',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: scannedDocuments.isEmpty
                    ? Center(
                        child: Text(
                          'No documents yet',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: scannedDocuments.length,
                        itemBuilder: (context, index) => ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.blue[700],
                            ),
                          ),
                          title: Text(scannedDocuments[index].title),
                          subtitle: Text(
                            'Scanned on ${_formatDate(scannedDocuments[index].scanDate)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                scannedDocuments.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentDetails(ScannedDocument document) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  size: 60,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                document.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Scanned on ${_formatDate(document.scanDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showShareDialog(document);
                    },
                    child: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog(ScannedDocument document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Document'),
        content: Text('Share "${document.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Shared "${document.title}"'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDocumentsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Scans',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: scannedDocuments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: scannedDocuments.length,
                    itemBuilder: (context, index) {
                      return _DocumentCard(
                        document: scannedDocuments[index],
                        onTap: () {
                          _showDocumentDetails(scannedDocuments[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Scanned Documents',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan your first document to get started',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DocScan Pro'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          if (scannedDocuments.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: _showDocumentsGallery,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.document_scanner,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Camera Preview',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _ScanOverlay(),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'Place your document within the frame and tap the camera button',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildDocumentsList(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _pickImageFromGallery,
            heroTag: 'gallery',
            mini: true,
            child: const Icon(Icons.photo_library),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _captureImage,
            heroTag: 'camera',
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final ScannedDocument document;
  final VoidCallback onTap;

  const _DocumentCard({
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    color: Colors.blue[50],
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 40,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title.length > 15
                            ? '${document.title.substring(0, 15)}...'
                            : document.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${document.scanDate.day}/${document.scanDate.month}/${document.scanDate.year}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ScannerOverlayPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cornerLength = 30.0;
    const cornerWidth = 4.0;
    const scanAreaRatio = 0.7;

    final width = size.width;
    final scanAreaSize = width * scanAreaRatio;
    final scanAreaRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize * 1.4,
    );

    final backgroundPaint = Paint()..color = Colors.black54;
    canvas.drawPath(
      Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRect(scanAreaRect),
      backgroundPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth;

    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.left, scanAreaRect.top + cornerLength)
        ..lineTo(scanAreaRect.left, scanAreaRect.top)
        ..lineTo(scanAreaRect.left + cornerLength, scanAreaRect.top),
      borderPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.right - cornerLength, scanAreaRect.top)
        ..lineTo(scanAreaRect.right, scanAreaRect.top)
        ..lineTo(scanAreaRect.right, scanAreaRect.top + cornerLength),
      borderPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.left, scanAreaRect.bottom - cornerLength)
        ..lineTo(scanAreaRect.left, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.left + cornerLength, scanAreaRect.bottom),
      borderPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.right - cornerLength, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.right, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.right, scanAreaRect.bottom - cornerLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}