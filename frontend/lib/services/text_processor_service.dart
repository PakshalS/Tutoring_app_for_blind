class TextProcessorService {
  static const Map<String, String> symbolMap = {
    '+': 'plus',
    '-': 'minus',
    '/': 'divided by',
    '*': 'multiplied by',
    '=': 'equals',
    '^': 'to the power of',
    '(': 'open bracket',
    ')': 'close bracket',
    '%': 'percent',
    '...': 'and so on'
  };

  /// Replace symbols with descriptive words.
  String processText(String text) {
    String processedText = text;
    symbolMap.forEach((symbol, word) {
      processedText = processedText.replaceAll(symbol, ' $word ');
    });
    return processedText;
  }

  /// Recursively collect content from sections and subsections.
  String collectContent(Map<String, dynamic> section) {
    String content = '';

    // Add section title.
    content += 'Section: ${section['name'] ?? 'Unnamed Section'}.\n';

    // Add section content.
    if (section['content'] != null) {
      content += '${(section['content'] as List<dynamic>).join('. ')}. ';
    }

    // Process subsections.
    if (section['subsections'] != null) {
      (section['subsections'] as Map<String, dynamic>).forEach((_, subsection) {
        content +=
            'Subsection: ${subsection['name'] ?? 'Unnamed Subsection'}.\n';
        content += '${(subsection['content'] as List<dynamic>).join('. ')}. ';
      });
    }

    return processText(content);
  }
}
