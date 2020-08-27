function [ vmHSV_cart ] = HSVpolar_to_cartesian( vmHSVpc )
%HSVPOLAR_TO_CARTESIAN 
% input:
% vmHSVpc     = list of vertexes, polar coordinates, one per row, entries in [0..360],[0..100],[0.100]
% output:
% vmHSV_cart  = list of vertexes, cart  coordinates, one per row, entries in [-1..1] ,[-1..1] ,[0.100]

RadiusHSV = vmHSVpc(:,2)/100;
vmHSV_cart    = [RadiusHSV.*cos(vmHSVpc(:,1)/180*pi),RadiusHSV.*sin(vmHSVpc(:,1)/180*pi),vmHSVpc(:,3)]; 

end

