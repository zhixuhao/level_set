function phi = drlse_edge(phi_0, g, alfa, epsilon, mu, timestep, iter_inner,cha_c0)


phi = phi_0;
[vx, vy]=gradient(g);
color_dif = cha_c0;                                        
for k=1:iter_inner
    phi=NeumannBoundCond(phi);
    [phi_x,phi_y]=gradient(phi);%gradient [f(x+1)- f(x-1)]/2
    s=sqrt(phi_x.^2 + phi_y.^2);
    smallNumber=1e-10;  
    Nx=phi_x./(s+smallNumber); % add a small positive number to avoid division by zero
    Ny=phi_y./(s+smallNumber);
    curvature=div(Nx,Ny); %
    distRegTerm = 4*del2(phi);%-curvature;  % compute distance regularization term in equation (13) with the single-well potential p1.
    %distRegTerm = distReg_p2(phi); %double-well 
    diracPhi=Dirac(phi,epsilon);
    edgeTerm=diracPhi.*(vx.*Nx+vy.*Ny) + diracPhi.*g.*curvature;
    phi=phi + timestep*(mu*distRegTerm + alfa*edgeTerm + diracPhi.*g.*color_dif);
end




function f = distReg_p2(phi)
% compute the distance regularization term with the double-well potential p2 in eqaution (16)
[phi_x,phi_y]=gradient(phi);
s=sqrt(phi_x.^2 + phi_y.^2);
a=(s>=0) & (s<=1);
b=(s>1);
ps=a.*sin(2*pi*s)/(2*pi)+b.*(s-1);  % compute first order derivative of the double-well potential p2 in eqaution (16)
dps=((ps~=0).*ps+(ps==0))./((s~=0).*s+(s==0));  % compute d_p(s)=p'(s)/s in equation (10). As s-->0, we have d_p(s)-->1 according to equation (18)
f = div(dps.*phi_x - phi_x, dps.*phi_y - phi_y) + 4*del2(phi);  


function f = div(nx,ny)
[nxx,junk]=gradient(nx);  
[junk,nyy]=gradient(ny);
f=nxx+nyy;



function g = NeumannBoundCond(f)%??????????????????
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  %??4??????????????????????
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);     %????????????????????????     
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);  %??????????????????????