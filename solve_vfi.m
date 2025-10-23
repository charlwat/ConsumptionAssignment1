function [V, policy_a, policy_c, iter] = solve_vfi(a_grid, y_grid, y_trans, beta, r, utility, tol, max_iter)
% SOLVE_VFI Solve the value function iteration problem
% Inputs:
%   a_grid - asset grid
%   y_grid - income grid  
%   y_trans - income transition matrix
%   beta - discount factor
%   r - interest rate
%   utility - utility function handle
%   tol - convergence tolerance
%   max_iter - maximum iterations

n_a = length(a_grid);
n_y = length(y_grid);
a_min = min(a_grid);

% Initialize
V0 = zeros(n_a, n_y);
V1 = zeros(n_a, n_y);
policy_a = zeros(n_a, n_y);
policy_c = zeros(n_a, n_y);

iter = 0;
diff_VFI = tol + 1;

fprintf('Starting Value Function Iteration...\n');

while diff_VFI > tol && iter < max_iter
    for i_a = 1:n_a
        for i_y = 1:n_y
            a_current = a_grid(i_a);
            y_current = y_grid(i_y);
            current_income = exp(y_current);
            
            best_value = -1e10;
            best_a_next = a_min;
            best_consumption = 0;
            
            % Search over feasible next period assets
            for i_a_next = 1:n_a
                a_next = a_grid(i_a_next);
                consumption = a_current + current_income - a_next/(1+r);
                
                if consumption > 1e-10
                    % Expected continuation value
                    EV_next = 0;
                    for i_y_next = 1:n_y
                        EV_next = EV_next + y_trans(i_y, i_y_next) * V0(i_a_next, i_y_next);
                    end
                    
                    current_value = utility(consumption) + beta * EV_next;
                    
                    if current_value > best_value
                        best_value = current_value;
                        best_a_next = a_next;
                        best_consumption = consumption;
                    end
                end
            end
            
            V1(i_a, i_y) = best_value;
            policy_a(i_a, i_y) = best_a_next;
            policy_c(i_a, i_y) = best_consumption;
        end
    end
    
    diff_VFI = max(max(abs(V1 - V0)));
    iter = iter + 1;
    
    if mod(iter, 50) == 0
        fprintf('Iteration %d, Difference: %.2e\n', iter, diff_VFI);
    end
    
    V0 = V1;
end

fprintf('Convergence achieved after %d iterations\n', iter);
V = V1;
end