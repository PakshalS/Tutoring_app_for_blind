import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  int _currentLineIndex = 0; // Track the current line for skipping

  final List<String> _contentLines = [
    "Profit and Loss",
    " ",
    "1. Introduction",
    "In business mathematics, profit and loss are fundamental concepts that quantify the financial performance of a business.",
    "This chapter explores the mathematical relationships between cost, revenue, and profit.",
    " ",
    "2. Basic Definitions",
    "Let:",
    "C = Cost price (the amount spent to produce or acquire goods)",
    "S = Selling price (the amount received from selling goods)",
    "P = Profit (positive) or Loss (negative)",
    " ",
    "3. Fundamental Equations",
    "3.1 Profit Equation",
    "When S > C, a profit is made: P = S - C",
    "3.2 Loss Equation",
    "When C > S, a loss is incurred: P = S - C (note: P will be negative in this case)",
    " ",
    "4. Formulas",
    "4.1 Profit Percentage",
    "Profit percentage is calculated as a percentage of the cost price:",
    "Profit % = (P / C) × 100%",
    "         = ((S - C) / C) × 100%",
    " ",
    "4.2 Loss Percentage",
    "Loss percentage is also calculated as a percentage of the cost price:",
    "Loss % = (L / C) × 100%",
    "       = ((C - S) / C) × 100%",
    " ",
    "5. Markup and Margin",
    "5.1 Markup",
    "Markup is the amount added to the cost price to determine the selling price:",
    "Markup = S - C",
    "Markup % = ((S - C) / C) × 100%",
    " ",
    "5.2 Margin",
    "Margin is the profit expressed as a percentage of the selling price:",
    "Margin = (P / S) × 100%",
    "       = ((S - C) / S) × 100%",
    " ",
    "6. Break-Even Point",
    "The break-even point occurs when total revenue equals total cost (i.e., no profit or loss):",
    "Let Q = Quantity sold",
    "    F = Fixed costs",
    "    V = Variable cost per unit",
    "    P = Price per unit",
    "Break-even quantity: Q = F / (P - V)",
    " ",
    "7. Exercises",
    "1. A retailer buys a product for Rs.80 and sells it for Rs.100. Calculate:",
    "   a) The profit",
    "   b) The profit percentage",
    "   c) The markup percentage",
    " ",
    "2. A company incurs a loss of 15% on a product that cost Rs.200. What was the selling price?",
    " ",
    "3. If the fixed costs for a business are Rs.10,000 per month, the variable cost per unit is Rs.5, and the selling price per unit is Rs.15, calculate the break-even quantity.",
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.4); // Adjust speech rate for clarity
    _flutterTts.setPitch(0.9);
  }

  Future<void> _readContent() async {
    if (_isSpeaking) return;
    setState(() {
      _isSpeaking = true;
      _currentLineIndex = 0; // Start from the top when reading
    });

    // Read the entire content in one go
    String content = _contentLines.join("\n");

    // Create content for TTS by replacing symbols with their names
    String contentForTTS = content
        .replaceAll("/", "divide by")
        .replaceAll("+", "plus")
        .replaceAll("-", "minus")
        .replaceAll("×", "multiplied by")
        .replaceAll("÷", "divided by")
        .replaceAll("(", "bracket open")
        .replaceAll(")", "bracket close");

    await _flutterTts.speak(contentForTTS);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _skipLines() async {
    if (_isSpeaking) return;
    setState(() {
      _isSpeaking = true;
    });

    // Skip 3 lines at a time
    _currentLineIndex =
        (_currentLineIndex + 3).clamp(0, _contentLines.length - 1);

    String content = _contentLines.sublist(_currentLineIndex).join("\n");

    // Create content for TTS by replacing symbols with their names
    String contentForTTS = content
        .replaceAll("/", "divide by")
        .replaceAll("+", "plus")
        .replaceAll("-", "minus")
        .replaceAll("×", "multiplied by")
        .replaceAll("÷", "divided by")
        .replaceAll("(", "bracket open")
        .replaceAll(")", "bracket close");

    await _flutterTts.speak(contentForTTS);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _stopReading() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Profit and Loss Formulas",
              style: TextStyle(
                fontSize: 30, // Increased font size
                fontWeight: FontWeight.bold,
                color: Colors.yellow, // High contrast color
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _contentLines.join("\n"),
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors
                          .white), // Larger font size and contrasting color
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // High contrast button color
                foregroundColor: Colors.black, // High contrast text color
              ),
              onPressed: _isSpeaking ? _stopReading : _readContent,
              child: Text(_isSpeaking ? 'Stop Reading...' : 'Read Content'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // High contrast button color for skipping
                foregroundColor: Colors.white,
              ),
              onPressed: _isSpeaking
                  ? _stopReading
                  : _skipLines, // Skip 3 lines at a time
              child: const Text('Skip 3 Lines'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // High contrast background color
    );
  }
}
