clear; clc; close all;

load profiling_B0.mat

markers = ['p', 'o', '*', 'x', '+'];
colors = ['b', 'k', 'c', 'm', 'r'];

X = categorical({'MulLin', 'MulLinRes', 'SqrRelRescale', 'MulRelResModSwAdd',...
    'Rotate'});
X = reordercats(X,{'MulLin', 'MulLinRes', 'SqrRelRescale', 'MulRelResModSwAdd',...
    'Rotate'});

%% normalized plot

figure

h = bar(X, event_exe_time,'stacked');

ylabel('Normalized Execution Time')

hold on
yyaxis right

ylim([0, 1])

ylabel('Ratio of NTT Kernel Time')

plot(x, y, strcat('-',markers(1), colors(1)), 'LineWidth', 2)
plot(x, y_opt, strcat('-',markers(3), colors(3)), 'LineWidth', 2)

set(gca,'FontSize',16, 'FontWeight','bold')
set(gca,'ycolor','b') 

legend('NTT Time w/o opt', 'Other Time w/o opt', 'NTT Ratio w/o opt', 'NTT Ratio w. opt','FontSize',16)

hold off
