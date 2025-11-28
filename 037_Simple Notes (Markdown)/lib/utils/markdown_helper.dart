class MarkdownHelper {
  static String getPlainText(String markdown) {
    if (markdown.isEmpty) return '';
    
    // Simple markdown to plain text conversion
    return markdown
        .replaceAll(RegExp(r'^#+\s', multiLine: true), '') // Headers
        .replaceAll(RegExp(r'\*\*'), '') // Bold
        .replaceAll(RegExp(r'\*'), '') // Italic
        .replaceAll(RegExp(r'`'), '') // Inline code
        .replaceAll(RegExp(r'^>\s', multiLine: true), '') // Blockquotes
        .replaceAll(RegExp(r'^-\s\[.\]\\s', multiLine: true), '') // Task items
        .replaceAll(RegExp(r'^-\s', multiLine: true), '') // List items
        .replaceAll(RegExp(r'\[.*?\]'), '') // Links
        .trim();
  }

  static String getPreviewText(String markdown) {
    final plainText = getPlainText(markdown);
    if (plainText.isEmpty) return 'No content';
    return plainText.length > 100 
        ? '${plainText.substring(0, 100)}...' 
        : plainText;
  }
}