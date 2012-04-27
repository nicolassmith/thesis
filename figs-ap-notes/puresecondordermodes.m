function puresecondordermodes()

exportplot = 1;

addpath('/home/nicolas/git/OMCalignModel')

i = modalIndex(3,3,1);

E = zeros(i.N,1);

E(i(0,0)) = 1;

x = linspace(-1.5,1.5,50);
y = x;

bullseye = zeros(i.N,1);
bullseye(i(2,0)) = 1/sqrt(2);
bullseye(i(0,2)) = 1/sqrt(2);

astig  = zeros(i.N,1);
astig(i(2,0)) = 1/sqrt(2);
astig(i(0,2)) = -1/sqrt(2);


astig45  = zeros(i.N,1);
astig45(i(1,1)) = 1;

fvec = @(x) 0;

v = 0:.02:.7;
crange = [min(v) max(v)];
theta = 0:.01:2*pi;
r = 1;

phi = pi/2;

plotBeam = @(E) contourf(x,y,abs(transverseField(x,y,0,0,E,i,fvec)).^2,v,...
...%plotBeam = @(E) contourf(x,y,abs(transverseField(x,y,0,0,E,i,fvec)).^2/abs(transverseField(0,0,0,0,E,i,fvec)).^2,v,...
    'EdgeColor','none','LineStyle','none');

figure(1)
scale = 175;
set(gcf,'Units','Pixels','Position',[0 0 2*scale 2*scale])
set(gcf,'color','white')

if exportplot
    set(gcf,'Visible','Off')
end

linestyle = 'w--';

subplot(2,2,1)
plotBeam(E)
hold on
h = plot(r*cos(theta),r*sin(theta),linestyle);
%axis square
caxis(crange)
set(gca,'Units','Pixels','Position',[0 scale scale scale])
axis off
%set(h,'LineWidth',2)

subplot(2,2,2)
plotBeam(E*cos(phi)+sin(phi)*bullseye)
hold on
plot(r*cos(theta),r*sin(theta),linestyle)
caxis(crange)
set(gca,'Units','Pixels','Position',[scale scale scale scale])
axis off


subplot(2,2,3)
plotBeam(E*cos(phi)+sin(phi)*astig)
hold on
plot(r*cos(theta),r*sin(theta),linestyle)
caxis(crange)
set(gca,'Units','Pixels','Position',[0 0 scale scale])
axis off


subplot(2,2,4)
plotBeam(E*cos(phi)+sin(phi)*astig45)
hold on
plot(r*cos(theta),r*sin(theta),linestyle)
caxis(crange)
set(gca,'Units','Pixels','Position',[scale 0 scale scale])
axis off


colormap(gray)


if exportplot
    set(gcf,'Visible','Off')
    export_fig('puresecondordermodes.pdf','-painters')
end

end
