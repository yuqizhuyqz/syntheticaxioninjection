function list = rejectionsampling_fakeaxions(nua, seed, Nsamples)
%% 
% rejection sampling axion vel./kinetic eng. dist from a Cauchy dist, c=3 
% input:
% nua [GHz]: hypothetical axion mass
% seed: rng seed (int)
% Nsamples: number of rv to be sampled from an axion dist.
% return: list of Nsamples random freq. [GHz]

% axion dist. (faxionEarth) equations (7.13, 7.14) from Brubaker's thesis
% same assumptions and parameters
vv = 270000; % virial velocity = 270 km/s
beta = vv/299792458; % vv/speed of light
r = sqrt(2/3); % accounting for modulation due to our rotation in the galaxy

rng(seed);
g=makedist('tLocationScale','mu',nua+1E-6,'sigma',3E-6,'nu',1); % Cauchy dist~ 'Lorentizan' with width~3 kHz
c=3; % scaling factor for the envelope Cauchy dist.
U=makedist('Uniform'); % uniform dist for comparison in the rejection process

x=nua:10^-8:nua+10^-4;
faxionEarth=2/sqrt(pi)*sqrt(3/2)*1/(r*nua*beta^2).*sinh(3*r ... 
    *sqrt(2*(x-nua)/(nua*beta^2))).*exp(-3*(x-nua)/(nua*beta^2)-3/2*r^2);
list=[];

% check if the condition for rejection sampling is satisfied
if prod(pdf(g,x).*c > faxionEarth) == logical(0)
    % return an error if not. try increase c
    error('condition not satisfied: g*c<=f_axion');
else
    % proceed to rejection sampling  
    n=1;
   while length(list)<Nsamples
        y=random(g);u=random(U);
        x=y;
        faxionEarth=2/sqrt(pi)*sqrt(3/2)*1/(r*nua*beta^2).*sinh(3*r*sqrt( ...
            2*(x-nua)/(nua*beta^2))).*exp(-3*(x-nua)/(nua*beta^2)-3/2*r^2);
        if u<faxionEarth/(c*pdf(g,y))
            list=[list y];
        end
        n=n+1;
    end
end
end
