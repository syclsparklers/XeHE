%%

clear; close all; clc;

%%

x = linspace(0,10);

% memory bandwidth & slope
y = x .* 642.54;

% peak performance on the B1 device

peak_int32_mad = repmat(5100*1.15,1,length(x));
peak_int64_mad_ideal = repmat(5100*1.15/2,1,length(x));
peak_int64_mad = repmat(372*1.15,1,length(x));

box on; hold on;

sz = 100;

% scatter plot

scatter(8.96484375, 2283.73135943060, sz, 'o', 'filled')
scatter(8.96484375, 1456.99041, sz, 'o', 'filled')
scatter(8.69, 994, sz, 'o', 'filled')
scatter(5.62, 359.21, sz, 'o', 'filled')
scatter(1.5, 298.47, sz, 'o', 'filled')

% fine-tune with dotted lines

one_lin = linspace(1.5, 2.5);
one_lin = one_lin ./ one_lin;
x_naive = linspace(0,1.5);
y_naive = 298.47 .* one_lin;

x_ele = 1.5;
x_ver = repmat(x_ele, 1, 100);
y_ver = linspace(0, 298.47);
h = plot(x_naive, y_naive, '--', 'LineWidth', 2);
h.Color = [0.4660 0.6740 0.1880];
h = plot(x_ver, y_ver, '--', 'LineWidth', 2);
h.Color = [0.4660 0.6740 0.1880];


one_lin = one_lin ./ one_lin;
x_naive = linspace(0,5.62);
y_naive = 359.21 .* one_lin;
x_ele = 5.62;
x_ver = repmat(x_ele, 1, 100);
y_ver = linspace(0, 359.21);
h = plot(x_naive, y_naive, '--', 'LineWidth', 2);
h.Color = [0.4940 0.1840 0.5560];
h = plot(x_ver, y_ver, '--', 'LineWidth', 2);
h.Color = [0.4940 0.1840 0.5560];


one_lin = one_lin ./ one_lin;
x_naive = linspace(0,8.69);
y_naive = 994 .* one_lin;
x_ele = 8.69;
x_ver = repmat(x_ele, 1, 100);
y_ver = linspace(0, 994);
h = plot(x_naive, y_naive, '--', 'LineWidth', 2);
h.Color = [0.9290 0.6940 0.1250];
h = plot(x_ver, y_ver, '--', 'LineWidth', 2);
h.Color = [0.9290 0.6940 0.1250];

 
one_lin = one_lin ./ one_lin;
x_naive = linspace(0,8.96484375);
y_naive = 1456.99041 .* one_lin;
x_ele = 8.96484375;
x_ver = repmat(x_ele, 1, 100);
y_ver = linspace(0, 1456.99041);
h = plot(x_naive, y_naive, '--', 'LineWidth', 2);
h.Color = [0.8500 0.3250 0.0980];
h = plot(x_ver, y_ver, '--', 'LineWidth', 2);
h.Color = [0.8500 0.3250 0.0980];

one_lin = one_lin ./ one_lin;
x_naive = linspace(0,8.96484375);
y_naive = 2283.73135943060 .* one_lin;
x_ele = 8.96484375;
x_ver = repmat(x_ele, 1, 100);
y_ver = linspace(1456.99041, 2283.73135943060);
h = plot(x_naive, y_naive, '--', 'LineWidth', 2);
h.Color = [0 0.4470 0.7410];
h = plot(x_ver, y_ver, '--', 'LineWidth', 2);
h.Color = [0 0.4470 0.7410];

text(2,3300,'int64 peak', 'Color','green','FontSize',14)
text(6,6300,'int32 peak', 'Color','blue','FontSize',14)

ht = text(5,3000,'global memory bandwidth', 'Color','black','FontSize',14);
set(ht,'Rotation',34.5)
xlabel('Operational Density (int64 op/byte)','FontSize',14, 'FontWeight','bold')
ylabel('Normalized Performance (GOPS)','FontSize',14, 'FontWeight','bold')

line(x,y, 'Color','black');
%line(x,peak_int32_add, 'Color','red')
line(x,peak_int32_mad, 'Color','blue')
%line(x,peak_int64_mad, 'Color','black')
line(x,peak_int64_mad_ideal, 'Color','green')
legend('SLM+radix-8+dual-tile','SLM+radix-8','SLM+radix-4','SLM+SIMD radix-2', 'naive radix-2','','','','Location', 'Best','FontSize',14)

h = gca;

yticks(0:1000:14000)
yticklabels({'0', '1','2','3','4','5','6','7','8','9','10','11','12','13','14'})
h.YAxis.FontWeight = 'bold';
h.XAxis.FontWeight = 'bold';
h.YAxis.FontSize = 14;
h.XAxis.FontSize = 14;

hold off;