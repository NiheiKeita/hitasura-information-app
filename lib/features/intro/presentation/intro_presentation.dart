import 'package:flutter/material.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF1E3A8A);
const _cGrayText = Color(0xFF64748B);

class FactorIntroPresentation extends StatelessWidget {
  const FactorIntroPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return _IntroScaffold(
      title: '因数分解の遊び方',
      sections: const [
        _Section(
          title: '因数分解とは',
          body:
              '式を「かけ算の形」に分けることです。たとえば、x^2 + 5x + 6 は (x + 2)(x + 3) に分けられます。',
        ),
        _Section(
          title: 'ゲームの流れ',
          body:
              '画面に式が表示されます。答えの欄をタップして入力し、数字パッドで値を入れます。正解したらすぐ次の問題へ進みます。',
        ),
        _Section(
          title: '因数分解の遊び方',
          body:
              '空欄をタップして入力先を選び、数字を入れます。符号は「+/-」で切り替えます。答えが完成したら「回答する」。',
        ),
        _Section(
          title: '入力のコツ',
          body:
              '迷ったら「クリア」でリセットできます。テンポよく入力すると気持ちよく進みます。',
        ),
        _Section(
          title: '気楽にどうぞ',
          body:
              '正解数やタイムは自分のペースで。気持ちよくテンポ良く進めることを優先しています。',
        ),
      ],
    );
  }
}

class PrimeIntroPresentation extends StatelessWidget {
  const PrimeIntroPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return _IntroScaffold(
      title: '素因数分解の遊び方',
      sections: const [
        _Section(
          title: '素因数分解とは',
          body:
              '数を素数のかけ算に分けることです。たとえば、84 は 2×2×3×7 の形に分けられます。',
        ),
        _Section(
          title: 'ゲームの流れ',
          body:
              '画面に数が表示されます。素数の下にある指数の欄をタップして入力します。',
        ),
        _Section(
          title: '素因数分解の遊び方',
          body:
              '指数を入れ終えたら「回答する」。迷ったら「クリア」でやり直せます。',
        ),
        _Section(
          title: '入力のコツ',
          body:
              '入力先はタップで切り替えます。間違えそうなときは小さく確認しながら進めましょう。',
        ),
        _Section(
          title: '気楽にどうぞ',
          body:
              '正解数やタイムは自分のペースで。気持ちよくテンポ良く進めることを優先しています。',
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _cMain,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: _cGrayText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroScaffold extends StatelessWidget {
  const _IntroScaffold({
    required this.title,
    required this.sections,
  });

  final String title;
  final List<_Section> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: _cMain,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) => sections[index],
      ),
    );
  }
}
