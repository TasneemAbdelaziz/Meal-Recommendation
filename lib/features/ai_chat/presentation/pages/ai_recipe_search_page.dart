import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app_withai/features/ai_chat/presentation/bloc/ai_recipe_bloc.dart';
import 'package:recipe_app_withai/features/ai_chat/presentation/widget/bot_bubble.dart';
import 'package:recipe_app_withai/features/ai_chat/presentation/widget/recipes_grid.dart';
import 'package:recipe_app_withai/features/ai_chat/presentation/widget/user_bubble.dart';

class AiRecipeChatPage extends StatefulWidget {
  const AiRecipeChatPage({super.key});

  @override
  State<AiRecipeChatPage> createState() => _AiRecipeChatPageState();
}

class _AiRecipeChatPageState extends State<AiRecipeChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  String? _lastUserMessage;

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _lastUserMessage = text);
    _controller.clear();

    context.read<AiRecipeBloc>().add(AiRecipeExtractAndSearch(text));

    // scroll after sending
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with AI"),),
      body: BlocConsumer<AiRecipeBloc, AiRecipeState>(
        listener: (context, state) {
          // ensure latest bot message appears
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        },
        builder: (context, state) {
          final messages = <Widget>[];
      
          // User message bubble
          if (_lastUserMessage != null) {
            messages.add(UserBubble(text: _lastUserMessage!));
          }
      
          // Bot response based on state
          if (state is AiRecipeLoading) {
            messages.add(
              const BotBubble(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text('Search for Recipes...'),
                  ],
                ),
              ),
            );
          } else if (state is AiRecipeError) {
            messages.add(
              BotBubble(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _lastUserMessage == null ? null : () {
                        context
                            .read<AiRecipeBloc>()
                            .add(AiRecipeExtractAndSearch(_lastUserMessage!));
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AiRecipeLoaded) {
            if (state.recipes.isEmpty) {
              messages.add(
                const BotBubble(
                  child: Text('i cannot found recipes try another words🙂'),
                ),
              );
            } else {
              messages.add(
                BotBubble(
                  child: Text(
                    'found ${state.recipes.length} recipe 👇',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
      
              // Recipes grid as "chat attachment"
              messages.add(
                BotBubble(
                  child: RecipesGrid(recipes: state.recipes),
                ),
              );
            }
          }
          else {
            // initial
            messages.add(
              const BotBubble(
                child: Text('write recipe you want to search for example: "chicken rice" or ingredients'),
              ),
            );
          }
      
          return Column(
            children: [
              // Messages
              Expanded(
                child: ListView.separated(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  itemBuilder: (context, i) => messages[i],
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: messages.length,
                ),
              ),
      
              // Input bar
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: InputDecoration(
                            hintText: 'write your question...',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _send,
                        icon: const Icon(Icons.send),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}