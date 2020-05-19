# Shell Scripting Using Bash
- Shell scripts (vs. scripts in other programming languages) are useful because they're optimized for shell related tasks.
  - For example, creating command pipelines and saving results to file are primitives.
- In a shell script, think of it like you're typing in a shell prompt. This will help take out some of the weirdness.
  - For example, the fact that `foo=bar` is okay but `foo = bar` is not is weird, but it makes sense because in a shell prompt the first word is considered the program and the rest are considered arguments to the program (so `foo = bar` is actually saying "call the `foo` program with the arguments `=` and `bar`").
- `'` and `"` can both be used to define strings, but they are different. `'` defines a string literal and will not substitute the name of a variable with its value (so, `echo '$foo'` prints `$foo`), while `"` will (so, `echo "$foo"` prints the value in the variable `foo`).
- Below is an example of a function that creates a directory and `cd`s into it, where the variable `1` stores the first argument to the function:
```
mcd () {
  mkdir -p "$1"
  cd "$1"
}
```
- Below is a list of special variables in bash:
  - `$0`: name of the script.
  - `$1` to `$9`: arguments to the script (or function if you're inside a function).
  - `$@`: all the arguments.
    - This can be useful for looping over all arguments (for example, if the arguments are files you want to do something with).
  - `$#`: number of arguments.
  - `$?`: return code of the previous command.
  - `$$`: process ID (pid) for the current script.
  - `!!`: entire last command, including arguments.
    - This can be useful if you execute a command and it fails due to missing permissions; you can just do `sudo !!` to run the last command as root.
  - `$_`: last argument from the last command.
- Commands return output using `stdout`, errors using `stderr`, and a return code to report errors in a more script-friendly manner.
  - Return code of 0 typically means everything went okay; anything different means an error occured
  - Use the logical OR (`||`) and logical AND (`&&`) operators to execute a command only if the previous command failed or suceeded, respectively (think of "success" as "true" and "failure" as "false").
    - `command1 || command2`: `command2` is only run if `command1` failed.
    - `command1 && command2`: `command2` is only run if `command1` succeeded.
- If you want to save the output of a command into a variable, do `var=$(command)`.
- When performing comparisons, using `[[ ]]` rather than `[ ]` makes mistakes less likely but makes the program less portable (`[[ ]]` is a bashism that isn't compatible with `sh`).
- To provide arguments that are similar, you can use shell globbing:
  - Wildcards: use `?` and `*` to match one or any amount of characters respectively.
    - For example, `rm foo?` would delete `foo1` and `foo2` but not `foo` or `foo10`, while `rm foo*` would remove all of those files.
  - Curly braces: use `{ }` when you have a common substring in a series of commands.
    - For example, `convert image.{png, jpg}` expands to `convert image.png image.jpg`.
- You can also execute other scripts (i.e., Python scripts) from the terminal by using a shebang line at the top of the script.
  - The shebang line tells the shell what program to load to execute the script (i.e., the Python interpreter). It is good practice to use the `env` command instead of hard-coding the path (for example, use `#!/usr/bin/env python` instead of `#!/usr/local/bin/python`) for portability.
- Use `man command` or `tldr command` (focuses more on example use cases of the command) to find out how to use a certain command.
- Use `find` to recursively search for files by some criteria (name, size, modified time, etc.) and optionally execute programs on those files (can be any command that takes names of files as input, such as `rm`).
  - `fd` is a simpler and more user-friendly version of `find`.
  - If you're worried about the efficiency of looking for files vs. compiling a database for quickly searching, use `locate`.
    - `locate` is much faster but less fresh since the files in the database it uses are typically updated daily.
    - `locate` only allows you to search for files by name, while `find` allows you to search by other attributes as well.
- Use `grep` to find search for text *inside* files.
  - ripgrep (`rg`) adds some improvements to `grep`, such as ignoring `.git` folders and adding multi-CPU support.
- Use `history` to see past commands you've run.
  - Use `history | grep pattern` to find `pattern` in your shell history.
  - If you start a command with a leading space it won't be stored in your shell history.
    - You can also remove entries from your shell history by editing `.bash_history` (there's equivalent files in other shells as well).
- Find frequent and/or recent files using `fasd`.
