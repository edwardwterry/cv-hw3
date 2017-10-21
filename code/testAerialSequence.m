clc
clear
close all

load('../data/aerialseq.mat');
frames = im2double(frames);

It = frames(:,:,1);
It1 = frames(:,:,2);

M = LucasKanadeAffine(It,It1);