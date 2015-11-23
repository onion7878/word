---

layout: post
title: Get file path by drag it
date: 14-11-18 14:15:00
tags: [code. delphi]
categories: [code]

---

must use the `ShellAPI` unit

```pascal
DragAcceptFiles(Self.edit.Handle , True);
Application.OnMessage := Self.AppMessage;
```

`AppMessage` function implementation

```pascal
AppMessage(var Msg: TMsg; var Handled: Boolean);

var
  FileCount : integer;
  FilePath  : array[0..MAX_PATH - 1] of Char;
begin
  case Msg.message of
    WM_DROPFILES :
    begin
      FileCount := DragQueryFile(msg.wParam, $FFFFFFFF, FilePath, MAX_PATH) ;
      case FileCount of
        1 :
        begin
          DragQueryFile(msg.wParam, 0, FilePath, MAX_PATH * SizeOf(Char));
          DragFinish(Msg.wParam);
          if msg.hwnd = Self.edit.Handle then
          begin
            // do something
          end;
          Handled := True;
        end;
      end;
    end;
  end;
end;
```
