" Vim syntax file
" Language: Ink
" Maintainer: Rob Whitaker <dev@robwhitaker.com>

" Don't load the syntax plugin multiple times
if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "ink"

"=================
" MATCHES
"=================

" Basic keywords
syn keyword inkBasicKeywords INCLUDE EXTERNAL function DONE END

" Basic data types
syn keyword inkBooleans true false                      contained
syn match   inkNumber   "\v[0-9]+"                      contained
syn region  inkString   start="\"" skip="\\\"" end="\"" contained

" Assignment
syn region  inkAssignment   start=/\v^\s*VAR/ms=e-2   end="\v$" contains=inkVarKeyword,inkVarName,inkExpr
syn region  inkAssignment   start=/\v^\s*CONST/ms=e-4 end="\v$" contains=inkVarKeyword,inkVarName,inkExpr
syn keyword inkVarKeyword   VAR CONST                           nextgroup=inkVarName                        skipwhite contained
syn match   inkVarName      "\v[a-zA-Z0-9_]+"                   nextgroup=inkExpr                           skipwhite contained
syn match   inkExpr         ".*"                                contains=inkBooleans,inkNumber,inkString    skipwhite contained
" ^ TODO: proper expr definition

" Comments and TODOs
syn keyword inkTodo         TODO FIXME XXX        contained
syn match   inkComment      "//.*$"               contains=inkTodo
syn region  inkBlockComment start="/\*" end="\*/" contains=inkTodo
syn match   inkTodoComment  "\v^\s*TODO:.*$"

" Tags
syn region inkTag start=/\v#/ excludenl end=/\v\s*(#|$)/me=s-1 contains=inkComment,inkBlockComment

" Choices
syn region inkChoice                                    start=/\v^\s*(\*|\+)/ms=e-1           end="\v$" contains=inkChoiceType

" Choice types: repeatable / one-time
syn region inkChoiceType matchgroup=inkRepeatableChoice start="\v\+(\+|\s)*"        excludenl end="\v$" contains=inkChoiceText contained
syn region inkChoiceType matchgroup=inkOneTimeChoice    start="\v\*(\*|\s)*"        excludenl end="\v$" contains=inkChoiceText contained

" Choice text
syn match  inkChoiceText         "\v.*"                                    contains=inkChoiceTextBrackets                 contained
syn region inkChoiceTextBrackets start="\v\["                 end="\v\].*" contains=inkBlockComment,inkChoiceTextHidden   contained oneline
syn region inkChoiceTextHidden   start=/\v\]/ms=e+1 excludenl end=/\v$/    contains=inkComment,inkBlockComment,inkTag     contained oneline

" Knots, stitches, and functions
syn match   inkStitchKnotLabel "\v[a-zA-Z0-9_]+"                                  contained
syn match   inkStitchKnotEnds  "\v\="                                             contained

syn region  inkKnot            start="\v\={2,}\s*"         excludenl end="\v\s*$" contains=inkStitchKnotLabel,inkStitchKnotEnds

syn region  inkKnot            start="\v\={2,}\s*function" excludenl end="\v\s*$" contains=inkFunction,inkStitchKnotEnds
syn keyword inkFunction        function contained
" ^ TODO: highlight other parts of function

syn region inkStitch           start="\v\=[^\=]\s*"        excludenl end="\v\s*$" contains=inkStitchKnotLabel,inkStitchKnotEnds

"=================
" COLORS
"=================

hi def link inkBasicKeywords        Keyword
hi def link inkVarKeyword           Keyword
hi def link inkBooleans             Boolean
hi def link inkNumber               Number
hi def link inkString               String
hi def link inkTodo                 Todo
hi def link inkTodoComment          Todo
hi def link inkComment              Comment
hi def link inkBlockComment         Comment
hi def link inkTag                  Label
hi def link inkRepeatableChoice     Operator
hi def link inkOneTimeChoice        Operator

hi def link inkChoiceText           Statement
hi def link inkChoiceTextBrackets   Operator
hi def link inkChoiceTextHidden     Exception

hi def link inkStitchKnotEnds       Operator
hi def link inkStitchKnotLabel      Identifier
hi def link inkFunction             Keyword
