function [gflops, op_density] = compute_gflops_simd(t)
    gflops = zeros(size(t, 1), size(t, 2));
    op_density = zeros(size(t, 1), size(t, 2));
    for i = 1 : size(t, 1)
        n = 2^(11 + i);
        for j = 1 : size(t, 2)
            rns = 2^(j - 1);
            curr_t = t(i, j);
            total_ops = (log(n) / log(2)) * n / 2 * 48 * rns;
            extra_gap = 0;
            if n == 4096 
                extra_gap = 0;
            else
                extra_gap = log2(n) - log2(8192);
            end
            total_mem_access = (  n * 8 * 2 * (2 + extra_gap) * rns);
            
            curr_gflops = total_ops * 1e-3 / curr_t;
            gflops(i, j) = curr_gflops;
            op_density(i, j) = total_ops / total_mem_access;
        end
    end
end