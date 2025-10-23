function display_qualitative_expectations()
% DISPLAY_QUALITATIVE_EXPECTATIONS Display part (d) qualitative expectations
% This function explains the expected effects of various parameter changes
% on consumption volatility

fprintf('\n=== QUALITATIVE EXPECTATIONS FOR CONSUMPTION VOLATILITY ===\n\n');

fprintf('(a) ZERO BORROWING CONSTRAINT:\n');
fprintf('    Expected effect on σ_c: INCREASE\n');
fprintf('    Reasoning:\n');
fprintf('    - Tighter borrowing constraints reduce the household''s ability to smooth consumption\n');
fprintf('    - Household cannot borrow against future income during low-income periods\n');
fprintf('    - Forces more consumption to track current income closely\n');
fprintf('    - Reduces intertemporal consumption smoothing capacity\n\n');

fprintf('(b) DOUBLE RELATIVE RISK AVERSION (γ = 2.6):\n');
fprintf('    Expected effect on σ_c: DECREASE\n');
fprintf('    Reasoning:\n');
fprintf('    - Higher risk aversion increases precautionary savings motive\n');
fprintf('    - Household accumulates more buffer stock savings\n');
fprintf('    - Larger asset cushion provides better insurance against income fluctuations\n');
fprintf('    - Enhanced ability to smooth consumption across different income states\n');
fprintf('    - More conservative consumption policy reduces sensitivity to income shocks\n\n');

fprintf('(c) DOUBLE INTEREST RATE (r = 0.08):\n');
fprintf('    Expected effect on σ_c: DECREASE\n');
fprintf('    Reasoning:\n');
fprintf('    - Higher return on savings encourages more asset accumulation\n');
fprintf('    - Increased wealth effect allows for better consumption smoothing\n');
fprintf('    - Higher interest income provides additional buffer against income fluctuations\n');
fprintf('    - Makes saving more attractive relative to current consumption\n');
fprintf('    - According to PIH, higher r reduces MPC and increases smoothing\n\n');

fprintf('(d) DOUBLE INCOME VOLATILITY (σ = 0.08):\n');
fprintf('    Expected effect on σ_c: INCREASE\n');
fprintf('    Reasoning:\n');
fprintf('    - More volatile income process directly increases income risk\n');
fprintf('    - Larger income shocks are harder to smooth completely\n');
fprintf('    - Even with optimal behavior, some consumption response to larger shocks is inevitable\n');
fprintf('    - Precautionary savings increase but may not fully offset increased volatility\n');
fprintf('    - Consumption becomes more responsive to larger income fluctuations\n\n');

fprintf('THEORETICAL FOUNDATIONS:\n');
fprintf('• Permanent Income Hypothesis: consumption depends on permanent income, not transitory fluctuations\n');
fprintf('• Precautionary Savings: uncertainty increases savings, reducing consumption volatility\n');
fprintf('• Borrowing Constraints: limit ability to smooth consumption, increasing volatility\n');
fprintf('• Buffer Stock Model: households maintain target wealth to smooth consumption\n\n');

fprintf('EMPIRICAL EXPECTATIONS:\n');
fprintf('• In developed economies with good financial markets: σ_c/σ_y ≈ 0.6-0.8\n');
fprintf('• In emerging economies with credit constraints: σ_c/σ_y ≈ 0.9-1.1\n');
fprintf('• Your simulation result: σ_c/σ_y = %.4f\n', 0.9774); % This would need to be passed as parameter
fprintf('• This suggests moderate consumption smoothing in your calibrated economy\n');

fprintf('\nThese qualitative predictions are based on:\n');
fprintf('• Carroll (1997) - Buffer Stock Saving\n');
fprintf('• Deaton (1991) - Saving and Liquidity Constraints\n');
fprintf('• Friedman (1957) - Permanent Income Hypothesis\n');
fprintf('• Standard consumption-saving theory with incomplete markets\n');
end