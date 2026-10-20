import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:confetti/confetti.dart';
import 'package:learn/data/models.dart';
import 'package:learn/data/progress_manager.dart';
import 'package:learn/ui/widgets/app_background.dart';
import 'package:learn/ui/widgets/buttons.dart';

enum Minigame { drag, scramble, pick }

class QuizScreen extends StatefulWidget {
  final Category category;
  final List<VocabItem> vocabList;
  final ProgressManager progressManager;

  const QuizScreen({
    super.key,
    required this.category,
    required this.vocabList,
    required this.progressManager,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Minigame _currentGame;
  int _mistakes = 0;

  bool _showResult = false;
  int _score = 0;
  late ConfettiController _confettiController;

  Color get _catColor =>
      Color(int.parse(widget.category.colorHex.replaceFirst('#', '0xFF')));

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 4),
    );
    _pickNextGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _pickNextGame() {
    final gameStr = widget.progressManager.getOrAssignGameForLevel(
      widget.category.id,
    );
    switch (gameStr) {
      case 'drag':
        _currentGame = Minigame.drag;
        break;
      case 'scramble':
        _currentGame = Minigame.scramble;
        break;
      case 'pick':
        _currentGame = Minigame.pick;
        break;
      default:
        _currentGame = Minigame.drag;
    }
  }

  void _endQuiz(int correct, int total) async {
    final score = ((correct / total) * 9).round();
    await widget.progressManager.saveLevelScore(widget.category.id, score);
    await widget.progressManager.markLevelCompleted(widget.category.id, score);

    if (score >= 7) {
      await widget.progressManager.clearAssignedGame(widget.category.id);
    }

    setState(() {
      _score = score;
      _showResult = true;
    });

    if (score >= 7) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(isTablet),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 680 : double.infinity,
                      ),
                      child: _buildGameContent(isTablet),
                    ),
                  ),
                ),
              ],
            ),
            if (_showResult) _buildResultModal(isTablet),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Color(0xFFFFC93C),
                  Color(0xFFF27E9B),
                  Color(0xFF7FB6D8),
                  Color(0xFFA9D39E),
                  Color(0xFFF4A261),
                  Color(0xFFB088CA),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 680 : double.infinity),
        child: Padding(
          padding: EdgeInsets.only(
            top: isTablet ? 24 : 16,
            left: 16,
            right: 16,
          ),
          child: Row(
            children: [
              RoundButton(
                icon: Icons.chevron_left_rounded,
                onPressed: () => Navigator.of(context).pop(),
                size: isTablet ? 52 : 44,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isTablet ? 52 : 44),
                  child: Column(
                    children: [
                      Text(
                        'QUIZ',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4B5563),
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        widget.category.name,
                        style: TextStyle(
                          fontSize: isTablet ? 26 : 22,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent(bool isTablet) {
    switch (_currentGame) {
      case Minigame.drag:
        return _DragGame(
          vocabList: widget.vocabList,
          catColor: _catColor,
          isTablet: isTablet,
          onEnd: (firstTry, total) => _endQuiz(firstTry, total),
          onMistake: () => _mistakes++,
        );
      case Minigame.scramble:
        return _ScrambleGame(
          vocabList: widget.vocabList,
          catColor: _catColor,
          isTablet: isTablet,
          onEnd: (firstTry, total) => _endQuiz(firstTry, total),
          onMistake: () => _mistakes++,
        );
      case Minigame.pick:
        return _PickGame(
          vocabList: widget.vocabList,
          catColor: _catColor,
          isTablet: isTablet,
          onEnd: (firstTry, total) => _endQuiz(firstTry, total),
          onMistake: () => _mistakes++,
        );
    }
  }

  Widget _buildResultModal(bool isTablet) {
    final stars = widget.progressManager.starsFromScore(_score);
    final passed = _score >= 7;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        color: const Color(0xFF1F2937).withAlpha(120),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.5, end: 1.0),
          duration: const Duration(milliseconds: 550),
          curve: Curves.elasticOut,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Container(
            width: isTablet ? 390 : 310,
            padding: EdgeInsets.all(isTablet ? 32 : 26),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(245),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(31, 41, 55, 0.3),
                  offset: Offset(0, 14),
                  blurRadius: 28,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final isEarned = index < stars;
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (index * 180)),
                      curve: Curves.elasticOut,
                      builder: (context, starScale, child) {
                        return Transform.scale(scale: starScale, child: child);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.star_rounded,
                          size: isTablet ? 54 : 46,
                          color: isEarned
                              ? const Color(0xFFFFC93C)
                              : const Color(0xFFE4E8EE),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Text(
                  'SCORE',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4B5563),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_score / 9',
                  style: TextStyle(
                    fontSize: isTablet ? 40 : 34,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F2937),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 10),
                Text(
                  passed
                      ? 'Great job! You earned $stars star${stars == 1 ? '' : 's'}. 🎉'
                      : 'Good try! Score 7 to earn a star. 💪',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4B5563),
                  ),
                ),
                SizedBox(height: isTablet ? 28 : 24),
                ChunkButton(
                  text: 'Continue',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  backgroundColor: _catColor,
                  fontSize: isTablet ? 19 : 17,
                  padding: isTablet
                      ? const EdgeInsets.symmetric(horizontal: 56, vertical: 16)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DRAG GAME
// -----------------------------------------------------------------------------

class _DragGame extends StatefulWidget {
  final List<VocabItem> vocabList;
  final Color catColor;
  final bool isTablet;
  final void Function(int firstTry, int total) onEnd;
  final VoidCallback onMistake;

  const _DragGame({
    required this.vocabList,
    required this.catColor,
    this.isTablet = false,
    required this.onEnd,
    required this.onMistake,
  });

  @override
  State<_DragGame> createState() => _DragGameState();
}

class _DragGameState extends State<_DragGame> {
  late List<VocabItem> _targets;
  late List<List<VocabItem>> _trayBatches;
  int _currentBatch = 0;
  final Set<VocabItem> _matched = {};
  final Set<VocabItem> _missedOnce = {};
  final Set<VocabItem> _wrongTargets = {};
  late List<GlobalKey<ShakeWidgetState>> _targetShakeKeys;
  Timer? _wrongTimer;
  int _firstTryCount = 0;

  @override
  void initState() {
    super.initState();
    final shuffled = widget.vocabList.toList()..shuffle();
    _targets = shuffled.take(9).toList();
    _targetShakeKeys = List.generate(
      _targets.length,
      (_) => GlobalKey<ShakeWidgetState>(),
    );

    final trayItems = _targets.toList()..shuffle();
    _trayBatches = [];
    for (int i = 0; i < trayItems.length; i += 3) {
      _trayBatches.add(
        trayItems.sublist(
          i,
          i + 3 > trayItems.length ? trayItems.length : i + 3,
        ),
      );
    }
  }

  @override
  void dispose() {
    _wrongTimer?.cancel();
    super.dispose();
  }

  void _handleMatch(VocabItem target, VocabItem dropped) {
    if (_matched.contains(target)) return;

    if (target == dropped) {
      setState(() {
        _matched.add(target);
        _wrongTargets.remove(target);
        if (!_missedOnce.contains(target)) _firstTryCount++;
      });
      _checkBatchComplete();
    } else {
      final index = _targets.indexOf(target);
      if (index >= 0 && index < _targetShakeKeys.length) {
        _targetShakeKeys[index].currentState?.shake();
      }
      _wrongTimer?.cancel();
      setState(() {
        _wrongTargets.add(target);
        _missedOnce.add(target);
        widget.onMistake();
      });
      _wrongTimer = Timer(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() {
          _wrongTargets.remove(target);
        });
      });
    }
  }

  void _checkBatchComplete() {
    final currentBatchItems = _trayBatches[_currentBatch];
    final allMatched = currentBatchItems.every(
      (item) => _matched.contains(item),
    );
    if (allMatched) {
      if (_currentBatch < _trayBatches.length - 1) {
        setState(() {
          _currentBatch++;
        });
      } else {
        widget.onEnd(_firstTryCount, _targets.length);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isTablet ? 22 : 16,
              vertical: widget.isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              '${_matched.length} / ${_targets.length} matched',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: widget.isTablet ? 15 : 13,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isTablet ? 24 : 12,
              vertical: widget.isTablet ? 12 : 8,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: widget.isTablet ? 14 : 8,
              mainAxisSpacing: widget.isTablet ? 14 : 8,
            ),
            itemCount: _targets.length,
            itemBuilder: (context, index) {
              final target = _targets[index];
              final isMatched = _matched.contains(target);
              final isWrong = _wrongTargets.contains(target);
              return ShakeWidget(
                key: _targetShakeKeys[index],
                shakeOffset: 6.0,
                child: DragTarget<VocabItem>(
                  onAcceptWithDetails: (details) =>
                      _handleMatch(target, details.data),
                  builder: (context, candidateData, rejectedData) {
                    return TweenAnimationBuilder<double>(
                      key: ValueKey('matched_${target.en}_$isMatched'),
                      tween: Tween<double>(
                        begin: isMatched ? 0.8 : 1.0,
                        end: 1.0,
                      ),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) =>
                          Transform.scale(scale: scale, child: child),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: widget.catColor,
                          borderRadius: BorderRadius.circular(
                            widget.isTablet ? 20 : 16,
                          ),
                          border: isMatched
                              ? Border.all(
                                  color: const Color(0xFF4CAF50),
                                  width: widget.isTablet ? 5 : 4,
                                )
                              : isWrong
                              ? Border.all(
                                  color: const Color(0xFFE53935),
                                  width: widget.isTablet ? 5 : 4,
                                )
                              : Border.all(
                                  color: Colors.white,
                                  width: widget.isTablet ? 4 : 3,
                                ),
                          boxShadow: isMatched
                              ? const [
                                  BoxShadow(
                                    color: Color(0x664CAF50),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ]
                              : isWrong
                              ? const [
                                  BoxShadow(
                                    color: Color(0x66E53935),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            widget.isTablet ? 16 : 12,
                          ),
                          child: _buildImage(target.img),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Drag the words to the matching pictures.',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: widget.isTablet ? 16 : 14,
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minHeight: widget.isTablet ? 80 : 70,
            maxHeight: widget.isTablet ? 100 : 85,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _trayBatches[_currentBatch]
                  .where((item) => !_matched.contains(item))
                  .map((item) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isTablet ? 6 : 4,
                      ),
                      child: Draggable<VocabItem>(
                        data: item,
                        feedback: Transform.scale(
                          scale: 1.1,
                          child: _buildTrayChip(item),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.25,
                          child: _buildTrayChip(item),
                        ),
                        child: _buildTrayChip(item),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ),
        SizedBox(height: widget.isTablet ? 32 : 24),
      ],
    );
  }

  Widget _buildTrayChip(VocabItem item) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.isTablet ? 20 : 14,
          vertical: widget.isTablet ? 13 : 10,
        ),
        decoration: BoxDecoration(
          color: widget.catColor,
          borderRadius: BorderRadius.circular(widget.isTablet ? 16 : 12),
          border: Border.all(
            color: Colors.white,
            width: widget.isTablet ? 3.5 : 3,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, offset: Offset(0, 4)),
          ],
        ),
        child: Text(
          item.en,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: widget.isTablet ? 19 : 16,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCRAMBLE GAME
// -----------------------------------------------------------------------------

class _ScrambleGame extends StatefulWidget {
  final List<VocabItem> vocabList;
  final Color catColor;
  final bool isTablet;
  final void Function(int firstTry, int total) onEnd;
  final VoidCallback onMistake;

  const _ScrambleGame({
    required this.vocabList,
    required this.catColor,
    this.isTablet = false,
    required this.onEnd,
    required this.onMistake,
  });

  @override
  State<_ScrambleGame> createState() => _ScrambleGameState();
}

class _ScrambleGameState extends State<_ScrambleGame> {
  late List<VocabItem> _rounds;
  int _currentRound = 0;
  int _firstTryCount = 0;
  bool _missedOnce = false;

  late List<String> _words;
  late String _targetWord;
  late List<String> _letters;
  late List<bool> _used;
  late List<int> _answerSlots;
  late List<GlobalKey<ShakeWidgetState>> _letterShakeKeys;
  final GlobalKey<ShakeWidgetState> _hintShakeKey =
      GlobalKey<ShakeWidgetState>();
  int _remainingHints = 3;
  int? _wrongLetterIndex;
  Timer? _wrongLetterTimer;

  @override
  void initState() {
    super.initState();
    _remainingHints = 3;
    _rounds = widget.vocabList.toList()..shuffle();
    if (_rounds.length > 6) _rounds = _rounds.sublist(0, 6);
    _initRound();
  }

  @override
  void dispose() {
    _wrongLetterTimer?.cancel();
    super.dispose();
  }

  void _initRound() {
    _missedOnce = false;
    _wrongLetterIndex = null;
    final rawEn = _rounds[_currentRound].en.trim().toUpperCase();
    _words = rawEn.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (_words.isEmpty) _words = [rawEn];
    _targetWord = _words.join('').replaceAll(RegExp(r'[\-_]'), '');
    _letters = _targetWord.split('')..shuffle();
    while (_letters.join('') == _targetWord && _targetWord.length > 1) {
      _letters.shuffle();
    }
    _used = List.filled(_letters.length, false);
    _answerSlots = [];
    _letterShakeKeys = List.generate(
      _letters.length,
      (_) => GlobalKey<ShakeWidgetState>(),
    );
  }

  void _shuffleUnused() {
    setState(() {
      final unusedIndices = <int>[];
      for (int i = 0; i < _letters.length; i++) {
        if (!_used[i]) unusedIndices.add(i);
      }
      if (unusedIndices.length <= 1) return;
      final unusedLetters = unusedIndices.map((i) => _letters[i]).toList()
        ..shuffle();
      for (int i = 0; i < unusedIndices.length; i++) {
        _letters[unusedIndices[i]] = unusedLetters[i];
      }
    });
  }

  void _giveHint() {
    if (_remainingHints <= 0) {
      _hintShakeKey.currentState?.shake();
      return;
    }
    if (_answerSlots.length >= _targetWord.length) return;
    final expectedChar = _targetWord[_answerSlots.length];
    for (int i = 0; i < _letters.length; i++) {
      if (!_used[i] && _letters[i] == expectedChar) {
        setState(() {
          _remainingHints--;
        });
        _tapLetter(i);
        break;
      }
    }
  }

  void _tapLetter(int index) {
    if (_used[index]) return;

    final expectedChar = _targetWord[_answerSlots.length];
    if (_letters[index] == expectedChar) {
      setState(() {
        _used[index] = true;
        _answerSlots.add(index);
        _wrongLetterIndex = null;
      });

      if (_answerSlots.length == _targetWord.length) {
        if (!_missedOnce) _firstTryCount++;
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          if (_currentRound < _rounds.length - 1) {
            setState(() {
              _currentRound++;
              _initRound();
            });
          } else {
            widget.onEnd(_firstTryCount, _rounds.length);
          }
        });
      }
    } else {
      if (index < _letterShakeKeys.length) {
        _letterShakeKeys[index].currentState?.shake();
      }
      _wrongLetterTimer?.cancel();
      setState(() {
        _wrongLetterIndex = index;
        _missedOnce = true;
        widget.onMistake();
      });
      _wrongLetterTimer = Timer(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        setState(() {
          if (_wrongLetterIndex == index) _wrongLetterIndex = null;
        });
      });
    }
  }

  void _undoSlot(int pos) {
    setState(() {
      _missedOnce = true;
      final removed = _answerSlots.sublist(pos);
      _answerSlots.removeRange(pos, _answerSlots.length);
      for (var idx in removed) {
        _used[idx] = false;
      }
    });
  }

  List<Widget> _buildWordSlotRows() {
    final rows = <Widget>[];
    int globalIndex = 0;
    final maxLen = _words.fold<int>(0, (prev, w) => max(prev, w.length));
    final double slotWidth = widget.isTablet
        ? (maxLen <= 5 ? 54 : (maxLen <= 8 ? 46 : 38))
        : (maxLen <= 5 ? 42 : (maxLen <= 8 ? 36 : 30));
    final double slotHeight = widget.isTablet
        ? (maxLen <= 5 ? 62 : (maxLen <= 8 ? 54 : 46))
        : (maxLen <= 5 ? 48 : (maxLen <= 8 ? 44 : 38));
    final double fontSize = widget.isTablet
        ? (maxLen <= 5 ? 28 : (maxLen <= 8 ? 24 : 20))
        : (maxLen <= 5 ? 22 : (maxLen <= 8 ? 19 : 16));

    for (int w = 0; w < _words.length; w++) {
      final word = _words[w].replaceAll(RegExp(r'[\-_]'), '');
      final rowSlots = <Widget>[];
      for (int l = 0; l < word.length; l++) {
        final slotIdx = globalIndex;
        rowSlots.add(_buildSlot(slotIdx, slotWidth, slotHeight, fontSize));
        globalIndex++;
      }
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: widget.isTablet ? 4 : 3),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rowSlots,
            ),
          ),
        ),
      );
    }
    return rows;
  }

  Widget _buildSlot(
    int i,
    double slotWidth,
    double slotHeight,
    double fontSize,
  ) {
    final hasLetter = i < _answerSlots.length;
    return GestureDetector(
      onTap: hasLetter ? () => _undoSlot(i) : null,
      child: TweenAnimationBuilder<double>(
        key: ValueKey(
          'slot_${i}_${hasLetter ? _letters[_answerSlots[i]] : 'empty'}',
        ),
        tween: Tween<double>(begin: hasLetter ? 0.7 : 1.0, end: 1.0),
        duration: const Duration(milliseconds: 260),
        curve: Curves.elasticOut,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Container(
          width: slotWidth,
          height: slotHeight,
          margin: EdgeInsets.symmetric(horizontal: widget.isTablet ? 4 : 3),
          decoration: BoxDecoration(
            color: hasLetter ? widget.catColor : Colors.white,
            borderRadius: BorderRadius.circular(widget.isTablet ? 14 : 10),
            border: Border.all(
              color: hasLetter ? Colors.white : widget.catColor,
              width: widget.isTablet ? 3.0 : 2.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(31, 41, 55, 0.1),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            hasLetter ? _letters[_answerSlots[i]] : '',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _rounds[_currentRound];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isTablet ? 22 : 16,
              vertical: widget.isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9999),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(31, 41, 55, 0.08),
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              '$_currentRound / ${_rounds.length} words',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1F2937),
                fontSize: widget.isTablet ? 15 : 13,
              ),
            ),
          ),
        ),
        SizedBox(height: widget.isTablet ? 14 : 10),
        // Image Container with Blue background and White Border - Responsive size
        Container(
          width: widget.isTablet ? 180 : 140,
          height: widget.isTablet ? 180 : 140,
          decoration: BoxDecoration(
            color: const Color(0xFF7FB6D8),
            borderRadius: BorderRadius.circular(widget.isTablet ? 26 : 20),
            border: Border.all(
              color: Colors.white,
              width: widget.isTablet ? 5 : 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(31, 41, 55, 0.15),
                offset: Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          padding: EdgeInsets.all(widget.isTablet ? 8 : 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.isTablet ? 18 : 14),
            child: _buildImage(current.img),
          ),
        ),
        SizedBox(height: widget.isTablet ? 12 : 8),
        // Indonesian translation pill badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isTablet ? 24 : 18,
            vertical: widget.isTablet ? 7 : 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(31, 41, 55, 0.1),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Text(
            current.id,
            style: TextStyle(
              fontSize: widget.isTablet ? 18 : 15,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
        SizedBox(height: widget.isTablet ? 22 : 16),
        // Letter Slots Layout (grouped by words, scaled to fit screen without scrolling)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildWordSlotRows(),
          ),
        ),
        SizedBox(height: widget.isTablet ? 22 : 16),
        // Scrambled Letter Tiles
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: widget.isTablet ? 12 : 8,
            runSpacing: widget.isTablet ? 12 : 8,
            alignment: WrapAlignment.center,
            children: List.generate(_letters.length, (i) {
              final used = _used[i];
              final isWrong = _wrongLetterIndex == i;
              return ShakeWidget(
                key: i < _letterShakeKeys.length ? _letterShakeKeys[i] : null,
                shakeOffset: 6.0,
                child: TactileScale(
                  onTap: used ? null : () => _tapLetter(i),
                  disabled: used,
                  pressedScale: 0.9,
                  child: Opacity(
                    opacity: used ? 0.3 : 1.0,
                    child: Container(
                      width: widget.isTablet ? 58 : 48,
                      height: widget.isTablet ? 64 : 52,
                      decoration: BoxDecoration(
                        color: isWrong
                            ? const Color(0xFFE53935)
                            : widget.catColor,
                        borderRadius: BorderRadius.circular(
                          widget.isTablet ? 16 : 12,
                        ),
                        border: Border.all(
                          color: isWrong
                              ? const Color(0xFFFFCDD2)
                              : Colors.white,
                          width: widget.isTablet ? 3.0 : 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isWrong
                                ? const Color(0x66E53935)
                                : const Color.fromRGBO(31, 41, 55, 0.18),
                            offset: const Offset(0, 4),
                            blurRadius: isWrong ? 10 : 6,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _letters[i],
                        style: TextStyle(
                          fontSize: widget.isTablet ? 28 : 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const Spacer(),
        // Bottom Action Buttons: Shuffle and Hint
        Padding(
          padding: EdgeInsets.only(bottom: widget.isTablet ? 32 : 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _shuffleUnused,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isTablet ? 26 : 20,
                    vertical: widget.isTablet ? 13 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: widget.catColor,
                      width: widget.isTablet ? 3.0 : 2.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(31, 41, 55, 0.12),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.autorenew_rounded,
                        color: const Color(0xFF1F2937),
                        size: widget.isTablet ? 24 : 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Shuffle',
                        style: TextStyle(
                          fontSize: widget.isTablet ? 16 : 14,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: widget.isTablet ? 22 : 16),
              ShakeWidget(
                key: _hintShakeKey,
                child: GestureDetector(
                  onTap: _giveHint,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isTablet ? 26 : 20,
                      vertical: widget.isTablet ? 13 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: _remainingHints > 0
                          ? Colors.white
                          : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: _remainingHints > 0
                            ? widget.catColor
                            : const Color(0xFFD1D5DB),
                        width: widget.isTablet ? 3.0 : 2.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(31, 41, 55, 0.12),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: _remainingHints > 0
                              ? const Color(0xFF1F2937)
                              : const Color(0xFF9CA3AF),
                          size: widget.isTablet ? 24 : 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Hint ($_remainingHints)',
                          style: TextStyle(
                            fontSize: widget.isTablet ? 16 : 14,
                            fontWeight: FontWeight.w900,
                            color: _remainingHints > 0
                                ? const Color(0xFF1F2937)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// PICK GAME
// -----------------------------------------------------------------------------

class _PickGame extends StatefulWidget {
  final List<VocabItem> vocabList;
  final Color catColor;
  final bool isTablet;
  final void Function(int firstTry, int total) onEnd;
  final VoidCallback onMistake;

  const _PickGame({
    required this.vocabList,
    required this.catColor,
    this.isTablet = false,
    required this.onEnd,
    required this.onMistake,
  });

  @override
  State<_PickGame> createState() => _PickGameState();
}

class _PickGameState extends State<_PickGame> {
  late List<VocabItem> _rounds;
  int _currentRound = 0;
  int _firstTryCount = 0;
  bool _missedOnce = false;

  late List<VocabItem> _options;
  int? _correctPick;
  final Set<int> _wrongPicks = {};
  final List<GlobalKey<ShakeWidgetState>> _shakeKeys = List.generate(
    4,
    (_) => GlobalKey<ShakeWidgetState>(),
  );

  @override
  void initState() {
    super.initState();
    _rounds = widget.vocabList.toList()..shuffle();
    if (_rounds.length > 9) _rounds = _rounds.sublist(0, 9);
    _initRound();
  }

  void _initRound() {
    _missedOnce = false;
    _correctPick = null;
    _wrongPicks.clear();
    final current = _rounds[_currentRound];
    final distractors = widget.vocabList.where((v) => v != current).toList()
      ..shuffle();
    _options = [current, ...distractors.take(3)]..shuffle();
  }

  void _tapOption(int index) {
    if (_correctPick != null) return; // locked
    final current = _rounds[_currentRound];
    if (_options[index] == current) {
      setState(() {
        _correctPick = index;
        if (!_missedOnce) _firstTryCount++;
      });
      Future.delayed(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        if (_currentRound < _rounds.length - 1) {
          setState(() {
            _currentRound++;
            _initRound();
          });
        } else {
          widget.onEnd(_firstTryCount, _rounds.length);
        }
      });
    } else {
      _shakeKeys[index].currentState?.shake();
      setState(() {
        _wrongPicks.add(index);
        _missedOnce = true;
        widget.onMistake();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _rounds[_currentRound];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isTablet ? 22 : 16,
              vertical: widget.isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9999),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(31, 41, 55, 0.08),
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              '$_currentRound / ${_rounds.length} found',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1F2937),
                fontSize: widget.isTablet ? 15 : 13,
              ),
            ),
          ),
        ),
        SizedBox(height: widget.isTablet ? 16 : 12),
        // Instruction Banner
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isTablet ? 26 : 20,
            vertical: widget.isTablet ? 12 : 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(31, 41, 55, 0.1),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Text(
            'Tap the picture that matches the word.',
            style: TextStyle(
              fontSize: widget.isTablet ? 16 : 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
        SizedBox(height: widget.isTablet ? 20 : 16),
        // Prompt Card with AnimatedSwitcher (scaled to prevent overflowing on long words like Happy Birthday)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: Tween<double>(
              begin: 0.88,
              end: 1.0,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Container(
            key: ValueKey<String>('prompt_${current.en}'),
            constraints: BoxConstraints(maxWidth: widget.isTablet ? 480 : 320),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isTablet ? 36 : 24,
              vertical: widget.isTablet ? 16 : 12,
            ),
            decoration: BoxDecoration(
              color: widget.catColor,
              borderRadius: BorderRadius.circular(widget.isTablet ? 28 : 24),
              border: Border.all(
                color: Colors.white,
                width: widget.isTablet ? 4.5 : 3.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(31, 41, 55, 0.18),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                ),
              ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                current.en,
                style: TextStyle(
                  fontSize: widget.isTablet ? 38 : 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: widget.isTablet ? 24 : 20),
        // 2x2 Picture Cards Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isTablet ? 24 : 16,
              vertical: widget.isTablet ? 12 : 8,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: widget.isTablet ? 20 : 14,
              mainAxisSpacing: widget.isTablet ? 20 : 14,
              childAspectRatio: widget.isTablet ? 1.0 : 0.95,
            ),
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final isCorrect = _correctPick == index;
              final isWrong = _wrongPicks.contains(index);
              return ShakeWidget(
                key: _shakeKeys[index],
                shakeOffset: 6.0,
                child: TactileScale(
                  onTap: () => _tapOption(index),
                  pressedScale: 0.94,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        widget.isTablet ? 28 : 24,
                      ),
                      border: Border.all(
                        color: isCorrect
                            ? const Color(0xFF4CAF50)
                            : isWrong
                            ? const Color(0xFFE53935)
                            : Colors.white,
                        width: isCorrect || isWrong
                            ? (widget.isTablet ? 5.5 : 4.5)
                            : (widget.isTablet ? 5 : 4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isCorrect
                              ? const Color(0x664CAF50)
                              : isWrong
                              ? const Color(0x66E53935)
                              : const Color.fromRGBO(31, 41, 55, 0.18),
                          offset: const Offset(0, 6),
                          blurRadius: isCorrect || isWrong ? 16 : 12,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        widget.isTablet ? 23 : 20,
                      ),
                      child: Container(
                        color: const Color(0xFF7FB6D8),
                        padding: EdgeInsets.all(widget.isTablet ? 8 : 6),
                        child: _buildImage(_options[index].img),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// UTILS
// -----------------------------------------------------------------------------
Widget _buildImage(String path) {
  if (path.startsWith('dummy:')) {
    final emoji = path.substring(6);
    return Container(
      color: const Color(0xFF7FB6D8),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 40)),
    );
  } else if (path.endsWith('.svg')) {
    return SvgPicture.asset(path, fit: BoxFit.cover);
  } else {
    return Image.asset(path, fit: BoxFit.cover, cacheWidth: 500);
  }
}
