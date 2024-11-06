import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  Future<void> _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? registeredEmail = prefs.getString('email');
    String? registeredPassword = prefs.getString('password');

    if (_email == registeredEmail && _password == registeredPassword) {
      // Navigate to main page if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _login();
                  }
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _errorMessage = '';

  Future<void> _register() async {
    if (_password == _confirmPassword) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _email);
      await prefs.setString('password', _password);

      Navigator.pop(context); // Go back to login page after registration
    } else {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _confirmPassword = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _register();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  // OS questions
  final List<Question> osQuestions = [
    Question(
        "What is a process?",
        ["A program in execution", "A file system", "A thread", "A semaphore"],
        0),
    Question(
        "What is virtual memory?",
        [
          "Memory on the hard disk",
          "A physical memory",
          "Memory in the cloud",
          "An extended RAM"
        ],
        0),
    Question(
        "Which scheduling algorithm is preemptive?",
        ["Round Robin", "First Come First Serve", "Shortest Job First", "FIFO"],
        0),
    Question(
        "Which of the following is a deadlock prevention method?",
        [
          "Avoid circular wait",
          "Enable multi-threading",
          "Avoid context switching",
          "Increase memory"
        ],
        0),
    Question(
        "What is a semaphore used for?",
        [
          "Process synchronization",
          "Memory allocation",
          "CPU scheduling",
          "File management"
        ],
        0),
    Question("Which system call is used to create a new process?",
        ["fork()", "exec()", "wait()", "exit()"], 0),
    Question("Which of the following is a type of system software?",
        ["Operating system", "Word processor", "Database", "Web browser"], 0),
    Question(
        "What is the main purpose of an operating system?",
        [
          "Manage hardware resources",
          "Run web applications",
          "Execute database queries",
          "Provide user interfaces"
        ],
        0),
    Question(
        "What is the maximum number of processes in a time-sharing operating system?",
        ["Multiple", "One", "Two", "None of the above"],
        0),
    Question(
        "What does 'thrashing' refer to in an OS?",
        [
          "Excessive swapping of pages",
          "File corruption",
          "Hardware failure",
          "CPU overloading"
        ],
        0),
    Question("Which part of an OS handles resource allocation?",
        ["Kernel", "Shell", "User Interface", "Command Line Interface"], 0),
    Question(
        "Which scheduling algorithm minimizes the average waiting time?",
        ["Shortest Job First", "Round Robin", "Priority Scheduling", "FIFO"],
        0),
    Question("Which of the following is a multi-tasking operating system?",
        ["Linux", "MS-DOS", "CP/M", "None of the above"], 0),
    Question(
        "Which mechanism is used to avoid deadlock?",
        [
          "Banker's Algorithm",
          "Memory Partitioning",
          "Process Scheduling",
          "Page Replacement"
        ],
        0),
    Question("Which command is used to list processes in Unix/Linux?",
        ["ps", "ls", "mkdir", "chmod"], 0),
  ];

  // Network questions
  final List<Question> networkQuestions = [
    Question(
        "What is the primary function of a router?",
        [
          "To forward packets",
          "To assign IPs",
          "To route emails",
          "To encrypt data"
        ],
        0),
    Question(
        "What does DHCP stand for?",
        [
          "Dynamic Host Control Protocol",
          "Dynamic Host Configuration Protocol",
          "Data Handling Control Protocol",
          "Data Host Configuration Protocol"
        ],
        1),
    Question("What is the default port number for HTTP?",
        ["80", "443", "21", "22"], 0),
    Question("What layer does a switch operate at in the OSI model?",
        ["Layer 1", "Layer 2", "Layer 3", "Layer 4"], 1),
    Question("Which protocol is used for email retrieval?",
        ["POP3", "HTTP", "SMTP", "FTP"], 0),
    Question("Which protocol ensures secure communication over a network?",
        ["SSL", "HTTP", "UDP", "Telnet"], 0),
    Question("What does the term 'ping' measure?",
        ["Latency", "Bandwidth", "Packet Loss", "Encryption Strength"], 0),
    Question("Which IP address class allows for the largest number of hosts?",
        ["Class A", "Class B", "Class C", "Class D"], 0),
    Question(
        "What does DNS stand for?",
        [
          "Domain Name System",
          "Digital Name Service",
          "Direct Network System",
          "Domain Network Service"
        ],
        0),
    Question(
        "What is a subnet mask used for?",
        [
          "Dividing networks",
          "Encrypting data",
          "Managing IP addresses",
          "Controlling traffic"
        ],
        0),
    Question(
        "What does NAT stand for?",
        [
          "Network Address Translation",
          "Network Access Transfer",
          "Node Access Transfer",
          "Network Administration Tool"
        ],
        0),
    Question("Which protocol is used to send email?",
        ["SMTP", "POP3", "IMAP", "FTP"], 0),
    Question(
        "Which type of address is used at the Network layer of the OSI model?",
        ["IP Address", "MAC Address", "Port Address", "Physical Address"],
        0),
    Question("Which command is used to check network connectivity?",
        ["ping", "ipconfig", "netstat", "tracert"], 0),
    Question("Which protocol is used for secure web browsing?",
        ["HTTPS", "HTTP", "FTP", "Telnet"], 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Categories'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizPage(questions: osQuestions, title: 'OS Quiz')),
                );
              },
              child: Text('Start OS Quiz'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizPage(
                          questions: networkQuestions, title: 'Network Quiz')),
                );
              },
              child: Text('Start Network Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final String title;

  QuizPage({required this.questions, required this.title});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<int?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<int?>.filled(widget.questions.length, null);
  }

  void checkAnswer(int selectedAnswerIndex) {
    if (selectedAnswerIndex ==
        widget.questions[currentQuestionIndex].correctAnswerIndex) {
      score++;
    }
    setState(() {
      selectedAnswers[currentQuestionIndex] = selectedAnswerIndex;
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < widget.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResultPage(
                  score: score, totalQuestions: widget.questions.length)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              widget.questions[currentQuestionIndex].question,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(
                  widget.questions[currentQuestionIndex].options.length,
                  (index) {
                return RadioListTile(
                  title: Text(
                      widget.questions[currentQuestionIndex].options[index]),
                  value: index,
                  groupValue: selectedAnswers[currentQuestionIndex],
                  onChanged: (int? value) {
                    checkAnswer(value!);
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedAnswers[currentQuestionIndex] != null
                  ? nextQuestion
                  : null,
              child: Text(currentQuestionIndex < widget.questions.length - 1
                  ? 'Next'
                  : 'Finish'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ResultPage({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score/$totalQuestions',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question(this.question, this.options, this.correctAnswerIndex);
}
