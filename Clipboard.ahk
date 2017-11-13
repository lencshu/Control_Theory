;将本地图片插入Markdown
^+c:: ;ctrl+shift+c
clipboard= ;清空剪贴板
send, ^c
clipwait
clipboard = <p align="center">![](%clipboard%)</p>
msgbox, 图片路径已复制！%clipboard%
return