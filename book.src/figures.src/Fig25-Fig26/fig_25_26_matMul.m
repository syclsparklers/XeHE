clear; clc; close all;
load matMul.mat;

figure
bar(mydata_B1);

X = categorical({'baseline', 'mad\_mod', 'inline asm', 'mem cache'});
X = reordercats(X,{'baseline', 'mad\_mod', 'inline asm', 'mem cache'});
h = bar(X, mydata_B1);
%set(gca, 'YTick', [])
ylabel('Normalized Execution Time','FontSize',16, 'FontWeight','bold')
legend('matMul\_100x10x1', 'matMul\_10x9x8', 'Location', 'Best','FontSize',16) 
set(gca,'FontSize',16, 'FontWeight','bold')

figure

X = categorical({'baseline', 'mad\_mod', 'inline asm', 'mem cache'});
X = reordercats(X,{'baseline', 'mad\_mod', 'inline asm', 'mem cache'});
h = bar(X, mydata_A0);
%set(gca, 'YTick', [])
ylabel('Normalized Execution Time','FontSize',16, 'FontWeight','bold')
legend('matMul\_100x10x1', 'matMul\_10x9x8', 'Location', 'Best','FontSize',16) 
set(gca,'FontSize',16, 'FontWeight','bold')