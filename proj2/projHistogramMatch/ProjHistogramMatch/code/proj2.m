pkg load image;

img1 = imread('../data/test1.png'); #carregando patch da img1
img2 = imread('../data/test2.png'); #carregando patch da img2

############ Separando canal das imagens ############
i = 1;
while i<4
#Separando a img1 em 3 canais (RGB)
img1One_C = img1(:,:,i);

#Separando a img1 em 3 canais (RGB)
img2One_C = img2(:,:,i);

############ Fim ############



############ Calculando o histograma para cada canal ############
#Obtendo histogramas dos canais da img1
h1 = imhist(img1One_C);

#Obtendo histogramas dos canais da img2
h2 = imhist(img2One_C);
############ Fim ############

#Plotagem dos graficos de histograma das duas imagens
#plot(h1, c='r',h2, c='b');
#plot(h2R, c='r',h2G, c='g', h2B, c='b');


#Calculo de diferença de histograma
dif = D(h1,h2);

%difR
%difG
%difB

### Trecho iterativo  ####
#Definindo um vetor T que sera o map para gerar uma nova imagem
T = zeros(1,256, "uint16");



flag = 1;
  #while flag == 1  
    #valores dos pontos p1, p2, p3
    x1 = 1;
    y1 = 1; 
    
    x2 = 60;
    y2 = 60;

    x3 = 256;
    y3 = 120;
    
    res = sis(x1,y1,x2,y2,x3,y3);
    
    #Preenchendo o vetor T com valores obtidos a partir da funçao
    for i = 0:255
      T(i+1) = res(1)*i^2 + res(2)*i + res(3);
    endfor
    
    plot (0:255, T);
    
    #Definindo canais de saida
    saida = zeros(size(img1,1), size(img1,2), "uint8");
    
    # Laços de iteraçao para gerar uma nova imagem
    for l=1:size(img1,1)
      for c=1:size(img1,2)
        valOrig = uint8(img1(l,c));
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

endwhile

#Aplicar o novo mapa obtido na imagem a ser corrigida

imagem = imread("../data/img2.png");
for d=1:size(imagem,3)
for l=1:size(imagem,1)
  for c=1:size(imagem,2)
      valOrig = uint8(imagem(l,c,d));
      novoVal = T(valOrig+1);
      saida(l,c,d) = novoVal;
  endfor
endfor
endfor

#salvar a imagem corrigida.
imwrite(saida, "../data/saida.jpg");