---

layout: post
date: 14-06-04 21:30:31
title: Compiler not re initialize local variable inside the loop
tags: [delphi, code, study, compiler]
categories: [code]

---

#### Code

```pascal
function Foo: string;
begin
  Result := Result + 'X';
end;

var
  i: Integer;

begin
  for i := 1 to 5 do
    Writeln(Foo);
  Writeln(Foo);
  Writeln(Foo);
end;
```

#### Output

```
X
XX
XXX
XXXX
XXXXX
X
X
```

### Reference

- [Do I need to setLength a dynamic array on initialization?](http://stackoverflow.com/a/5315254/724897)

