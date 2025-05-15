class CurrentLocationService {
  static String page = 'unknown';
  static String? chapterName;

  static void setPage(String newPage, {String? chapter}) {
    page = newPage;
    chapterName = chapter;
  }

  static String getLocationMessage() {
    switch (page) {
      case 'home':
        return "You are at the home screen.";
      case 'chat':
        return "You are in the chatbot.";
      case 'chapter_list':
        return "You are in the chapter list.";
      case 'chapter_detail':
        return "You are in ${chapterName ?? ''} page.";
      case 'exercise':
        return "You are in the exercise of ${chapterName ?? ''}.";
      case 'quiz':
        return "You are in the quiz.";
      case 'guide':
        return "You are in the command guide.";
      default:
        return "You are in an unknown location.";
    }
  }
}
