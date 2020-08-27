function [ vmHSVpc ] = HSVcartesian_to_polar( vmHSV_cart )
%HSVCARTESIAN_TO_POLAR
% input:
% vmHSVpc     = list of vertexes, polar coordinates, one per row, entries in [0..360],[0..100],[0.100]
% output:
% vmHSV_cart  = list of vertexes, cart  coordinates, one per row, entries in [-1..1] ,[-1..1] ,[0.100]

H = mod(atan2(vmHSV_cart(:,2),vmHSV_cart(:,1)),2*pi)*360/2/pi;
S = sqrt(vmHSV_cart(:,1).^2+vmHSV_cart(:,2).^2)*100;
V = vmHSV_cart(:,3);
vmHSVpc = [H,S,V];

end

