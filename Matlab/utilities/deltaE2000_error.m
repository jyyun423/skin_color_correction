function error = deltaE2000_error(source, target, varargin)

% Optional Parameters:
% KLCH :    parametric weighting factor k_l, k_c, k_h (default = 1, 1, 1)
%
% Based on the article : 
% "The CIEDE2000 Color-difference Formula:
% Implemantation Notes, Supplementary Test Data, and Mathematical
% Observations" G. Sharma, W. Wu, E. N. Dalal

% check input params
param = parseInput(varargin{:});
param = paramCheck(param);

% check inputs
assert(isequal(size(source), size(target)),...
       'The size of source and target does not match');
assert(size(source, 2) == 3,...
       'Both source and target must be Nx3 matrices.');
   
% get deltaE 2000 error
% step 1 : calculate chorma', hue'
L_target = target(:,1)';
a_target = target(:,2)';
b_target = target(:,3)';

L_source = source(:,1)';
a_source = source(:,2)';
b_source = source(:,3)';

Cab_target = sqrt(a_target.^2 + b_target.^2);
Cab_source = sqrt(a_source.^2 + b_source.^2);
Cab_mean = (Cab_target + Cab_source) / 2;

G = 0.5 * (1 - sqrt((Cab_mean.^7)./(Cab_mean.^7 + 25^7)));

aprime_target = (1+G).*a_target;
aprime_source = (1+G).*a_source;

Cprime_target = sqrt(aprime_target.^2 + b_target.^2);
Cprime_source = sqrt(aprime_source.^2 + b_source.^2);

hprime_target = atan2(b_target, aprime_target);
hprime_target = hprime_target + 2*pi*(hprime_target < 0);
hprime_source = atan2(b_source, aprime_source);
hprime_source = hprime_source + 2*pi*(hprime_source < 0);

% step 2 : calculate delta L, delta C, delta H
deltaL = (L_source - L_target);
deltaC = (Cprime_source - Cprime_target);

Cprime_prod = (Cprime_source.*Cprime_target);
zero = find(Cprime_prod == 0);

dh_tmp = hprime_source - hprime_target;
deltahprime = (zero == 0) * 0 + ...
    (zero ~= 0) * ((dh_tmp) + ((dh_tmp > pi)*(-2*pi) + (dh_tmp < -pi)*(2*pi)));

deltaH = 2 * sqrt(Cprime_prod) .* sin(deltahprime/2);

% step 3 : Calculate CIEDE2000 color-difference
Lprime = (L_source + L_target) / 2;
Cprime = (Cprime_source + Cprime_target) / 2;

hp_tmp = (hprime_source + hprime_target) / 2;
hprime = (zero == 0) * 0 + (zero ~= 0) * (hp_tmp - (abs(dh_tmp) > pi) * pi);
hprime = hprime + (hprime < 0)*2*pi;

T = 1 - 0.17*cos(hprime-pi/6) + 0.24*cos(2*hprime) + ...
    0.32*cos(3*hprime+pi/30) - 0.20*cos(4*hprime-63*pi/180);
dtheta = (pi/6) * exp(-((180/pi*hprime-275)/25).^2);
Rc = 2*sqrt((Cprime.^7)./(Cprime.^7 + 25^7));
Ltmp = (Lprime - 50).^2;
Sl = 1 + (0.015*Ltmp)./sqrt(20+Ltmp);
Sc = 1 + 0.045*Cprime;
Sh = 1 + 0.015*Cprime.*T;
Rt = -sin(2*dtheta).*Rc;

klsl = param.KLCH(1) * Sl;
kcsc = param.KLCH(2) * Sc;
khsh = param.KLCH(3) * Sh;

error = sqrt((deltaL./klsl).^2 + (deltaC./kcsc).^2 + (deltaH./khsh).^2 ...
    + Rt.*(deltaC./kcsc).*(deltaH./khsh));

end


function param = parseInput(varargin)
% parse inputs & return structure of parameters
parser = inputParser;
parser.addParameter('KLCH', [1,1,1], @(x)validateattributes(x, {'numeric'}, {'positive'}));
parser.parse(varargin{:});
param = parser.Results;
end


function param = paramCheck(param)
% check the parameters

if ~isempty(param.KLCH)
    assert(numel(param.KLCH) == 3,...
           'The value of ''KLCH'' must be a 1x3 vector.');
end

end
