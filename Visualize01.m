%% Dummy Figure
clf(figure(1));
pargs = {'EdgeAlpha',.1,'EdgeColor','k'};

hs = plotCellData(G, convertTo(rock.perm(:, 4), milli*darcy));

%% Dynamic Plot
figure(3);
clf(figure(3));
plotGrid(G, 'facecolor', 'none', 'edgealpha', 0.3)
plotWell(G, W);
% view(3);
axis tight;
set(gca,'dataasp',[1 1 1]);
colormap(flipud(winter));
colormap(flipud(.5*jet(10)+.5*ones(10,3)));
% gif_name = 'Angle45.gif';
cb = colorbar('horiz');
cb.Ticks = [0, 0.25, 0.5, 0.75, 1];
caxis([0, 1]);
for j = 1:M
    delete(hs);
    sol = Rsols{j, 1};
    hs = plotCellData(G, sol.s(:, 1), (sol.s(:, 1) > 0.01), pargs{:});
    title(sprintf('Rotation angle = 45\n%0.2f years', convertTo(j/M * T, year)))
%     pause(0.05);

    drawnow
%     make_gif(gcf, j, gif_name);

end
%%
Time = cumsum(dt);
plotWellSols({wellSol(:, 1), wellSol(:, 2), wellSol(:, 3), wellSol(:, 4)}, Time, ...
    'datasetnames',{'0', '15', '30', '45'})
%%
cval = linspace(0,1,11); cval=.5*cval(1:end-1)+.5*cval(2:end);
lc = @(l) 1+(l-1)*nx*ny:l*nx*ny;
plotLayerData = @(x, l) ...
    contourf(reshape(G.cells.centroids(lc(l), 1), [nx, ny, 1]), ...
             reshape(G.cells.centroids(lc(l), 2), [nx, ny, 1]), ...
             reshape(x.s(lc(l), 1), [nx, ny, 1]), cval);

figure(4); clf(figure(4));
colormap(flipud(.5*jet(10)+.5*ones(10,3)));

layer = [3 6 9 12 15];
intervals = [50 150 200 250];

for i = 1:numel(intervals)
    for j = 1:n
    subplot(n, numel(intervals), i+(j-1)*numel(intervals));
    plotLayerData(Rsols{intervals(i), j}, 1);
    axis equal; axis([0 Lx 0 Ly]);
    set(gca,'XTick',[],'YTick',[]);
    title(sprintf('%0.0f years\n Angle %d', convertTo(intervals(i)/M * T, year), Thetas(j)))
    end
end













