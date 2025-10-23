function [y_sim, a_sim, c_sim, s_sim, exp_y_sim, epsilon_sim, Delta_c_sim] = ...
         run_simulation(policy_a, policy_c, a_grid, y_grid, y_trans, rho, sigma, T_sim, T_burn)
% RUN_SIMULATION Run the model simulation
% Inputs:
%   policy_a, policy_c - policy functions
%   a_grid, y_grid - state grids
%   y_trans - income transition matrix
%   rho, sigma - income process parameters
%   T_sim, T_burn - simulation and burn-in periods

rng(42);  % Set seed for reproducibility
T_total = T_sim + T_burn;
n_a = length(a_grid);
n_y = length(y_grid);

% Calculate stationary distribution for initial condition
[V_eig, ~] = eig(y_trans');
stat_dist = V_eig(:,1) / sum(V_eig(:,1));

% Initialize arrays
y_sim = zeros(T_total, 1);
a_sim = zeros(T_total, 1);
c_sim = zeros(T_total, 1);
s_sim = zeros(T_total, 1);
epsilon_sim = sigma * randn(T_total, 1);

% Initial conditions
[~, y0_idx] = max(stat_dist);
y_sim(1) = y_grid(y0_idx);
a_sim(1) = a_grid(1);

% In run_simulation.m - FIX THE INDEXING:
for t = 1:T_total-1
    % Find current state indices
    [~, i_a] = min(abs(a_grid - a_sim(t)));
    [~, i_y] = min(abs(y_grid - y_sim(t)));
    
    % ENSURE indices are within bounds
    i_a = max(1, min(i_a, n_a));
    i_y = max(1, min(i_y, n_y));
    
    % Use policy functions with correct indexing
    a_sim(t+1) = policy_a(i_a, i_y);
    c_sim(t) = policy_c(i_a, i_y);
    s_sim(t) = exp(y_sim(t)) - c_sim(t);
    
    % Update income (this might cause the line 39 error)
    y_sim(t+1) = rho * y_sim(t) + epsilon_sim(t);
    
    % ADD BOUNDS CHECK for y_sim to prevent extreme values
    y_sim(t+1) = max(min(y_sim(t+1), max(y_grid)), min(y_grid));
end

% Final period
[~, i_a] = min(abs(a_grid - a_sim(T_total)));
[~, i_y] = min(abs(y_grid - y_sim(T_total)));
i_a = max(1, min(i_a, n_a));
i_y = max(1, min(i_y, n_y));

c_sim(T_total) = policy_c(i_a, i_y);
s_sim(T_total) = exp(y_sim(T_total)) - c_sim(T_total);

% Discard burn-in
y_sim = y_sim(T_burn+1:end);
a_sim = a_sim(T_burn+1:end);
c_sim = c_sim(T_burn+1:end);
s_sim = s_sim(T_burn+1:end);
exp_y_sim = exp(y_sim);
epsilon_sim = epsilon_sim(T_burn+1:end);

% Consumption changes
Delta_c_sim = [0; diff(c_sim)];

fprintf('Simulation completed successfully\n');
end