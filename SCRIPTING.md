# Scripting Reference
This document gives a general overview of writing scripts for Friday Night Rewrite.

## General Overview
Scripting in Friday Night Rewrite works using **hscript** (https://github.com/HaxeFoundation/hscript), a simplified version of Haxe coding. Because of this, **it is recommended that you have at least a basic understanding of Haxe syntax**: https://haxe.org/manual.
However, there are some big differences to note:
- Currently, there is **no support for classes, typedefs, packages, or custom imports**
- The `switch` construct is supported but not pattern matching
- You can only declare one variable per `var` statement



## Universal Imports
The following are
