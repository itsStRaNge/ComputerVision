function P = projection(K,R,T)
pi = [1 0 0 0;
      0 1 0 0;
      0 0 1 0];
G = [R , T';
     0, 0, 0, 1];
P = K * pi * G;
end

