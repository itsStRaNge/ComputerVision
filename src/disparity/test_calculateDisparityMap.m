load('rectificated.mat', 'JL');
load('rectificated.mat', 'JR');

dispMap=calculateDisparityMap(JL,JR,'block',800);