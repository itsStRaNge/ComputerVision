function [JL, JR, HL, HR] = rectification(IL, IR, R, T, K)
%% create projection matrix
pi_matrix = [1 0 0 0; 0 1 0 0; 0 0 1 0];

M = [R, (T)'; 0, 0, 0, 1];
PL = K * pi_matrix * eye(4,4);
PR = K * pi_matrix * M;

%% get rectification
[JL, JR, HL, HR] = cv_rectify(IL, PL, IR, PR);

end

