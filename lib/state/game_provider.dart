import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants/app_config.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/score_utils.dart';
import '../models/answer.dart';
import '../models/game_session.dart';
import '../models/match_history.dart';
import '../models/question.dart';
import '../models/user_profile.dart';
import '../services/game_service.dart';

class GameProvider extends ChangeNotifier {
  GameProvider({GameService? gameService, Random? random})
    : _gameService = gameService ?? GameService(),
      _random = random ?? Random();

  final GameService _gameService;
  final Random _random;

  GameSession? session;
  List<Question> questions = const [];
  List<Answer> answers = const [];
  bool isLoading = false;
  String? error;
  String? selectedAnswer;
  bool isRevealVisible = false;
  int playerScore = 0;
  int opponentScore = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int currentIndex = 0;
  MatchHistory? latestHistory;

  Question? get currentQuestion =>
      currentIndex >= 0 && currentIndex < questions.length
      ? questions[currentIndex]
      : null;
  bool get isFinished => session?.isFinished == true;
  int get totalQuestions => questions.length;

  Future<void> startGame({
    required UserProfile player,
    String mode = 'quick_1v1',
    String? categoryId,
    int questionCount = AppConfig.defaultQuestionCount,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      questions = await _gameService.getQuestionsForSession(
        categoryId: categoryId,
        questionCount: questionCount,
      );
      if (questions.isEmpty) {
        throw StateError(AppStrings.noQuestions);
      }
      session = await _gameService.createGameSession(
        player: player,
        mode: mode,
        questionCount: questions.length,
      );
      answers = const [];
      selectedAnswer = null;
      isRevealVisible = false;
      playerScore = 0;
      opponentScore = 0;
      correctAnswers = 0;
      wrongAnswers = 0;
      currentIndex = 0;
      latestHistory = null;
    } catch (exception) {
      error = exception.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAnswer({
    required UserProfile player,
    required String answer,
    required int remainingTime,
  }) async {
    final currentSession = session;
    final question = currentQuestion;
    if (currentSession == null || question == null) return;
    if (isRevealVisible) {
      error = AppStrings.duplicateAnswer;
      notifyListeners();
      return;
    }

    selectedAnswer = answer;
    final isCorrect = question.isCorrect(answer);
    final score = ScoreUtils.calculateQuestionScore(
      isCorrect: isCorrect,
      remainingTime: remainingTime,
      totalTime: currentSession.timerSeconds,
      basePoints: question.points,
    );
    final savedAnswer = await _gameService.submitAnswer(
      session: currentSession,
      question: question,
      player: player,
      selectedAnswer: answer,
      remainingTime: remainingTime,
      score: score,
    );

    answers = [...answers, savedAnswer];
    playerScore += score;
    opponentScore += 70 + _random.nextInt(85);
    if (isCorrect) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }
    isRevealVisible = true;
    notifyListeners();
  }

  Future<void> nextQuestion(UserProfile player) async {
    final currentSession = session;
    if (currentSession == null) return;
    if (currentIndex >= questions.length - 1) {
      await finish(player);
      return;
    }
    currentIndex++;
    selectedAnswer = null;
    isRevealVisible = false;
    await _gameService.moveToNextQuestion(currentSession);
    notifyListeners();
  }

  Future<void> finish(UserProfile player) async {
    final currentSession = session;
    if (currentSession == null) return;
    final won = playerScore >= opponentScore;
    session = await _gameService.finishGame(
      currentSession.copyWith(
        playerScores: {player.uid: playerScore, 'bot-arena': opponentScore},
        winnerId: won ? player.uid : 'bot-arena',
      ),
    );
    latestHistory = MatchHistory(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      uid: player.uid,
      mode: currentSession.mode,
      score: playerScore,
      opponentName: 'بوت المعرفة',
      result: won ? 'win' : 'loss',
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      playedAt: DateTime.now(),
    );
    await _gameService.saveMatchHistory(latestHistory!);
    notifyListeners();
  }

  void resetRevealError() {
    error = null;
    notifyListeners();
  }
}
