function [gflops, op_density] = compute_gflops_naive(t)
    gflops = zeros(size(t, 1), size(t, 2));
    op_density = zeros(size(t, 1), size(t, 2));
    for i = 1 : size(t, 1)
        n = 2^(11 + i);
        for j = 1 : size(t, 2)
            rns = 2^(j - 1);
            curr_t = t(i, j);
            total_ops = (log(n) / log(2)) * n / 2 * 48 * rns;
            curr_gflops = total_ops * 1e-3 / curr_t;
            gflops(i, j) = curr_gflops;
            op_density(i, j) = total_ops / (n * 8 * 2 * (log(n) / log(2)) * rns);
        end
    end
end