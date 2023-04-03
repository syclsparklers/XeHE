function [gflops, op_density] = compute_gflops_radix_8(t)
    gflops = zeros(size(t, 1), size(t, 2));
    op_density = zeros(size(t, 1), size(t, 2));
    for i = 1 : size(t, 1)
        n = 2^(11 + i);
        for j = 1 : size(t, 2)
            rns = 2^(j - 1);
            curr_t = t(i, j);
            if n == 4096
                total_ops = (log(4096) / log(8)) * 4096 / 8 * 459 * rns;
                curr_gflops = total_ops * 1e-3 / curr_t;
                gflops(i, j) = curr_gflops;
                op_density(i, j) = total_ops / (4096 * 8 * 2 * rns);
            end
            
            if n == 8192
                total_ops = ((log(4096) / log(8)) * 8192 / 8 * 459 + 8192/2*48) * rns;
                curr_gflops = total_ops * 1e-3 / curr_t;
                gflops(i, j) = curr_gflops;
                op_density(i, j) = total_ops / (8192 * 8 * 4 * rns);
            end
            
            if n == 16384
                total_ops = ((log(4096) / log(8)) * 16384 / 8 * 459 + 16384/4*159) * rns;
                curr_gflops = total_ops * 1e-3 / curr_t;
                gflops(i, j) = curr_gflops;
                op_density(i, j) = total_ops / (16384 * 8 * 4 * rns);
            end
            
            if n == 32768
                total_ops = ((log(4096) / log(8)) * 32768 / 8 * 459 + 32768/8*459) * rns;
                curr_gflops = total_ops * 1e-3 / curr_t;
                gflops(i, j) = curr_gflops;
                op_density(i, j) = total_ops / (32768 * 8 * 4 * rns);
            end
        end
    end
end