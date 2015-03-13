// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library linter.src.rules.count_constants;

import 'package:analyzer/src/generated/ast.dart';
import 'package:linter/src/linter.dart';

const desc = 'Count constant variable declarations';

const details = '...';

// TODO(paulberry): which group should I use?
const group = Group.STYLE_GUIDE;

// TODO(paulberry): which kind should I use?
const kind = Kind.DO;

class CountConstants extends LintRule {
  CountConstants() : super(
          name: 'count_constants',
          description: desc,
          details: details,
          group: group,
          kind: kind);

  @override
  AstVisitor getVisitor() => new _Visitor(this);
}

class _Visitor extends RecursiveAstVisitor<Object> {
  final LintRule rule;
  _Visitor(this.rule);

  @override
  Object visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);
    Expression initializer = node.initializer;
    if (initializer != null && node.isConst) {
      rule.reportLint(node);
    }
    return null;
  }
}
