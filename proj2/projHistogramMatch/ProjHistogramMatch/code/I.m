function T = I(dif,img,h1)
  flag = 1;
  #while flag == 1  
    #valores dos pontos p1, p2, p3
    x1 = 1;
    y1 = 1; 
    
    x2 = 60;
    y2 = 60;

    x3 = 256;
    y3 = 256;
    
    res = sis(x1,y1,x2,y2,x3,y3);
    
    #Preenchendo o vetor T com valores obtidos a partir da funçao
    for i = 0:255
      T(i+1) = res(1)*i^2 + res(2)*i + res(3);
    endfor
    
    #Definindo canais de saida
    saida = zeros(size(img,1), size(img,2), "uint8");
    
    # Laços de iteraçao para gerar uma nova imagem
    for l=1:size(img,1)
      for c=1:size(img,2)
        valOrig = uint8(img(l,c));
        novoVal = T(valOrig+1);
        saida(l,c) = novoVal;
      endfor
    endfor
    
    #Obtendo histogram da nova saida
    h2 = imhist(saida);
    newDifR = D(h1,h2);
    
    if newDifR < dif
      flag = 1;
      newDifR
    else
      flag = 0;
    endif
  #endwhile

endfunction