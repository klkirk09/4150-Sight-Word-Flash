# # Flash Dash

# Description: 
This is a flutter sight word game designed for young children to learn how to read. The home screen allows the user to choose the grade level of words they want to practice,
which then pulls from a database of words for that grade level. 10 words are pulled randomly from the selected grade level's word bank. The user can then select "I know it", which will
retire the word, or hit "Practice Again" if they do not know the word, which will return the word to the back of the stack to be shown again before the round is over. The app
records each round and the score locally so users can see their historical scores and history. 

# Features
Five word levels:
  - Pre-Primer
  - Primer
  - First Grade
  - Second Grade
  - Third Grade

- Flash card gameplay
- Results screen after every round
- Statistics screen (top right corner of app)
- Local storage persistence with sharedPreferences
- Child friendly buttons and colors


# Running Instructions

- Clone repository
- Open the repository in Android Studio
- Run "flutter pub get"
- Run "flutter run"

# Scoring

Each round is composed of 10 randomly selected words from the selected level's word bank. Players are scored on whether they get the word right on the first attempt. If not,
this will remove 10% accuracy for each word that was not identified correctly on first try. The statistics page displays the total games played, their average score, their best score,
and a history of each game played and the scores for each of those games. 


# Tradeoffs

Tradeoff 1: I chose to score rounds using the percentage of words recognized on the first attempt instead of counting every successful answer equally because it better measures initial sight-word recognition. The cost of this approach is that improving after practicing a word does not increase the final score. This works well for Flash Dash because the goal is measuring first recognition rather than persistence.

Tradeoff 2: I chose SharedPreferences instead of SQLite because the application only stores a small amount of score history. SharedPreferences is simpler to implement and easier to understand. The cost is that it is not ideal for storing large amounts of structured data. This approach works well unless the application grows to support multiple users or extensive game history.


# Project Statement

This application was developed specifically for the CPSC 4150 Vibe Mastery Exam.

This project is distinct from both my Solo 3 project and my team project.

