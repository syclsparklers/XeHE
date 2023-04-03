clc; close all; clear;
%% NTT DATA
load B0_data.mat;


%% COMPUTE

[gflops_ntt_local_simd_8_8, ~] = compute_gflops_simd(perf_ntt_local_simd_8_8);
[gflops_ntt_local_simd_16_8, ~] = compute_gflops_simd(perf_ntt_local_simd_16_8);
[gflops_ntt_local_simd_32_8, op_density_simd] = compute_gflops_simd(perf_ntt_local_simd_32_8);
[gflops_ntt_local_radix_8_inline, op_density_r8_inline] = compute_gflops_radix_8(perf_ntt_local_radix_8_inline);

[gflops_ntt_local_radix_8_dual, ~] = compute_gflops_radix_8(perf_ntt_local_radix_8_dual);
[gflops_ntt_local_radix_8_ocl, ~] = compute_gflops_radix_8(perf_ntt_local_radix_8_ocl);
[gflops_ntt_local_radix_8, op_density_r8] = compute_gflops_radix_8(perf_ntt_local_radix_8);

[gflops_ntt_local_radix_16, op_density_r16] = compute_gflops_radix_16(perf_ntt_local_radix_16);
[gflops_ntt_local_radix_4, op_density_r4] = compute_gflops_radix_4(perf_ntt_local_radix_4);
[gflops_ntt_naive_no_inline, ~] = compute_gflops_naive(perf_ntt_naive_no_inline_1024);
[gflops_ntt_naive_no_inline_1024, op_density_naive] = compute_gflops_naive(perf_ntt_naive_no_inline_1024);

acc_ntt_local_simd_8_8 = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_simd_8_8;
acc_ntt_local_simd_16_8 = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_simd_16_8;
acc_ntt_local_simd_32_8 = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_simd_32_8;
acc_ntt_local_radix_4 = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_radix_4;
acc_ntt_local_radix_8 = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_radix_8;
acc_ntt_local_radix_8_inline = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_radix_8_inline;
acc_ntt_local_radix_16 = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_radix_16;

PEAK_PERF = 2932; % theoretical peak perf = 2932 GOPS on this device.

%% PLOT DATA


% ************ Figure 1 ********* %
simd_bar_data = zeros(8, 4);
simd_bar_data(:, 1) = 1;
simd_i = [1, 2, 3, 4, 4, 4, 4, 4];
simd_j = [4, 4, 4, 4, 5, 9, 10, 11];
for i = 1 : 8
    simd_bar_data(i, 2) = acc_ntt_local_simd_8_8( simd_i(i), simd_j(i));
    simd_bar_data(i, 3) = acc_ntt_local_simd_16_8( simd_i(i), simd_j(i));
    simd_bar_data(i, 4) = acc_ntt_local_simd_32_8( simd_i(i), simd_j(i));
end
figure
X = categorical({'4K, 8','8K, 8','16K, 8','32K, 8','32K, 16','32K, 256','32K, 512','32K, 1024'});
X = reordercats(X,{'4K, 8','8K, 8','16K, 8','32K, 8','32K, 16','32K, 256','32K, 512','32K, 1024'});
h = bar(X, simd_bar_data);
ylim([0, 2])
set(h, {'DisplayName'}, {'naive', 'SIMD(8,8)','SIMD(16,8)','SIMD(32,8)'}')
ylabel('Speedup over Baseline','FontSize',14, 'FontWeight','bold')
legend('Location', 'Best','FontSize',14) 
set(gca,'FontSize',14, 'FontWeight','bold')

% ************ Figure 2 ********* %
markers = ['p', 'o', '*', 'x', '+'];
colors = ['b', 'k', 'c', 'm', 'r'];

simd_gflops = zeros(4, 11);
simd_gflops_x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
simd_gflops_x_name = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];
simd_gflops(1, :) = gflops_ntt_naive_no_inline(4, :);
simd_gflops(2, :) = gflops_ntt_local_simd_8_8(4, :);
simd_gflops(3, :) = gflops_ntt_local_simd_16_8(4, :);
simd_gflops(4, :) = gflops_ntt_local_simd_32_8(4, :);

simd_gflops = simd_gflops ./ PEAK_PERF * 100;

figure
hold on
for tt = 1 : 4
    plot(simd_gflops_x, simd_gflops(tt, :), strcat('-',markers(tt), colors(tt)), 'LineWidth', 2);
end
hold off
xlim([1, 11])
xticks(1:11);
box on
xticklabels({'1','2','4','8','16','32','64','128','256','512','1024'})
legend('naive', 'SIMD(8,8)','SIMD(16,8)','SIMD(32,8)', 'Location', 'Best', 'FontSize',14, 'FontWeight','bold')
xlabel('Instance Number','FontSize',14, 'FontWeight','bold')
ylabel('Efficiency (%)','FontSize',14, 'FontWeight','bold')
set(gca,'FontSize',14, 'FontWeight','bold')


% ************ Figure 3 ********* %

radix_bar_data = zeros(8, 4);
radix_bar_data(:, 1) = 1;
simd_i = [1, 2, 3, 4, 4, 4, 4, 4];
simd_j = [4, 4, 4, 4, 5, 9, 10, 11];

for i = 1 : 8
    radix_bar_data(i, 2) = acc_ntt_local_radix_4( simd_i(i), simd_j(i));
    radix_bar_data(i, 3) = acc_ntt_local_radix_8( simd_i(i), simd_j(i));
    radix_bar_data(i, 4) = acc_ntt_local_radix_16( simd_i(i), simd_j(i));
end
figure
X = categorical({'4K, 8','8K, 8','16K, 8','32K, 8','32K, 16','32K, 256','32K, 512','32K, 1024'});
X = reordercats(X,{'4K, 8','8K, 8','16K, 8','32K, 8','32K, 16','32K, 256','32K, 512','32K, 1024'});
h = bar(X, radix_bar_data);
set(h, {'DisplayName'}, {'naive', 'local-radix-4','local-radix-8','local-radix-16'}')
ylabel('Speedup over Baseline','FontSize',14, 'FontWeight','bold')
legend('Location', 'Best','FontSize',14) 
set(gca,'FontSize',14, 'FontWeight','bold')

% ************ Figure 4 ********* %
local_gflops = zeros(4, 11);
local_gflops_x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
local_gflops(1, :) = gflops_ntt_naive_no_inline_1024(4, :);
local_gflops(2, :) = gflops_ntt_local_radix_4(4, :);
local_gflops(3, :) = gflops_ntt_local_radix_8(4, :);
local_gflops(4, :) = gflops_ntt_local_radix_16(4, :);


local_gflops = local_gflops ./ PEAK_PERF * 100;

figure
hold on
for tt = 1 : 4
    plot(local_gflops_x, local_gflops(tt, :), strcat('-',markers(tt), colors(tt)), 'LineWidth', 2);
end
hold off
xlim([1, 11])
xticks(1:11);
box on
xticklabels({'1','2','4','8','16','32','64','128','256','512','1024'})
legend('naive', 'local-radix-4','local-radix-8','local-radix-16', 'Location', 'Best', 'FontSize',14, 'FontWeight','bold')
xlabel('Instance Number','FontSize',14, 'FontWeight','bold')
ylabel('Efficiency (%)','FontSize',14, 'FontWeight','bold')
set(gca,'FontSize',14, 'FontWeight','bold')

% ************ Figure 5 ********* %
inline_bar_data_5 = zeros(11, 2);
inline_bar_perf_5 = zeros(11, 2);
simd_i = [2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4];
simd_j = [7, 8, 9, 7, 8, 9, 7, 8, 9, 10, 11];
for i = 1 : 11
    no_inline_data = perf_ntt_local_radix_8( simd_i(i), simd_j(i));
    inline_data = perf_ntt_local_radix_8_inline( simd_i(i), simd_j(i));
    inline_bar_data_5(i, 1) = 1;
    inline_bar_data_5(i, 2) = no_inline_data/ inline_data;
    inline_bar_perf_5(i, 1) = gflops_ntt_local_radix_8( simd_i(i), simd_j(i));
    inline_bar_perf_5(i, 2) = gflops_ntt_local_radix_8_inline( simd_i(i), simd_j(i));
end
figure
X = categorical({'8K, 64', '8K, 128', '8K, 256', '16K, 64', '16K, 128', '16K, 256', '32K, 64', '32K, 128', '32K, 256', '32K, 512', '32K, 1024'});
X = reordercats(X,{'8K, 64', '8K, 128', '8K, 256', '16K, 64', '16K, 128', '16K, 256', '32K, 64', '32K, 128', '32K, 256', '32K, 512', '32K, 1024'});
h = bar(X, inline_bar_data_5);
ylabel('Speedup','FontSize',14, 'FontWeight','bold')

hold on
yyaxis right

x = 1:11;
y_no_inline = inline_bar_perf_5(:, 1) ./ PEAK_PERF * 100;
y_inline = inline_bar_perf_5(:, 2) ./ PEAK_PERF * 100;
y_no_inline = y_no_inline';
y_inline = y_inline';
ylim([0, 100])

ylabel('Efficiency (%)')
markers = ['p', 'o', '*', 'x', '+'];
colors = ['[0 0.4470 0.7410]', '[0.8500 0.3250 0.0980]', 'c', 'm', 'r'];
h = plot(x, y_no_inline, strcat('-',markers(1)), 'LineWidth', 2);
h.Color = [0 0.4470 0.7410];
h = plot(x, y_inline, strcat('-',markers(2)), 'LineWidth', 2);
h.Color = [0.8500 0.3250 0.0980];

scatter(x, y_no_inline, 100, 'k', markers(1), 'filled');
scatter(x, y_inline, 50, 'k', markers(2));

legend('w/o asm', 'w asm', '', '', 'Location', 'Best','FontSize',14)

set(gca,'FontSize',14, 'FontWeight','bold')


%% LAST PLOT

inline_bar_data = zeros(11, 3);
inline_bar_perf = zeros(11, 3);
simd_i = [2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4];
simd_j = [7, 8, 9, 7, 8, 9, 7, 8, 9, 10, 11];
for i = 1 : 11
    naive_data = perf_ntt_naive_no_inline_1024( simd_i(i), simd_j(i));
    inline_data = perf_ntt_local_radix_8_inline( simd_i(i), simd_j(i));
    inline_data_dual = perf_ntt_local_radix_8_dual( simd_i(i), simd_j(i));
    inline_bar_data(i, 1) = 1;
    inline_bar_data(i, 2) = naive_data/ inline_data;
    inline_bar_data(i, 3) = naive_data/ inline_data_dual;
    inline_bar_perf(i, 1) = gflops_ntt_naive_no_inline_1024( simd_i(i), simd_j(i));
    inline_bar_perf(i, 2) = gflops_ntt_local_radix_8_inline( simd_i(i), simd_j(i));
    inline_bar_perf(i, 3) = gflops_ntt_local_radix_8_dual( simd_i(i), simd_j(i));
end
figure

X = categorical({'8K, 64', '8K, 128', '8K, 256', '16K, 64', '16K, 128', '16K, 256', '32K, 64', '32K, 128', '32K, 256', '32K, 512', '32K, 1024'});
X = reordercats(X,{'8K, 64', '8K, 128', '8K, 256', '16K, 64', '16K, 128', '16K, 256', '32K, 64', '32K, 128', '32K, 256', '32K, 512', '32K, 1024'});
ylim([0, 10.5])

h = bar(X, inline_bar_data);
ylabel('Speedup','FontSize',14, 'FontWeight','bold')
%set(h(3),'FaceColor','[0.9290 0.6940 0.1250]');
hold on
yyaxis right

x = 1:11;

y_naive = inline_bar_perf(:, 1) ./ PEAK_PERF * 100;
y_inline = inline_bar_perf(:, 2) ./ PEAK_PERF * 100;
y_dual = inline_bar_perf(:, 3) ./ PEAK_PERF * 100;
y_naive = y_naive';
y_inline = y_inline';
y_dual = y_dual';
ylim([0, 100])

ylabel('Efficiency (%)')

h = plot(x, y_naive, strcat('-',markers(1)), 'LineWidth', 2);
h.Color = [0 0.4470 0.7410];
h = plot(x, y_inline, strcat('-',markers(2)), 'LineWidth', 2);
h.Color = [0.8500 0.3250 0.0980];
h = plot(x, y_dual, strcat('-',markers(3)), 'LineWidth', 2);
h.Color = [0.9290 0.6940 0.1250];

scatter(x, y_naive, 100, 'k', markers(1), 'filled');
scatter(x, y_inline, 50, 'k', markers(2));
scatter(x, y_dual, 50, 'k', markers(3));

legend('naive', 'optimized 1-tile', 'optimized 2-tile', '', '', '', 'Location', 'Best','FontSize',14)

set(gca,'FontSize',14, 'FontWeight','bold')
