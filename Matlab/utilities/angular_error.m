function error = angular_error(source, target)

% check the inputs
assert(isequal(size(source), size(target)),...
       'The size of source and target does not match');
assert(size(source, 2) == 3,...
       'Both source and target must be Nx3 matrices.');

target_norm = sqrt(sum(target.^2,2));
source_mapped_norm = sqrt(sum(source.^2,2));
error = sum(source .* target,2)./(source_mapped_norm.*target_norm);
error(error>1)=1;
error = acosd(error);

end

