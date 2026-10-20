# Neovim navigation and actions

## Navigation and buffers

### Scrolling

Ctrl e / Ctrl y - Scroll down / up one line
Ctrl d / Ctrl u - Scroll half a page up and down, cursor is moved
Ctrl f / Ctrl b - Scroll a full page up and down, cursor is moved
5 Ctrl e / 5 Ctrl y - Scroll down / up 5 lines
zz - Scrolls the cursor line to the middle of the screen
zt - Scrolls the cursor line to the top of the screen
zb - Scrolls the cursor line to the bottom of the screen

### Moving between splits

Ctrl h / Ctrl l - move to the window on the left / right
Ctrl w w - move to the next window
Ctrl w p - jump back to the window you were in before
Space e - open or close the file tree (project root)
Space E - open or close the file tree (current folder)

### Moving between buffers

Shift h / Shift l - previous / next file in the tab bar
\[ b / \] b - previous / next file in the tab bar
Space b b - switch back and forth between the last two files

### Closing buffers

Space b d - close the current file, keep the window layout
Space b D - close the current file and its window layout
Space b o - close all other files
Space b r - close files to the right in the tab bar
Space b l - close files to the left in the tab bar

### List open or recent files

Space , - list of open files, most recently used first
Space f b - list of open files (same as Space ,)
Ctrl j / Ctrl k - move down / up in the list
Enter - open the highlighted file from the list
Ctrl x - close the highlighted file in the list
Space f r - recent files, including closed ones
Space (wait) - pop-up menu of available keys

### Navigation between errors and diagnostic

\[ e / \] e - previous / next error
ö e / ä e - previous / next error
\[ w / \] w - previous / next warning
ö w / ä w - previous / next warning
\[ d / \] d - previous / next diagnostic
ö d / a d - previous / next diagnostic
\[ s / \] s - previous / next misspelling
ö s / ä s - previous / next misspelling

### Spellcheck corrections and toggling

z= - show suggested corrections for the word
zg - mark as correct and add to personal word list
zw - mark as wrong
zug - undo marking of the word as correct
zuw - undo marking of the word as wrong
Space u s - to toggle spellcheck for current buffer

## Tree keybinds

### File and folder

. — focus the selected file in the tree.
h — close its parent directory.
Z — close all open directories.
Ctrl v - open in a new vertical split
Ctrl s - open in a new horizontal split

### Toggling dotfiles and hidden files

Shift H toggles dotfiles
Shift I toggles git-ignored files

## Searching

Space f f - fuzzy find a file by name across the project, case insensitive unless smartcase is enabled.

## New lines

o - open a new line below the cursor and enter insert mode
O - open a new line above the cursor and enter insert mode

\] Space - adds a blank line below the cursor but does not move the cursor
\[ Space - adds a blank line before the cursor but does not move the cursor

## Undo and Redo

u - undo
Ctrl r - redo

## Functions, methods and classes

### Function and method navigation

ä f - next function or method start
ö f - previous function or method start
ä Shift+f - next function or method end
ö Shift+f - previous function or method end
ä a - next parameter
ö a - previous parameter
3 ä f - jump 3 functions forward (any count works)

### Class navigation

ä c - next class (also traits and interfaces)
ö c - previous class
ä C - next class end
ö C - previous class end

## Other ä/ö motions

ä h - next git change (hunk)
ö h - previous git change (hunk)
ä q - next quickfix item
ö q - previous quickfix item
ä t - next TODO comment
ö t - previous TODO comment
ä b - next buffer
ö b - previous buffer
ä (pause) - show all forward motions in the which-key popup
ö (pause) - show all backward motions in the which-key popup

## Properties, constants and symbols

Space s s - fuzzy-pick a symbol in the file (methods, properties, constants)
Space c s - toggle the aerial outline sidebar
j / k - move up and down the list (inside the sidebar)
Enter - jump to the selected symbol (inside the sidebar)
{ / } - previous / next symbol (inside the sidebar)

## Lines

4 2 Shift+g - go to line 42
: 4 2 Enter - go to line 42
g g - top of file
Shift+g - bottom of file
5 k - 5 lines up
6 j - 6 lines down
5 - - 5 lines up, to the first non-blank character
6 + - 6 lines down, to the first non-blank character
Space u l - cycle the line-number options

## Jumping back and forth

Ctrl+o - jump back to the previous location
Ctrl+i (or Tab) - jump forward again

## Wrapping

gsa + motion + character - gsaiw", turns foo into "foo"
visual select + gsa + character - select text, gsa"
gsa + $ + char - wrap entire line from cursor, gsa$) wraps the line in brackets starting from the cursor
gsd + char - delete surrounding, gsd" turns "foo" into foo
gsr + old + new - gsr"' turns "foo" into 'foo'

## Cut, delete and paste

### Deletion

diw - delete the current word
d $ / d 0 - delete from cursor to the end / start of current line

### Cut copy and paste

dd - cut a line
p / P - paste the buffer from cursor position / above cursor line

Linewise (whole lines):
Copied by: dd, yy, cc, D with a count, V (visual line mode) then y/d, or any operator with a line motion such as dj, yk or d}.
What p does: p puts it on a new line below the current one, and P puts it above. The cursor's column doesn't matter.

Characterwise (part of a line):
Copied by: yw, diw, x, d$/D, yi", v (visual mode) then y/d.
What p does: p inserts it right after the cursor, and P inserts it before the cursor, on the same line.

Blockwise (a rectangle):
Copied by: Ctrl-v (visual block mode) then y/d.
What p does: pastes it as a column starting at the cursor.

That's why ddp swaps two lines: dd stores a whole line, so p drops it below the next one.

A common surprise is y$ or v$y on a full line. Even though you selected every character, it's stored as characterwise, so it pastes inline.
Use yy or V when you want line behaviour.

To check what a register holds: run :reg to list all registers. The Type column shows l (line), c (char) or b (block).

To paste a different way:
\:put always pastes as a new line below, even characterwise text (:put! pastes above).
gp / gP work like p / P but leave the cursor just after the pasted text, which is handy for pasting several times in a row.
