clc
close all
clear

load('../data/sylvbases.mat')
load('../data/sylvseq.mat')

frames = im2double(frames);

It = frames(:,:,1);
It1 = frames(:,:,2);

rect = [102, 62, 156, 108]';
[dp_x,dp_y] = LucasKanadeBasis(It, It1, rect, bases);
