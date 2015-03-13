// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library linter.src.rules.count_constants;

import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/element.dart';
import 'package:linter/src/linter.dart';

const desc = 'Count constant variable declarations';

const details = '...';

// TODO(paulberry): which group should I use?
const group = Group.STYLE_GUIDE;

// TODO(paulberry): which kind should I use?
const kind = Kind.DO;

typedef bool VariableDeclarationPredicate(VariableDeclaration node);

class CountConstructors extends LintRule {
  CountConstructors.constant() : super(
          name: 'count_constant_constructors',
          description: 'Count constant constructors',
          details: details,
          group: group,
          kind: kind);

  @override
  AstVisitor getVisitor() => new _ConstructorVisitor(this);
}

class CountVariables extends LintRule {
  final VariableDeclarationPredicate predicate;

  CountVariables.constant()
      : super(
          name: 'count_constant_variables',
          description: 'Count constant variables',
          details: details,
          group: group,
          kind: kind),
        predicate = isConst;

  CountVariables.finals()
      : super(
          name: 'count_final_variables',
          description: 'Count final variables',
          details: details,
          group: group,
          kind: kind),
        predicate = isFinal;

  @override
  AstVisitor getVisitor() => new _VariableDeclarationVisitor(this);

  static bool isConst(VariableDeclaration node) =>
      node.initializer != null && node.isConst;

  static bool isFinal(VariableDeclaration node) => !isConst(node) &&
      node.initializer != null &&
      node.isFinal &&
      node.element.enclosingElement is! ExecutableElement;
}

class _ConstructorVisitor extends RecursiveAstVisitor<Object> {
  final CountConstructors rule;
  _ConstructorVisitor(this.rule);

  @override
  Object visitConstructorDeclaration(ConstructorDeclaration node) {
    super.visitConstructorDeclaration(node);
    if (node.constKeyword != null) {
      ConstructorElement element = node.element;
      if (element != null) {
        rule.reportLint(node);
      }
    }
    return null;
  }
}

class _VariableDeclarationVisitor extends RecursiveAstVisitor<Object> {
  final CountVariables rule;
  _VariableDeclarationVisitor(this.rule);

  @override
  Object visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);
    if (rule.predicate(node)) {
      rule.reportLint(node);
    }
    return null;
  }
}
