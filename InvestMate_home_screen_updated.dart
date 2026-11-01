import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../widgets/investment_tile.dart';
import '../investment_details/investment_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _orbController;

  final List<Map<String, String>> _messages = [];

  final List<String> _suggestions = [
    'How is my portfolio performing?',
    'Explain my investment returns',
    'How can I diversify my portfolio?',
    'Suggest a long-term investment strategy',
  ];

  bool _showInvestments = false;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  void _sendMessage([String? suggestedMessage]) {
    final message = suggestedMessage ?? _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'type': 'user', 'message': message});
      _messages.add({
        'type': 'assistant',
        'message': _getMockResponse(message),
      });
    });

    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getMockResponse(String message) {
    final question = message.toLowerCase();

    if (question.contains('portfolio') ||
        question.contains('performing') ||
        question.contains('return')) {
      return 'Your portfolio is currently valued at ₹2,87,250, with an '
          'overall gain of ₹12,840 (+4.68%). Your investments are showing '
          'positive growth. Keep reviewing your asset allocation regularly.';
    }

    if (question.contains('diversif')) {
      return 'Diversification helps spread investment risk. Your current '
          'portfolio includes stocks, mutual funds and fixed deposits. '
          'You can review the balance between these assets based on your '
          'financial goals and risk tolerance.';
    }

    if (question.contains('mutual')) {
      return 'Mutual funds pool money from multiple investors and invest it '
          'in assets such as stocks and bonds. They can help you diversify '
          'without selecting every individual security yourself.';
    }

    if (question.contains('long-term') || question.contains('strategy')) {
      return 'For long-term investing, consider your goals, investment '
          'horizon and risk tolerance. A diversified approach and periodic '
          'portfolio reviews can help you stay aligned with your goals.';
    }

    return 'That is a great question! I can help you explore your portfolio, '
        'understand investment concepts and review different investment '
        'strategies. What would you like to explore next?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 28),
                    if (_messages.isEmpty) ...[
                      _buildWelcomeSection(),
                      const SizedBox(height: 28),
                      _buildPortfolioSummary(),
                      const SizedBox(height: 28),
                      _buildSuggestions(),
                    ] else ...[
                      _buildConversation(),
                      const SizedBox(height: 20),
                    ],
                    const SizedBox(height: 20),
                    _buildInvestmentSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          height: 43,
          width: 43,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF183B48), Color(0xFF159A91)],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
        const SizedBox(width: 11),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'InvestMate',
              style: TextStyle(
                color: Color(0xFF183B48),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'YOUR INVESTMENT COMPANION',
              style: TextStyle(
                color: Color(0xFF84949F),
                fontSize: 9,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE2F3F0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, color: Color(0xFF159A91), size: 8),
              SizedBox(width: 6),
              Text(
                'AI Ready',
                style: TextStyle(
                  color: Color(0xFF167E78),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Center(
          child: AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              final value = _orbController.value;
              return Transform.scale(
                scale: 1 + (value * 0.045),
                child: Container(
                  height: 155,
                  width: 155,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF8AE1D6).withValues(alpha: 0.65),
                        const Color(0xFF159A91).withValues(alpha: 0.25),
                        const Color(0xFF8B83DC).withValues(alpha: 0.12),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF159A91)
                            .withValues(alpha: 0.18),
                        blurRadius: 35 + (value * 15),
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      height: 104,
                      width: 104,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF183B48),
                            Color(0xFF159A91),
                            Color(0xFF8B83DC),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 23),
        const Text(
          'Hello, Investor!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF183B48),
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 9),
        const Text(
          'Your financial journey, made smarter.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF65758B), fontSize: 14),
        ),
        const SizedBox(height: 12),
        const Text(
          'What would you like to explore today?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF183B48),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF102D39),
            Color(0xFF176B6B),
            Color(0xFF159A91),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF183B48).withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: Color(0xFFA6DCD5),
                size: 19,
              ),
              SizedBox(width: 8),
              Text(
                'YOUR PORTFOLIO',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(
                Icons.north_east_rounded,
                color: Colors.white70,
                size: 19,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '₹2,87,250',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: Color(0xFFA6DCD5),
                size: 19,
              ),
              SizedBox(width: 5),
              Text(
                '+₹12,840  (+4.68%)',
                style: TextStyle(
                  color: Color(0xFFA6DCD5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                'Overall returns',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white24),
          const SizedBox(height: 15),
          Row(
            children: [
              _portfolioMetric('Invested', '₹2,74,410'),
              const Spacer(),
              _portfolioMetric("Today's P&L", '+₹1,240'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _portfolioMetric(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFF159A91),
              size: 19,
            ),
            SizedBox(width: 8),
            Text(
              'TRY ASKING ME',
              style: TextStyle(
                color: Color(0xFF65758B),
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        ..._suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _sendMessage(suggestion),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE3EBEE)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          suggestion,
                          style: const TextStyle(
                            color: Color(0xFF183B48),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF159A91),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildConversation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOUR CONVERSATION',
          style: TextStyle(
            color: Color(0xFF84949F),
            fontSize: 10,
            letterSpacing: 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ..._messages.map((message) {
          final isUser = message['type'] == 'user';
          return Align(
            alignment:
                isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 310),
              margin: const EdgeInsets.only(bottom: 17),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF183B48) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(19),
                  topRight: const Radius.circular(19),
                  bottomLeft: Radius.circular(isUser ? 19 : 5),
                  bottomRight: Radius.circular(isUser ? 5 : 19),
                ),
                border: isUser
                    ? null
                    : Border.all(color: const Color(0xFFE5ECEF)),
              ),
              child: Text(
                message['message'] ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF183B48),
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInvestmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _showInvestments = !_showInvestments;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5F4),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.insights_rounded,
                  color: Color(0xFF159A91),
                  size: 22,
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Text(
                    'Explore your investments',
                    style: TextStyle(
                      color: Color(0xFF183B48),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Icon(
                  _showInvestments
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF159A91),
                ),
              ],
            ),
          ),
        ),
        if (_showInvestments) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: mockInvestments.map((item) {
                return InvestmentTile(
                  investment: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvestmentDetailsScreen(
                          investment: item,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF183B48).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F6F7),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFE5ECEF)),
              ),
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: 'Ask InvestMate anything...',
                  hintStyle: TextStyle(
                    color: Color(0xFF84949F),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(),
            child: Container(
              height: 49,
              width: 49,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF183B48), Color(0xFF159A91)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
