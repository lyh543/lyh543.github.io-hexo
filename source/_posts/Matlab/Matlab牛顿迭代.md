---
title: Matlab 牛顿迭代
category:
- Matlab
mathjax: true
---

$$x_{i+1}=x_i-\frac{f(x_i)}{f'(x_i)}$$

```matlab
format long
syms x y dy;
y=exp(x)-x-2;
dy=diff(y,x);
x=1;
lastx=x-1;
while (lastx~=x)
    lastx=x;
    x=x-eval(y)/eval(dy);
    fprintf('%.16f',x);
    input('','s');
end
```
