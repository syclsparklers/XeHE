clc; close all; clear;
%% NTT DATA
load A1_data.mat;

%% COMPUTE

[gflops_ntt_local_simd_8_8, ~] = compute_gflops_simd(perf_ntt_local_simd_8_8);
[gflops_ntt_local_radix_8_inline, op_density_r8_inline] = compute_gflops_radix_8(perf_ntt_local_radix_8_inline);
[gflops_ntt_local_radix_8, op_density_r8] = compute_gflops_radix_8(perf_ntt_local_radix_8);

[gflops_ntt_naive_no_inline, ~] = compute_gflops_naive(perf_ntt_naive_no_inline_1024);
[gflops_ntt_naive_no_inline_1024, op_density_naive] = compute_gflops_naive(perf_ntt_naive_no_inline_1024);

acc_ntt_local_simd_8_8 = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_simd_8_8;
acc_ntt_local_radix_8 = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_radix_8;
acc_ntt_local_radix_8_inline = perf_ntt_naive_no_inline_1024 ./ perf_ntt_local_radix_8_inline;

PEAK_PERF = 360.525;

%% LAST PLOT

markers = ['p', 'o', '*', 'x', '+'];
colors = ['b', 'k', 'c', 'm', 'r'];

inline_bar_data = zeros(11, 4);
inline_bar_perf = zeros(11, 4);
simd_i = [2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4];
simd_j = [7, 8, 9, 7, 8, 9, 7, 8, 9, 10, 11];
for i = 1 : 11
    naive_data = perf_ntt_naive_no_inline_1024( simd_i(i), simd_j(i));
    no_inline_data = perf_ntt_local_radix_8( simd_i(i), simd_j(i));
    inline_data = perf_ntt_local_radix_8_inline( simd_i(i), simd_j(i));
    simd_data = perf_ntt_local_simd_8_8( simd_i(i), simd_j(i));
    inline_bar_data(i, 1) = 1;
    inline_bar_data(i, 2) = naive_data/ simd_data;
    inline_bar_data(i, 3) = naive_data/ no_inline_data;
    inline_bar_data(i, 4) = naive_data/ inline_data;
    
    inline_bar_perf(i, 1) = gflops_ntt_naive_no_inline_1024( simd_i(i), simd_j(i));
    inline_bar_perf(i, 2) = gflops_ntt_local_simd_8_8( simd_i(i), simd_j(i));
    inline_bar_perf(i, 3) = gflops_ntt_local_radix_8( simd_i(i), simd_j(i));
    inline_bar_perf(i, 4) = gflops_ntt_local_radix_8_inline( simd_i(i), simd_j(i));
    
end
figure
X = categorical({'8K, 64', '8K, 128', '8K, 256', '16K, 64', '16K, 128', '16K, 256', '32K, 64', '32K, 128', '32K, 256', '32K, 512', '32K, 1024'});
X = reordercats(X,{'8K, 64', '8K, 128', '8K, 256', '16K, 64', '16K, 128', '16K, 256', '32K, 64', '32K, 128', '32K, 256', '32K, 512', '32K, 1024'});
h = bar(X, inline_bar_data);
ylabel('Speedup','FontSize',14, 'FontWeight','bold')
%set(h(3),'FaceColor','[0.9290 0.6940 0.1250]');
hold on
yyaxis right

x = 1:11;

y_naive = inline_bar_perf(:, 1) ./ PEAK_PERF * 100;
y_simd = inline_bar_perf(:, 2) ./ PEAK_PERF * 100;
y_no_inline = inline_bar_perf(:, 3) ./ PEAK_PERF * 100;
y_inline = inline_bar_perf(:, 4) ./ PEAK_PERF * 100;
y_naive = y_naive';
y_simd = y_simd';
y_no_inline = y_no_inline';
y_inline = y_inline';
ylim([0, 100])

ylabel('Efficiency (%)')

h = plot(x, y_naive, strcat('-',markers(1)), 'LineWidth', 2);
h.Color = [0 0.4470 0.7410];

h = plot(x, y_simd, strcat('-',markers(2)), 'LineWidth', 2);
h.Color = [0.8500 0.3250 0.0980];

h = plot(x, y_no_inline, strcat('-',markers(3)), 'LineWidth', 2);
h.Color = [0.9290 0.6940 0.1250];

h = plot(x, y_inline, strcat('-',markers(4)), 'LineWidth', 2);
h.Color = [0.4940 0.1840 0.5560];

scatter(x, y_naive, 100, [0 0.4470 0.7410], markers(1), 'filled');
scatter(x, y_simd, 50, [0.8500 0.3250 0.0980], markers(2));
scatter(x, y_no_inline, 50, 'k', markers(3));
scatter(x, y_inline, 50, [0.4940 0.1840 0.5560], markers(4));

legend('naive', 'SIMD(8,8)', 'opt-NTT', 'opt-NTT+asm', '', '', '', '', 'Location', 'Best','FontSize',14)

set(gca,'FontSize',14, 'FontWeight','bold')
