import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:yaaa/components/code_wrapper.dart';
import 'package:yaaa/components/latex.dart';

class MarkdownRenderer extends StatelessWidget {
  final String data;

  const MarkdownRenderer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    codeWrapper(child, text, language) =>
        CodeWrapperWidget(child, text, language);
    return MarkdownBlock(
        data: data,
        generator: MarkdownGenerator(
          inlineSyntaxList: [LatexSyntax()],
          generators: [latexGenerator],
        ),
        config: config.copy(configs: [
          isDark
              ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
              : const PreConfig().copy(wrapper: codeWrapper),
        ]));
  }
}
