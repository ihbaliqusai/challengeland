import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/answer_option_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/question_card.dart';
import '../../core/widgets/score_badge.dart';
import '../../core/widgets/timer_circle.dart';
import '../../state/auth_provider.dart';
import '../../state/game_provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Timer? _timer;
  int _remaining = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureGame());
  }

  Future<void> _ensureGame() async {
    final game = context.read<GameProvider>();
    final user = context.read<AuthProvider>().user;
    if (user == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }
    if (game.questions.isEmpty) {
      await game.startGame(player: user);
    }
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    final seconds =
        context.read<GameProvider>().session?.timerSeconds ?? _remaining;
    setState(() => _remaining = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final game = context.read<GameProvider>();
      if (game.isRevealVisible || game.isFinished) {
        timer.cancel();
        return;
      }
      if (_remaining <= 1) {
        timer.cancel();
        _submit('لم تتم الإجابة');
        return;
      }
      setState(() => _remaining--);
    });
  }

  Future<void> _submit(String answer) async {
    _timer?.cancel();
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    await context.read<GameProvider>().submitAnswer(
      player: user,
      answer: answer,
      remainingTime: _remaining,
    );
  }

  Future<void> _next() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final game = context.read<GameProvider>();
    await game.nextQuestion(user);
    if (!mounted) return;
    if (game.isFinished) {
      await context.read<AuthProvider>().applyStats(
        score: game.playerScore,
        correctAnswers: game.correctAnswers,
        wrongAnswers: game.wrongAnswers,
        won: game.playerScore >= game.opponentScore,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.gameResult);
    } else {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final question = game.currentQuestion;
    if (game.isLoading) return const Scaffold(body: LoadingView());
    if (game.error != null && question == null) {
      return Scaffold(body: ErrorView(message: game.error!));
    }
    if (question == null) {
      return const Scaffold(body: EmptyState(message: 'لا توجد أسئلة متاحة'));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.challengeDark, AppColors.challengeNavy],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.challengeCard.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      TimerCircle(
                        remaining: _remaining,
                        total: game.session?.timerSeconds ?? 15,
                        size: 78,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'جولة سريعة',
                              style: TextStyle(
                                color: AppColors.challengeGold,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ScoreBadge(
                                  score: game.playerScore,
                                  label: 'أنت',
                                ),
                                ScoreBadge(
                                  score: game.opponentScore,
                                  label: 'المنافس',
                                  color: AppColors.challengeCyan,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'إغلاق',
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (_) => false,
                        ),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                QuestionCard(
                  question: question,
                  index: game.currentIndex + 1,
                  total: game.totalQuestions,
                ),
                const SizedBox(height: 16),
                ...question.options.map((option) {
                  final reveal = game.isRevealVisible;
                  final selected = game.selectedAnswer == option;
                  final isCorrect = reveal && option == question.correctAnswer
                      ? true
                      : null;
                  final wrongSelected =
                      reveal && selected && option != question.correctAnswer;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnswerOptionCard(
                      text: option,
                      isSelected: selected,
                      isCorrect: wrongSelected ? false : isCorrect,
                      enabled: !reveal,
                      onTap: () => _submit(option),
                    ),
                  );
                }),
                if (game.isRevealVisible) ...[
                  const SizedBox(height: 8),
                  _RevealPanel(
                    isCorrect: question.isCorrect(game.selectedAnswer ?? ''),
                    correctAnswer: question.correctAnswer,
                    explanation: question.explanation,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: game.currentIndex >= game.totalQuestions - 1
                        ? 'عرض النتيجة'
                        : 'السؤال التالي',
                    icon: Icons.arrow_back_rounded,
                    variant: AppButtonVariant.gold,
                    onPressed: _next,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RevealPanel extends StatelessWidget {
  const _RevealPanel({
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
  });

  final bool isCorrect;
  final String correctAnswer;
  final String? explanation;

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppColors.challengeGreen : AppColors.challengeRed;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.28), AppColors.challengeCard],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.75), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              isCorrect ? Icons.check_rounded : Icons.close_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect
                      ? 'إجابة صحيحة!'
                      : 'الإجابة الصحيحة: $correctAnswer',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                if (explanation != null && explanation!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(explanation!, style: const TextStyle(height: 1.45)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
