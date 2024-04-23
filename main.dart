import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  bool _isSidebarOpen = false;
  int _selectedIndex = 0;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DictionaryPage(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleSidebar,
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.purple,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book,
                    size: 120,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle sign up
                    },
                    child: Text('Sign Up'),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      // Handle sign in
                    },
                    child: Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
          if (_isSidebarOpen) SidebarWidget(onClose: _toggleSidebar),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.purple),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.purple),
            label: 'Dictionary',
          ),
        ],
      ),
    );
  }
}

class SidebarWidget extends StatelessWidget {
  final VoidCallback onClose;

  const SidebarWidget({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://picsum.photos/seed/289/600'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test User',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Noto Sans',
                      ),
                    ),
                    Text(
                      'Flutter Developer',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontFamily: 'Noto Sans',
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  color: Colors.black,
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.bookmark, color: Colors.purple),
            title: Text(
              'My List',
              style: TextStyle(color: Colors.purple, fontFamily: 'Noto Sans'),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyListPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.school, color: Colors.purple),
            title: Text(
              'Learn',
              style: TextStyle(color: Colors.purple, fontFamily: 'Noto Sans'),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LearnPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.query_stats_outlined, color: Colors.purple),
            title: Text(
              'Quiz',
              style: TextStyle(color: Colors.purple, fontFamily: 'Noto Sans'),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QuizPage(),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  String _randomWord = '';
  String? _word;
  List<dynamic>? _data;
  String? _searchedWord;

  void _generateRandomWord() {
    // List of example words
    List<String> exampleWords = [
      'apple',
      'banana',
      'orange',
      'grape',
      'strawberry',
      'kiwi',
      'watermelon',
      'pineapple',
      'mango',
      'peach',
    ];

    // Generate a random index
    int randomIndex = Random().nextInt(exampleWords.length);

    // Set the random word
    setState(() {
      _randomWord = exampleWords[randomIndex];
    });

    // Search for the word
    _searchWord(exampleWords[randomIndex]);
  }

  void _searchWord(String word) async {
    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
        _searchedWord = word;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateRandomWord,
              child: Text('Generate Random Word'),
            ),
            SizedBox(height: 20),
            if (_data != null)
              Expanded(
                // Wrap the ListView.builder with Expanded
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _data!.length,
                  itemBuilder: (context, index) {
                    var wordData = _data![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Word: ${wordData['word']}'),
                        SizedBox(height: 8), // Add spacing here
                        if (wordData['phonetics'] != null)
                          for (var phonetic in wordData['phonetics'])
                            if (phonetic['audio'] != null)
                              TextButton(
                                onPressed: () {
                                  AudioPlayer().play(phonetic['audio']);
                                },
                                child: Text(
                                    'Listen Pronunciation (${phonetic['text']})'),
                              ),
                        if (wordData['meanings'] != null)
                          for (var meaning in wordData['meanings'])
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16), // Add spacing here
                                Text(
                                    'Part of Speech: ${meaning['partOfSpeech']}'),
                                SizedBox(height: 8), // Add spacing here
                                if (meaning['definitions'] != null)
                                  for (var definition in meaning['definitions'])
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Definition: ${definition['definition']}'),
                                        SizedBox(height: 8), // Add spacing here
                                        if (definition['synonyms'] != null &&
                                            definition['synonyms'].isNotEmpty)
                                          Text(
                                              'Synonyms: ${definition['synonyms'].join(", ")}'),
                                        SizedBox(height: 8), // Add spacing here
                                        if (definition['antonyms'] != null &&
                                            definition['antonyms'].isNotEmpty)
                                          Text(
                                              'Antonyms: ${definition['antonyms'].join(", ")}'),
                                        SizedBox(height: 8), // Add spacing here
                                        if (definition['example'] != null)
                                          Text(
                                              'Example: ${definition['example']}'),
                                        SizedBox(height: 8), // Add spacing here
                                      ],
                                    ),
                              ],
                            ),
                        Divider(),
                        SizedBox(height: 16), // Add spacing here
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MyListPage extends StatefulWidget {
  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  List<String> _savedWords = [];

  @override
  void initState() {
    super.initState();
    _loadSavedWords();
  }

  void _loadSavedWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedWords = prefs.getStringList('savedWords') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
      ),
      body: ListView.builder(
        itemCount: _savedWords.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_savedWords[index]),
          );
        },
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> _questions = [
    {
      'question': 'What does the word "ephemeral" mean?',
      'options': ['Short-lived', 'Eternal', 'Tangible', 'Opaque'],
      'answer': 'Short-lived',
    },
    {
      'question': 'Which word means "the ability to read and write"?',
      'options': ['Illiterate', 'Literate', 'Numerate', 'Innumerate'],
      'answer': 'Literate',
    },
    {
      'question': 'What is the synonym of "ubiquitous"?',
      'options': ['Scarce', 'Rare', 'Everywhere', 'Singular'],
      'answer': 'Everywhere',
    },
    {
      'question': 'What does "gregarious" mean?',
      'options': [
        'Friendly and outgoing',
        'Shy and reserved',
        'Intelligent and wise',
        'Careless and thoughtless'
      ],
      'answer': 'Friendly and outgoing',
    },
    {
      'question': 'Which word means "to make less severe or harsh"?',
      'options': ['Intensify', 'Aggravate', 'Mitigate', 'Exacerbate'],
      'answer': 'Mitigate',
    },
  ];

  int _currentQuestionIndex = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  int _score = 0;

  void _checkAnswer(String selectedOption) {
    String correctAnswer = _questions[_currentQuestionIndex]['answer'];

    setState(() {
      _showResult = true;
      _isCorrect = selectedOption == correctAnswer;
      if (_isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _showResult = false;
      _isCorrect = false;
    });
  }

  void _startQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestionIndex >= _questions.length) {
      // Quiz completed, show the score and option to retake the test
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Your Score: $_score out of ${_questions.length}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startQuiz,
                child: Text('Take Quiz Again'),
              ),
            ],
          ),
        ),
      );
    }

    Map<String, dynamic> currentQuestion = _questions[_currentQuestionIndex];
    String question = currentQuestion['question'];
    List<String> options = currentQuestion['options'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              question,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ...options.map((option) {
              bool isCorrect =
                  _showResult && option == currentQuestion['answer'];
              bool isSelected =
                  _showResult && option == currentQuestion['selectedOption'];

              return GestureDetector(
                onTap: () {
                  if (!_showResult) {
                    currentQuestion['selectedOption'] = option;
                    _checkAnswer(option);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: _showResult && isCorrect
                        ? Colors.green
                        : (isSelected ? Colors.red : Colors.white),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Colors.black),
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            if (_showResult)
              Text(
                _isCorrect
                    ? 'Correct!'
                    : 'Wrong. The correct answer is: ${currentQuestion['answer']}',
                style: TextStyle(color: _isCorrect ? Colors.green : Colors.red),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }
}

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  String? _word;
  List<dynamic>? _data;
  String? _searchedWord;

  void _saveWord(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedWords = prefs.getStringList('savedWords') ?? [];
    savedWords.add(word);
    await prefs.setStringList('savedWords', savedWords);
  }

  void _searchWord() async {
    if (_word != null) {
      final response = await http.get(
          Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$_word'));
      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body);
          _searchedWord = _word;
        });
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: () async {
                if (_searchedWord != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyListPage(),
                  ));
                }
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter a word',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _word = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchWord,
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            if (_data != null)
              ListView.builder(
                shrinkWrap: true,
                itemCount: _data!.length,
                itemBuilder: (context, index) {
                  var wordData = _data![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Word: ${wordData['word']}'),
                      SizedBox(height: 8), // Add spacing here
                      if (wordData['phonetics'] != null)
                        for (var phonetic in wordData['phonetics'])
                          if (phonetic['audio'] != null)
                            TextButton(
                              onPressed: () {
                                AudioPlayer().play(phonetic['audio']);
                              },
                              child: Text(
                                  'Listen Pronunciation (${phonetic['text']})'),
                            ),
                      if (wordData['meanings'] != null)
                        for (var meaning in wordData['meanings'])
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16), // Add spacing here
                              Text(
                                  'Part of Speech: ${meaning['partOfSpeech']}'),
                              SizedBox(height: 8), // Add spacing here
                              if (meaning['definitions'] != null)
                                for (var definition in meaning['definitions'])
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Definition: ${definition['definition']}'),
                                      SizedBox(height: 8), // Add spacing here
                                      if (definition['synonyms'] != null &&
                                          definition['synonyms'].isNotEmpty)
                                        Text(
                                            'Synonyms: ${definition['synonyms'].join(", ")}'),
                                      SizedBox(height: 8), // Add spacing here
                                      if (definition['antonyms'] != null &&
                                          definition['antonyms'].isNotEmpty)
                                        Text(
                                            'Antonyms: ${definition['antonyms'].join(", ")}'),
                                      SizedBox(height: 8), // Add spacing here
                                      if (definition['example'] != null)
                                        Text(
                                            'Example: ${definition['example']}'),
                                      SizedBox(height: 8), // Add spacing here
                                    ],
                                  ),
                            ],
                          ),
                      Divider(),
                      SizedBox(height: 16), // Add spacing here
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
