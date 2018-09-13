function sum = D(h1,h2)
  sum = 0;
  for k=1:256
    sum = sum + (h1(k) - h2(k))^2;
  endfor
endfunction