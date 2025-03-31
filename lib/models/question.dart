class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

final List<Question> sampleQuestions = [
  Question(
    questionText: 'What does HTTP stand for?',
    options: ['HyperText Transition Protocol', 'HyperText Transmission Protocol', 'Hyper Transfer Text Protocol', 'HyperText Transfer Protocol'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'Which of the following is a NoSQL database?',
    options: ['MongoDB', 'MySQL', 'PostgreSQL', 'SQLite'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'Which data structure uses LIFO (Last In First Out)?',
    options: ['Stack', 'Queue', 'Tree', 'Linked List'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'What is the time complexity of the best-case scenario for Quicksort?',
    options: ['O(n)', 'O(n^2)', 'O(log n)', 'O(n log n)'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'Which protocol is used to send emails?',
    options: ['SMTP', 'FTP', 'SNMP', 'HTTP'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'Which of the following is used to style web pages?',
    options: ['HTML', 'CSS', 'XML', 'Python'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which of the following is used to style web pages?',
    options: ['CSS', 'HTML', 'XML', 'Python'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'Which keyword is used to inherit a class in Java?',
    options: ['inherits', 'implements', 'extends', 'super'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which protocol is used to send emails?',
    options: ['FTP', 'SMTP', 'SNMP', 'HTTP'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which protocol is used to send emails?',
    options: ['HTTP', 'SNMP', 'SMTP', 'FTP'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which data structure uses LIFO (Last In First Out)?',
    options: ['Queue', 'Tree', 'Linked List', 'Stack'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'What does HTTP stand for?',
    options: ['HyperText Transfer Protocol', 'HyperText Transition Protocol', 'Hyper Transfer Text Protocol', 'HyperText Transmission Protocol'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'What is Agile in software development?',
    options: ['A database type', 'An encryption algorithm', 'A programming language', 'A methodology focused on iterative development'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'What does HTTP stand for?',
    options: ['Hyper Transfer Text Protocol', 'HyperText Transmission Protocol', 'HyperText Transfer Protocol', 'HyperText Transition Protocol'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which keyword is used to inherit a class in Java?',
    options: ['inherits', 'extends', 'super', 'implements'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which data structure uses LIFO (Last In First Out)?',
    options: ['Queue', 'Linked List', 'Stack', 'Tree'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which of the following is a NoSQL database?',
    options: ['PostgreSQL', 'SQLite', 'MySQL', 'MongoDB'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'Which of the following is a NoSQL database?',
    options: ['MySQL', 'MongoDB', 'PostgreSQL', 'SQLite'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'What is the time complexity of the best-case scenario for Quicksort?',
    options: ['O(n)', 'O(log n)', 'O(n log n)', 'O(n^2)'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which protocol is used to send emails?',
    options: ['HTTP', 'SMTP', 'FTP', 'SNMP'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which language is primarily used for Android development?',
    options: ['Dart', 'Python', 'Kotlin', 'Swift'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'What is Agile in software development?',
    options: ['A programming language', 'A methodology focused on iterative development', 'A database type', 'An encryption algorithm'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which data structure uses LIFO (Last In First Out)?',
    options: ['Queue', 'Linked List', 'Stack', 'Tree'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which of the following is a NoSQL database?',
    options: ['SQLite', 'PostgreSQL', 'MongoDB', 'MySQL'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which data structure uses LIFO (Last In First Out)?',
    options: ['Queue', 'Linked List', 'Stack', 'Tree'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'What is the primary purpose of DNS?',
    options: ['Encrypts data', 'Translates domain names to IP addresses', 'Transfers files', 'Routes packets'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'What is the primary purpose of DNS?',
    options: ['Encrypts data', 'Translates domain names to IP addresses', 'Routes packets', 'Transfers files'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which data structure uses LIFO (Last In First Out)?',
    options: ['Stack', 'Tree', 'Queue', 'Linked List'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'What is Agile in software development?',
    options: ['An encryption algorithm', 'A database type', 'A programming language', 'A methodology focused on iterative development'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'Which keyword is used to inherit a class in Java?',
    options: ['inherits', 'implements', 'extends', 'super'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'What does HTTP stand for?',
    options: ['HyperText Transfer Protocol', 'Hyper Transfer Text Protocol', 'HyperText Transition Protocol', 'HyperText Transmission Protocol'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'What does HTTP stand for?',
    options: ['HyperText Transfer Protocol', 'HyperText Transmission Protocol', 'Hyper Transfer Text Protocol', 'HyperText Transition Protocol'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'Which of the following is a NoSQL database?',
    options: ['MySQL', 'PostgreSQL', 'SQLite', 'MongoDB'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'Which language is primarily used for Android development?',
    options: ['Python', 'Kotlin', 'Dart', 'Swift'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'What is the time complexity of the best-case scenario for Quicksort?',
    options: ['O(log n)', 'O(n)', 'O(n log n)', 'O(n^2)'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which protocol is used to send emails?',
    options: ['HTTP', 'FTP', 'SMTP', 'SNMP'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'What is the primary purpose of DNS?',
    options: ['Routes packets', 'Transfers files', 'Encrypts data', 'Translates domain names to IP addresses'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'Which of the following is a NoSQL database?',
    options: ['SQLite', 'MongoDB', 'PostgreSQL', 'MySQL'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which protocol is used to send emails?',
    options: ['SMTP', 'FTP', 'HTTP', 'SNMP'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'Which language is primarily used for Android development?',
    options: ['Dart', 'Python', 'Swift', 'Kotlin'],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'What is the primary purpose of DNS?',
    options: ['Translates domain names to IP addresses', 'Encrypts data', 'Routes packets', 'Transfers files'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'Which of the following is a NoSQL database?',
    options: ['MongoDB', 'MySQL', 'PostgreSQL', 'SQLite'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'What is the time complexity of the best-case scenario for Quicksort?',
    options: ['O(n^2)', 'O(n log n)', 'O(log n)', 'O(n)'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which keyword is used to inherit a class in Java?',
    options: ['implements', 'extends', 'inherits', 'super'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which of the following is used to style web pages?',
    options: ['CSS', 'HTML', 'XML', 'Python'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'What is the primary purpose of DNS?',
    options: ['Encrypts data', 'Translates domain names to IP addresses', 'Transfers files', 'Routes packets'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'What is the time complexity of the best-case scenario for Quicksort?',
    options: ['O(n log n)', 'O(log n)', 'O(n^2)', 'O(n)'],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: 'What is the time complexity of the best-case scenario for Quicksort?',
    options: ['O(log n)', 'O(n^2)', 'O(n log n)', 'O(n)'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which data structure uses LIFO (Last In First Out)?',
    options: ['Tree', 'Stack', 'Linked List', 'Queue'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which of the following is used to style web pages?',
    options: ['CSS', 'Python', 'XML', 'HTML'],
    correctAnswerIndex: 0,
  ),
];