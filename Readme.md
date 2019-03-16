# areadiff

Areadiff is a vim plugin which checks text difference between two areas selected in visual mode.


## Setting

Here is an example of setting up areadiff plugin.
`Areadiff1` saves a text area in visual mode into a variable.
`Areadiff2` saves to other variable and compares the variables to see the difference.

```vim
command! -range Areadiff1 call areadiff#save_txtarea1()
command! -range Areadiff2 call areadiff#save_txtarea2() | echo areadiff#exe_diff()
```

## Usage

For example, consider the following text.

1. move the cursor to '1' at the first line
1. type `vl:Areadiff1<Enter>` to save the text area (12)
1. move the cursor to '3' at the second line
1. type `vl:Areadiff2<Enter>` to save the text area (32) and print the difference between the text areas on the command line

```vim
12
32
```
