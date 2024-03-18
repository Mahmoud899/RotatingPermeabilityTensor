%% Add Modules
mrstModule add incomp ad-core book
%% SetuP Grid and Petrophysical Data
[nx, ny] = deal(60, 60);
[Lx, Ly] = deal(400, 400);
[lx, ly] = deal(Lx/nx, Ly/ny);

G = cartGrid([nx, ny, 1], [Lx, Ly, 50]);
G.nodes.coords(:,3) = G.nodes.coords(:,3)+2000;
G = computeGeometry(G);

% petrophysical data
% permeability
km = 20*milli*darcy();
kM = 2500*milli*darcy();
kz = 10*milli*darcy;
K = [km, 0, 0, kM, 0, kz];

% porosity
phi = 0.35;

rock = makeRock(G, K, phi);
%%
pv = sum(poreVolume(G, rock));
bbl = 1/6.28981;
T = 10 *year();
rate = pv/(T + 5*year());

%%
kx  = @(km, kM, t) km*cos(deg2rad(t))^2 + kM*sin(deg2rad(t))^2;
kxy = @(km, kM, t) (kM-km)*sin(deg2rad(t)) * cos(deg2rad(t));
ky  = @(km, kM, t) km*sin(deg2rad(t))^2 + kM*cos(deg2rad(t))^2;
%% Fluid
fluid = initCoreyFluid( 'mu' , [ 1, 10]*centi*poise , ...
                        'rho', [1014, 859]*kilogram/meter^3, ...
                        'n' , [ 3, 2.5] , ...
                        'sr' , [ 0.2, .15] , ...
                        'kwm', [ 1, .85]);

%% Wells
ProdCellInx = 1;
InjCellInx  = nx*ny;

W = [];
W = addWell([], G, rock, ProdCellInx, 'Type', 'bhp', ...
            'Val', 100*barsa, 'name', 'P', 'radius', 0.1, 'Comp_i', [0 1]);

W = addWell(W, G, rock, InjCellInx, 'Type', 'rate', ...
            'Val', rate, 'name', 'I', 'radius', 0.1, 'Comp_i', [1 0]);
%% Simulation loop
M = 400;
Thetas = [0, 15, 30, 45];
n = numel(Thetas);
[dt, dT] = deal(zeros(M, 1), T/M);
Rsols = cell(M, n);
wellSol = cell(M, n);
oip = zeros(M, n);

divider = floor(M/3);
for i = 1:n
    fprintf('\nCase %d: Rotation angle = %d', i, Thetas(i));
    x = initState(G, W, 200*barsa, [0.2, 0.8]);
    t = 0;

    k1 = kx(km, kM, Thetas(i));
    k2 = kxy(km, kM, Thetas(i));
    k3 = ky(km, kM, Thetas(i));
    K = [k1, k2, 0, k3, 0, kz];
    rock = makeRock(G, K, phi);
    hT = computeTrans(G,rock);

    for j = 1:M
        if mod(j, divider) == 0
            fprintf('\nTime Step %d, Time = %0.1f years', j, T/M * j/year);
        end
        x = incompTPFA(x, G, hT, fluid, 'wells', W);
        x = implicitTransport(x, G, dT, rock, fluid, 'wells', W);
        
        dt(j) = dT;
        oip(j, i) = sum(x.s(:, 2).*poreVolume(G, rock));
        Rsols{j, i} = x;
        wellSol{j, i} = getWellSol(W, x, fluid);
    end
    fprintf('\n')
end



