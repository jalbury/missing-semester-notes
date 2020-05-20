# Exercises for Shell Tools and Scripting
All instructions are from the Shell Tools and Scripting [lecture notes](https://missing.csail.mit.edu/2020/shell-tools/).

## Problem 1
Read `man ls` and write an `ls` command that lists files in the following manner
- Includes all files, including hidden files
- Sizes are listed in human readable format (e.g. 454M instead of 454279954)
- Files are ordered by recency
- Output is colorized
A sample output would look like this
```
 -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
 drwxr-xr-x   5 user group  160 Jan 14 09:53 .
 -rw-r--r--   1 user group  514 Jan 14 06:42 bar
 -rw-r--r--   1 user group 106M Jan 13 12:12 foo
 drwx------+ 47 user group 1.5K Jan 12 18:08 ..
```

### Solution
```
$ ls -aGhlt
```
- `-a` includes all files, including hidden files
- `-hl` lists sizes in human readable format
- `-t` orders the files by recency
- `-G` colorizes the output

## Problem 2
Write bash functions `marco` and `polo` that do the following. Whenever you execute `marco` the current working directory should be saved in some manner, then when you execute `polo`, no matter what directory you are in, `polo` should `cd` you back to the directory where you executed `marco`. For ease of debugging you can write the code in a file `marco.sh` and (re)load the definitions to your shell by executing `source marco.sh`.

### Solution
Source `marco.sh` (stores the definitions for `marco` and `polo`):
```
$ source marco.sh
```

Run `marco` and `polo`:
```
$ marco
$ polo
```

`marco` stores the current working directory (obtained using `pwd`) to an environment variable, then `polo` `cd`s to the path stored in the environment variable.

## Problem 3
Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run. Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end. Bonus points if you can also report how many runs it took for the script to fail.
```bash
 #!/usr/bin/env bash

 n=$(( RANDOM % 100 ))

 if [[ n -eq 42 ]]; then
    echo "Something went wrong"
    >&2 echo "The error was using magic numbers"
    exit 1
 fi

 echo "Everything went according to plan"
```

### Solution
Run `debug.sh`:
```
$ bash debug.sh
```

To clean up, remove all files in the directory that start with `run-`:
```
$ rm run-*
```

`debug.sh` runs the above code (stored in `buggy.sh`) and redirects STDOUT and STDERR to files. This is done repeatedly until `buggy.sh` returns a non-zero return code (meaning there was an error). The number of times `buggy.sh` was run before failing is then printed to STDOUT.

## Problem 4
As we covered in the lecture `find`'s `-exec` can be very powerful for performing operations over the files we are searching for. However, what if we want to do something with **all** the files, like creating a zip file? As you have seen so far commands will take input from both arguments and STDIN. When piping commands, we are connecting STDOUT to STDIN, but some commands like `tar` take inputs from arguments. To bridge this disconnect there’s the [`xargs`](http://man7.org/linux/man-pages/man1/xargs.1.html) command which will execute a command using STDIN as arguments. For example `ls | xargs rm` will delete the files in the current directory. Your task is to write a command that recursively finds all HTML files in the folder and makes a zip with them. Note that your command should work even if the files have spaces (hint: check `-d` flag for `xargs`)

### Solution
```
$ find . -name '*.html' | xargs -d '\n' zip html_files.zip
```

The `find` command will recursively find all HTML files (all files whose names end with `.html`) in the current directory. Then, these files are sent to `zip` via `xargs` (the `-d` option tells `xargs` to group by newlines, not just any whitespace, since the files may have spaces in their names) to be compressed into `html_files.zip`.

Note: on macOS, you'll need to install and use `gxargs` instead of `xargs` to use the `-d` option. This can be done through Homebrew via `brew install findutils`.

## Problem 5
(Advanced) Write a command or script to recursively find the most recently modified file in a directory. More generally, can you list all files by recency?

### Solution
```
find . -maxdepth 1 -type f -printf '%P %T@\n' | sort -k 2 -r | awk '{ print $1 }'
```
The `find` command will search in the current directory (not recursively, because `maxdepth` was set to `1`) and print the files (no directories, since `-type f` is used) in `<file name> <time modified>` format. The `sort` command will then sort by the second column (time modified) in reverse order (most recent times first). The `awk` command will then print only the first column (the file names).

To get only the most recently modified file, just pipe the result to `head`:
```
find . -maxdepth 1 -type f -printf '%P %T@\n' | sort -k 2 -r | awk '{ print $1 }' | head -n 1
```

Note: on macOS, you'll need to install and use `gfind` instead of `find` to use the `-printf` option. This can be done through Homebrew via `brew install findutils`.
