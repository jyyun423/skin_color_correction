function f = angular_error_between_src_dst(source, target)
    target_norm = sqrt(sum(target.^2,2));
    source_mapped_norm = sqrt(sum(source.^2,2));
    f = sum(source .* target,2)./(source_mapped_norm.*target_norm);
    f(f>1)=1;
    f = acosd(f);
end