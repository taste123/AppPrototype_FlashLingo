import 'dart:async';
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
    final gameStr =
        widget.progressManager.getOrAssignGameForLevel(widget.category.id);
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildGameContent()),
              ],
            ),
            if (_showResult) _buildResultModal(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          RoundButton(
            icon: Icons.chevron_left_rounded,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 44),
              child: Column(
                children: [
                  const Text(
                    'QUIZ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4B5563),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    widget.category.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent() {
    switch (_currentGame) {
      case Minigame.drag:
        return _DragGame(
          vocabList: widget.vocabList,
          catColor: _catColor,
          onEnd: (firstTry, total) => _endQuiz(firstTry, total),
          onMistake: () => _mistakes++,
        );
      case Minigame.scramble:
        return _ScrambleGame(
          vocabList: widget.vocabList,
          catColor: _catColor,
          onEnd: (firstTry, total) => _endQuiz(firstTry, total),
          onMistake: () => _mistakes++,
        );
      case Minigame.pick:
        return _PickGame(
          vocabList: widget.vocabList,
          catColor: _catColor,
          onEnd: (firstTry, total) => _endQuiz(firstTry, total),
          onMistake: () => _mistakes++,
        );
    }
  }

  Widget _buildResultModal() {
    final stars = widget.progressManager.starsFromScore(_score);
    final passed = _score >= 7;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        color: const Color(0xFF1F2937).withAlpha(120),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Container(
          width: 310,
          padding: const EdgeInsets.all(26),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star_rounded,
                      size: 44,
                      color: index < stars
                          ? const Color(0xFFFFC93C)
                          : const Color(0xFFE4E8EE),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              const Text(
                'SCORE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4B5563),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_score / 9',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                passed
                    ? 'Great job! You earned $stars star${stars == 1 ? '' : 's'}.'
                    : 'Good try! Score 7 to earn a star. 💪',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 24),
              ChunkButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                backgroundColor: _catColor,
              ),
            ],
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
  final void Function(int firstTry, int total) onEnd;
  final VoidCallback onMistake;

  const _DragGame({
    required this.vocabList,
    required this.catColor,
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
  int _firstTryCount = 0;

  @override
  void initState() {
    super.initState();
    final shuffled = widget.vocabList.toList()..shuffle();
    _targets = shuffled.take(9).toList();

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

  void _handleMatch(VocabItem target, VocabItem dropped) {
    if (_matched.contains(target)) return;

    if (target == dropped) {
      setState(() {
        _matched.add(target);
        if (!_missedOnce.contains(target)) _firstTryCount++;
      });
      _checkBatchComplete();
    } else {
      setState(() {
        _missedOnce.add(target);
        widget.onMistake();
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              '${_matched.length} / ${_targets.length} matched',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _targets.length,
            itemBuilder: (context, index) {
              final target = _targets[index];
              final isMatched = _matched.contains(target);
              return DragTarget<VocabItem>(
                onAcceptWithDetails: (details) =>
                    _handleMatch(target, details.data),
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: widget.catColor,
                      borderRadius: BorderRadius.circular(16),
                      border: isMatched
                          ? Border.all(color: Colors.green, width: 3)
                          : Border.all(color: Colors.white, width: 3),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: _buildImage(target.img),
                  );
                },
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Drag the words to the matching pictures.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _trayBatches[_currentBatch]
                .where((item) => !_matched.contains(item))
                .map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Draggable<VocabItem>(
                      data: item,
                      feedback: _buildTrayChip(item),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: _buildTrayChip(item),
                      ),
                      child: _buildTrayChip(item),
                    ),
                  );
                })
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTrayChip(VocabItem item) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.catColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black12, offset: Offset(0, 4)),
          ],
        ),
        child: Text(
          item.en,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
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
  final void Function(int firstTry, int total) onEnd;
  final VoidCallback onMistake;

  const _ScrambleGame({
    required this.vocabList,
    required this.catColor,
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

  late String _targetWord;
  late List<String> _letters;
  late List<bool> _used;
  late List<int> _answerSlots;

  @override
  void initState() {
    super.initState();
    _rounds = widget.vocabList.toList()..shuffle();
    if (_rounds.length > 6) _rounds = _rounds.sublist(0, 6);
    _initRound();
  }

  void _initRound() {
    _missedOnce = false;
    _targetWord = _rounds[_currentRound].en.toUpperCase();
    _letters = _targetWord.split('')..shuffle();
    while (_letters.join('') == _targetWord && _targetWord.length > 1) {
      _letters.shuffle();
    }
    _used = List.filled(_letters.length, false);
    _answerSlots = [];
  }

  void _shuffleUnused() {
    setState(() {
      final unusedIndices = <int>[];
      for (int i = 0; i < _letters.length; i++) {
        if (!_used[i]) unusedIndices.add(i);
      }
      if (unusedIndices.length <= 1) return;
      final unusedLetters =
          unusedIndices.map((i) => _letters[i]).toList()..shuffle();
      for (int i = 0; i < unusedIndices.length; i++) {
        _letters[unusedIndices[i]] = unusedLetters[i];
      }
    });
  }

  void _giveHint() {
    if (_answerSlots.length >= _targetWord.length) return;
    final expectedChar = _targetWord[_answerSlots.length];
    for (int i = 0; i < _letters.length; i++) {
      if (!_used[i] && _letters[i] == expectedChar) {
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
      });

      if (_answerSlots.length == _targetWord.length) {
        if (!_missedOnce) _firstTryCount++;
        Future.delayed(const Duration(milliseconds: 600), () {
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
      setState(() {
        _missedOnce = true;
        widget.onMistake();
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

  @override
  Widget build(BuildContext context) {
    final current = _rounds[_currentRound];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Image Container with Blue background and White Border
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF7FB6D8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(31, 41, 55, 0.15),
                offset: Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: _buildImage(current.img),
        ),
        const SizedBox(height: 10),
        // Indonesian translation pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Letter Slots Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_targetWord.length, (i) {
              final hasLetter = i < _answerSlots.length;
              return GestureDetector(
                onTap: hasLetter ? () => _undoSlot(i) : null,
                child: Container(
                  width: 44,
                  height: 52,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: hasLetter ? widget.catColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasLetter ? Colors.white : widget.catColor,
                      width: 2.5,
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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        // Scrambled Letter Tiles
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(_letters.length, (i) {
            final used = _used[i];
            return TactileScale(
              onTap: used ? null : () => _tapLetter(i),
              disabled: used,
              pressedScale: 0.9,
              child: Opacity(
                opacity: used ? 0.3 : 1.0,
                child: Container(
                  width: 48,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.catColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(31, 41, 55, 0.18),
                        offset: Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _letters[i],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const Spacer(),
        // Bottom Action Buttons: Shuffle and Hint
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _shuffleUnused,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: widget.catColor, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(31, 41, 55, 0.12),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.autorenew_rounded,
                          color: Color(0xFF1F2937), size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Shuffle',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _giveHint,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: widget.catColor, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(31, 41, 55, 0.12),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.lightbulb_outline_rounded,
                          color: Color(0xFF1F2937), size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Hint',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
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
  final void Function(int firstTry, int total) onEnd;
  final VoidCallback onMistake;

  const _PickGame({
    required this.vocabList,
    required this.catColor,
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
      Future.delayed(const Duration(milliseconds: 700), () {
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
      setState(() {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Instruction Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          child: const Text(
            'Tap the picture that matches the word.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Prompt Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
          decoration: BoxDecoration(
            color: widget.catColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 3.5),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(31, 41, 55, 0.18),
                offset: Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          child: Text(
            current.en,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // 2x2 Picture Cards Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final isCorrect = _correctPick == index;
              return TactileScale(
                onTap: () => _tapOption(index),
                pressedScale: 0.94,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isCorrect ? Colors.green : Colors.white,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(31, 41, 55, 0.18),
                        offset: Offset(0, 6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: const Color(0xFF7FB6D8),
                      padding: const EdgeInsets.all(12),
                      child: _buildImage(_options[index].img),
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
    return Image.asset(path, fit: BoxFit.cover);
  }
}
