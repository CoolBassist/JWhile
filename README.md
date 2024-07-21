# JWhile interpreter
> An interpreter for JWhile in Dart

JWhile was a language I designed during my final year project of my bachelors. I wrote a compiler that targeted a CPU that I also designed, since then I've been wanting to write an interpreter for it so I can run the language locally, however I couldn't find a language which seemed natural to write it in. Then I discovered Dart.

## Quick Start
To start, simply compile with `jwhile.dart` as the entry point (`dart compile exe bin/jwhile.dart -o jwhile.exe`), or run `dart run`.

If you've compiled the interpreter you're able to execute JWhile files by running the executable followed by the file name. `./jwhile helloworld.jwh`. Or you can run the interpreter with no arguments to start the REPL `./jwhile`.

If you choose to run `dart run`, you will enter the REPL where you can enter statements to be executed one line at a time.

## Language Overview

JWhile is a simple imperative language designed to be Turing complete but without too many features to keep it simple to implement and define. There is only one data type, the natural numbers, and no functions. You can write comments using `//`.

### Statements
A JWhile program consists of statements which are executed linearly. 

#### Assignment
Assign a value to a variable. There is no need to declare a data type since there is only one. Variables with the same name but in different scopes are assumed to be the same variable.

```
a = 4; // Assigns the value 4 to identifier `a`
```

#### Print
Displays information to the terminal. You can either print out an expression, or print out a string.

```
print(4+9); // displays `13`
print("Hello, World!"); // displays `Hello, World!`
```

#### While loops
Executes code while the condition is true.

```
a = 0;
while(a <= 10){
    print(a);
    a = a + 1;
} // prints out the numbers 1 to 10.
```

#### For loop
Executes an initial statement, then executes the body of the code while the condition is true, each iteration ends with a statement.

```
for(a = 0; a < 10; a = a + 1){
    print(a); // prints out the numbers 1 to 9
}
```

#### If statements
Executes the body if the condition is true, if an `else` is appended then that is executed if the condition is false.

The operators are `<`, `<=`, `==`, `!=`, `>`, `>=`. 
```
if(1 == 1){
    print("One is equal to one."); // This will be executed.
}else {
    print("How did you get here?"); // This will not be executed.
}
```

