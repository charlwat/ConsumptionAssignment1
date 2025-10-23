function generate_plots(a_grid, y_grid, V, policy_a, policy_c, ...
                       y_sim, a_sim, c_sim, s_sim, exp_y_sim, epsilon_sim, Delta_c_sim, results)
% GENERATE_PLOTS Generate all required plots for the VFI assignment
% Inputs: All the data needed for plotting

n_y = length(y_grid);
T_sim = length(y_sim);

%% Part (b): Graph Value Function and Policy Functions
figure('Position', [100, 100, 1200, 800]);

% Plot value function for all income states
subplot(2, 2, 1);
hold on;
colors = lines(n_y);
for i_y = 1:n_y
    plot(a_grid, V(:, i_y), 'Color', colors(i_y, :), 'LineWidth', 2, ...
         'DisplayName', sprintf('y = %.3f', y_grid(i_y)));
end
xlabel('Assets (a)');
ylabel('Value Function V(a,y)');
title('(b) Value Function for All Income States');
legend('show', 'Location', 'southeast');
grid on;

% Plot asset policy function
subplot(2, 2, 2);
hold on;
for i_y = 1:n_y
    plot(a_grid, policy_a(:, i_y), 'Color', colors(i_y, :), 'LineWidth', 2, ...
         'DisplayName', sprintf('y = %.3f', y_grid(i_y)));
end
plot(a_grid, a_grid, 'k--', 'LineWidth', 1, 'DisplayName', '45° line');
xlabel('Current Assets (a)');
ylabel("Next Period Assets (a')");
title('Asset Policy Function');
legend('show', 'Location', 'southeast');
grid on;

% Plot consumption policy function
subplot(2, 2, 3);
hold on;
for i_y = 1:n_y
    plot(a_grid, policy_c(:, i_y), 'Color', colors(i_y, :), 'LineWidth', 2, ...
         'DisplayName', sprintf('y = %.3f', y_grid(i_y)));
end
xlabel('Assets (a)');
ylabel('Consumption c(a,y)');
title('Consumption Policy Function');
legend('show', 'Location', 'southeast');
grid on;

%% Part (c): Tile Plot of Simulated Series
time = 1:T_sim;
subplot(2, 2, 4);
tiledlayout(3, 1, 'TileSpacing', 'compact');

nexttile;
plot(time, exp_y_sim, 'b-', 'LineWidth', 1);
ylabel('exp(y)');
title('(c) Simulated Income');
grid on;

nexttile;
plot(time(1:end-1), a_sim(2:end), 'r-', 'LineWidth', 1);
ylabel("a'");
title('Next Period Assets');
grid on;

nexttile;
plot(time, c_sim, 'g-', 'LineWidth', 1);
ylabel('c');
xlabel('Time Period');
title('Consumption');
grid on;

%% Additional Analysis Figure
figure('Position', [200, 200, 1000, 800]);

% Consumption distribution
subplot(2,2,1);
histogram(c_sim, 30, 'FaceColor', 'blue', 'FaceAlpha', 0.7);
xlabel('Consumption (c)');
ylabel('Frequency');
title('Consumption Distribution');
grid on;

% Consumption vs Income
subplot(2,2,2);
if all(~isnan(exp_y_sim)) && all(~isnan(c_sim))
    scatter(exp_y_sim, c_sim, 20, 'filled');
    xlabel('Income exp(y)');
    ylabel('Consumption (c)');
    title('Consumption vs Income');
    grid on;
else
    text(0.5, 0.5, 'Data not available', 'HorizontalAlignment', 'center');
    title('Consumption vs Income (Data Unavailable)');
end

% PIH: Δc vs Income Shocks
subplot(2,2,3);
if isfield(results, 'pih_correlation') && ~isnan(results.pih_correlation)
    % Calculate theoretical PIH predictions
    PIH_multiplier = results.mpc_permanent;
    PIH_Delta_c_theoretical = PIH_multiplier * epsilon_sim(2:end);
    actual_Delta_c = Delta_c_sim(2:end);
    
    % Ensure proper vector lengths
    plot_length = min(length(epsilon_sim(2:end)), length(actual_Delta_c));
    plot_length = min(plot_length, length(PIH_Delta_c_theoretical));
    
    scatter(epsilon_sim(2:2+plot_length-1), actual_Delta_c(1:plot_length), 20, 'filled');
    hold on;
    plot(epsilon_sim(2:2+plot_length-1), PIH_Delta_c_theoretical(1:plot_length), 'r-', 'LineWidth', 1);
    xlabel('Income Shock (ε)');
    ylabel('Consumption Change (Δc)');
    title('PIH: Δc vs Income Shocks');
    legend('Actual', 'PIH Theoretical', 'Location', 'northwest');
    grid on;
else
    text(0.5, 0.5, 'PIH comparison data not available', 'HorizontalAlignment', 'center');
    title('PIH: Δc vs Income Shocks (Data Unavailable)');
end

% Savings vs Consumption
subplot(2,2,4);
if length(c_sim) > 1 && length(a_sim) > 1
    plot_length = min(length(c_sim(1:end-1)), length(a_sim(2:end)));
    scatter(c_sim(1:plot_length), a_sim(2:plot_length+1), 20, 'filled');
    xlabel('Consumption (c_t)');
    ylabel("Next Period Assets (a_{t+1})");
    title('Savings vs Consumption');
    grid on;
else
    text(0.5, 0.5, 'Data not available', 'HorizontalAlignment', 'center');
    title('Savings vs Consumption (Data Unavailable)');
end

%% Rainy Day Analysis Plot
figure('Position', [300, 300, 800, 600]);

% Savings vs Income (Rainy Day analysis)
subplot(2,2,1);
if length(exp_y_sim) > 1 && length(s_sim) > 1
    min_len = min(length(exp_y_sim), length(s_sim));
    scatter(exp_y_sim(1:min_len-1), s_sim(1:min_len-1), 20, 'filled');
    xlabel('Income exp(y)');
    ylabel('Savings (s)');
    title('Savings vs Income (Rainy Day)');
    grid on;
end

% Consumption growth distribution
subplot(2,2,2);
if length(Delta_c_sim) > 10
    histogram(Delta_c_sim, 30, 'FaceColor', 'green', 'FaceAlpha', 0.7);
    xlabel('Consumption Change (Δc)');
    ylabel('Frequency');
    title('Consumption Changes Distribution');
    grid on;
end

% Assets over time
subplot(2,2,3);
plot(time, a_sim, 'm-', 'LineWidth', 1);
xlabel('Time');
ylabel('Assets (a)');
title('Asset Evolution');
grid on;

% Income vs Consumption scatter with regression line
subplot(2,2,4);
if all(~isnan(exp_y_sim)) && all(~isnan(c_sim))
    scatter(exp_y_sim, c_sim, 20, 'filled');
    hold on;
    % Add regression line
    p = polyfit(exp_y_sim, c_sim, 1);
    y_fit = polyval(p, [min(exp_y_sim), max(exp_y_sim)]);
    plot([min(exp_y_sim), max(exp_y_sim)], y_fit, 'r-', 'LineWidth', 2);
    xlabel('Income exp(y)');
    ylabel('Consumption (c)');
    title(sprintf('Consumption vs Income (slope: %.3f)', p(1)));
    legend('Data', 'Regression', 'Location', 'northwest');
    grid on;
end

fprintf('All plots generated successfully.\n');
end