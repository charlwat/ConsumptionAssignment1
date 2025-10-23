% VFI_Assignment.m (Final optimized version)

a_min = 0;
a_max = 10;
num_points_a = 100;

y_min = -5;
y_max = 5;
num_points_y = 50;

a_grid = linspace(a_min, a_max, num_points_a);
y_grid = linspace(y_min, y_max, num_points_y);

%% Initialize Value Function
n_a = length(a_grid);
n_y = length(y_grid);
V = zeros(n_a, n_y); % Initialize value function matrix
clear; close all; clc;

%% Parameter Calibration
beta = 0.96; gamma = 1.3; r = 0.04; rho = 0.9; sigma = 0.04;

%% State Space Discretization
a_min = 0; a_max = 50; n_a = 100;
a_grid = a_min + (a_max - a_min) * (exp(linspace(0, 1, n_a)) - 1) / (exp(1) - 1);

n_y = 7; m = 3; mu_y = 0;
[y_grid, y_trans] = Tauchen(n_y, mu_y, rho, sigma, m);
y_grid = y_grid';

%% Utility Function
if gamma == 1
    utility = @(c) log(c);
else
    utility = @(c) (c.^(1-gamma)) ./ (1-gamma);
end

%% Solve Value Function Iteration
tol = 1e-9; max_iter = 1000;
[V, policy_a, policy_c, iter] = solve_vfi(a_grid, y_grid, y_trans, beta, r, utility, tol, max_iter);

%% Run Simulation
T_sim = 1000; T_burn = 500;
[y_sim, a_sim, c_sim, s_sim, exp_y_sim, epsilon_sim, Delta_c_sim] = ...
    run_simulation(policy_a, policy_c, a_grid, y_grid, y_trans, rho, sigma, T_sim, T_burn);

%% Analyze Results
results = analyze_results(c_sim, exp_y_sim, epsilon_sim, Delta_c_sim, r, rho);

%% Generate All Plots
generate_plots(a_grid, y_grid, V, policy_a, policy_c, ...
               y_sim, a_sim, c_sim, s_sim, exp_y_sim, epsilon_sim, Delta_c_sim, results);

%% Display Qualitative Expectations
display_qualitative_expectations();

%% Save Results
save('VFI_results.mat', 'a_grid', 'y_grid', 'V', 'policy_a', 'policy_c', ...
     'c_sim', 'a_sim', 'y_sim', 'results');

fprintf('\n=== COMPLETE VFI ANALYSIS FINISHED ===\n');
