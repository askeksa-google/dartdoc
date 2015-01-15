// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartdoc.html_printer;

class HtmlPrinter {
  StringBuffer buffer = new StringBuffer();
  bool startOfLine = true;
  List<String> tags = [];
  List<bool> indents = [];
  String indent = '';

  HtmlPrinter() {
    writeln('<!DOCTYPE html>');
    writeln();
    writeln('<!-- generated by dartdoc -->');
    writeln();
  }

  void generateHeader() {
    // header
    startTag('header');
    endTag();
  }

  void generateFooter() {
    // footer
    startTag('footer');
    endTag();
  }

  void start({String title, String cssRef, String theme, String jsScript,
      String inlineStyle}) {
    startTag('html', newLine: false);
    writeln();
    startTag('head');
    writeln('<meta charset="utf-8">');
    writeln(
        '<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    if (title != null) {
      writeln('<title>${title}</title>');
    }
    if (cssRef != null) {
      writeln('<link href="${cssRef}" rel="stylesheet" media="screen">');
    }
    if (theme != null) {
      writeln('<link href="${theme}" rel="stylesheet">');
    }
    if (jsScript != null) {
      writeln('<script src="${jsScript}"></script>');
    }
    if (inlineStyle != null) {
      startTag('style');
      writeln(inlineStyle);
      endTag();
    }
    endTag();
    writeln();
    startTag('body', newLine: false);
    writeln();
  }

  void startTag(String tag, {String attributes, bool newLine: true}) {
    if (attributes != null) {
      if (newLine) {
        writeln('<${tag} ${attributes}>');
      } else {
        write('<${tag} ${attributes}>');
      }
    } else {
      if (newLine) {
        writeln('<${tag}>');
      } else {
        write('<${tag}>');
      }
    }
    indents.add(newLine);
    if (newLine) {
      indent = '$indent\t';
    }
    tags.add(tag);
  }

  void tag(String tag, {String attributes, String contents}) {
    if (attributes != null) {
      if (contents != null) {
        writeln('<$tag $attributes>$contents</$tag>');
      } else {
        writeln('<$tag $attributes></$tag>');
      }
    } else {
      if (contents != null) {
        writeln('<$tag>$contents</$tag>');
      } else {
        writeln('<$tag></$tag>');
      }
    }
  }

  void endTag() {
    String tag = tags.removeLast();
    bool wasIndent = indents.removeLast();
    if (wasIndent) {
      indent = indent.substring(0, indent.length - 1);
    }
    writeln('</${tag}>');
  }

  void end() {
    // body
    endTag();
    // html
    endTag();
  }

  String toString() {
    return buffer.toString();
  }

  void write(String str) {
    if (startOfLine) {
      buffer.write(indent);
      startOfLine = false;
    }
    buffer.write(str);
  }

  void writeln([String str]) {
    if (str == null) {
      write('\n');
    } else {
      write('${str}\n');
    }
    startOfLine = true;
  }
}
