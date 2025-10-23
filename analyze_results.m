function results = analyze_results(c_sim, exp_y_sim, epsilon_sim, Delta_c_sim, r, rho)
% ANALYZE_RESULTS Calculate and display simulation results
% Inputs: simulation outputs
% Output: results structure

results = struct();

% Basic statistics
results.std_c = std(c_sim, 'omitnan');
results.std_y = std(exp_y_sim, 'omitnan');
results.std_epsilon = std(epsilon_sim, 'omitnan');
results.mean_c = mean(c_sim, 'omitnan');
results.mean_y = mean(exp_y_sim, 'omitnan');
results.smoothing_ratio = results.std_c / results.std_y;

% PIH analysis
if length(epsilon_sim) > 1 && length(Delta_c_sim) > 1
    PIH_Delta_c_theoretical = (r/(1+r-rho)) * epsilon_sim(2:end);
    actual_Delta_c = Delta_c_sim(2:end);
    
    min_length = min(length(PIH_Delta_c_theoretical), length(actual_Delta_c));
    PIH_Delta_c_theoretical = PIH_Delta_c_theoretical(1:min_length);
    actual_Delta_c = actual_Delta_c(1:min_length);
    
    valid_idx = ~isnan(PIH_Delta_c_theoretical) & ~isinf(PIH_Delta_c_theoretical) & ...
                ~isnan(actual_Delta_c) & ~isinf(actual_Delta_c);
    
    if sum(valid_idx) > 10
        results.pih_correlation = corr(actual_Delta_c(valid_idx), PIH_Delta_c_theoretical(valid_idx));
    else
        results.pih_correlation = NaN;
    end
else
    results.pih_correlation = NaN;
end

results.mpc_transitory = r/(1+r);
results.mpc_permanent = r/(1+r-rho);

% Display results
fprintf('\n=== SIMULATION RESULTS ===\n');
fprintf('Standard deviation of consumption (σ_c): %.4f\n', results.std_c);
fprintf('Standard deviation of income (σ_y): %.4f\n', results.std_y);
fprintf('Consumption smoothing ratio (σ_c/σ_y): %.4f\n', results.smoothing_ratio);
fprintf('Mean consumption: %.4f\n', results.mean_c);
fprintf('Mean income (exp(y)): %.4f\n', results.mean_y);

fprintf('\n=== PIH THEORETICAL COMPARISON ===\n');
fprintf('Correlation between actual Δc and PIH predicted Δc: %.4f\n', results.pih_correlation);
fprintf('Theoretical MPC from transitory shock: %.4f\n', results.mpc_transitory);
fprintf('Theoretical MPC from permanent shock: %.4f\n', results.mpc_permanent);
end