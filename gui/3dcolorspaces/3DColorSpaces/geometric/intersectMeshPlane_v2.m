%given 
%(vm,fm)  : vertexes, faces (triangles) of a mesh
%Plane    : a Plane [nx,ny,nz,dP] given by a normal n, and a const dP / {<(x,y,z)),n> == dP}
%finds all the edge intersections (6 coord, 2 points) with given triangles
function [Vertexes,Lines,Lengths] = intersectMeshPlane(vm,fm,Plane)

if size(fm,2) ~= 3
    error('Intersection with rectangular mesh not implemented, please specify meshType = triangle');
    % intersecting in 3D a rectangle with a plane is not much different than 
    % with triangle (intersectTrianglePlane.m)
    % but it is surely more cumbersome...
    % Also, triangular mesh is more suited to fill any shape, whereas rectangular
    % will need more oversampling on the edges to achieve similar smooth results
    % Think e.g. of the RGB to Lab solid conversions
end
Nfaces   = size(fm,1);

Vertexes = [];
% Lines    = []; cnt      = 0;
for selT = 1:Nfaces
    triangleV     = vm(fm(selT,:),:);  %each row contains x,y,z coord of 1 vertex  
    EdgeIntersect = intersectTrianglePlane(triangleV,Plane); 
    %if triangle intersects plane it identifies 2 cross points (an 'edge')
    %EdgeIntersect = [x0,y0,z0,x1,y1,z1]
    if ~isempty(EdgeIntersect) %edge = [x0,y0,z0,x1,y1,z1]
        V        = reshape(EdgeIntersect',[],2)';  %V = [x0,y0,z0;x1,y1,z1] is 2 vertexes
        if ~(all(V(1,:)==V(2,:)))  %skip zero length lines
            
            %check if this Edge already exists
            N1    = size(Vertexes,1)/2;
            found = false;
            for jj=0:N1-1
                if (all(V(1,:)==Vertexes(1+2*jj,:))) && (all(V(2,:)==Vertexes(2+2*jj,:))) || ...
                   (all(V(2,:)==Vertexes(1+2*jj,:))) && (all(V(1,:)==Vertexes(2+2*jj,:)))
                    found = true;
                end                    
            end
            
            if ~found
                Vertexes = [Vertexes;V]; %add these two vertexes (1 line segment on the perimeter)
                
% assume connectedness, so avoid to calc lines just yet                
%               Lines    = [Lines; [1,2]+cnt];              
%               cnt      = cnt+2;        
            end
        end
    end
end

%===========================================
%reduce Vertexes to a minimum  set
%===========================================
VertexesNew = Vertexes;
% LinesNew    = Lines;
finished    = false;
ii          = 1;
while ~finished
    V  = VertexesNew(ii,:);
    N1 = size(VertexesNew,1);
%     vertexRemoved = false;
    for jj=ii+1:N1
        if jj > N1
            break
        end
        if all(VertexesNew(jj,:)==V)
%             vertexRemoved = true;
            %remove Vertex jj
            VertexesNew = [VertexesNew(1:jj-1,:) ; VertexesNew(jj+1:end,:)];
            N1          = N1-1;
            %replace in Lines ref to jj by ii
            
% assume connectedness, so avoid to calc lines just yet           
% % @@ check if we need lines already and how they are defined
%             
% %             [idx1,idx2]          = find(LinesNew == jj);
% %             LinesNew(idx1,idx2)  = ii;
%             %replace in Lines ref to jj+x by jj+x-1
%             [idx1,idx2]          = find(LinesNew > jj);
%             n1 = length(idx1);
%             for kk=1:n1
%                 LinesNew(idx1(kk),idx2(kk))  = LinesNew(idx1(kk),idx2(kk))-1;
%             end
% %             %pos jj must be rechecked ! ??
% %             jj = max(jj-1,ii+1);
% %             break
        end
    end    
    finished = (ii == N1);
%     if ~vertexRemoved
        ii = ii+1;
%     end
end

%% There should be NO DUPLICATE VERTEXES HERE (but there are :( )!
VertListHasReduced = size(VertexesNew,1) < size(Vertexes,1);
if VertListHasReduced
    Vertexes = VertexesNew;
end



%===================================
%reorder Vertexes in neighbour order (lines will be recalc at the end)
%===================================
VertexesNew = Vertexes;
for ii = 1:size(Vertexes,1)-1
    V  = VertexesNew(ii,:);
    allDists = zeros(N1,1) + 2*max(max(abs(Vertexes)));
    for jj=ii+1:N1 
        allDists(jj) = sqrt(sum((V-VertexesNew(jj,:)).^2));
    end
        [minD,idx]   = min(allDists);
        idxClosest   = idx(1);
        
        %exchange (ii+1),idxClosest
        Vneighbour = VertexesNew(idxClosest,:);
        Vnext      = VertexesNew(ii+1,      :);
        VertexesNew(ii+1,       :) = Vneighbour;
        VertexesNew(idxClosest, :) = Vnext;  
end
Vertexes = VertexesNew;



%===================================
%reorder Vertexes in angle wrt to center
%===================================
Nv        = size(Vertexes,1);
midPt     = mean(Vertexes);
radiiVecs = Vertexes-ones(Nv,1)*midPt;
%  figure;plot3(radiiVecs(:,1),radiiVecs(:,2),radiiVecs(:,3))
pivot = radiiVecs(1,:);
thetaDEG=zeros(1,Nv);
for iv = 1:Nv
    thetaDEG(iv) = angDist2Vecs(radiiVecs(iv,:),pivot);
end
allThetas = unwrap(thetaDEG/180*pi);
[~,idx]=sort(allThetas);

Vertexes = Vertexes(idx,:);

% ----------------
% construct lines joining two adjacent vertexes (assume connectedness, so we avoid book-keeping up till here)
% ----------------
Lines = [];
for iv = 0:Nv-2
    Lines    = [Lines; [1,2]+iv];  
end
Lines    = [Lines; [Nv,1]];


% % %===================================
% % %OPTIONAL
% % %reorder Lines according to Vertexes, each vertex appears twice because it is a polygon
% % %===================================
% % % [yy,ii]=sort(sum(Lines,2));
% % % [yy,ii]=sort( abs( Lines(:,1)-Lines(:,2) ) );
% % % [yy,ii]=sort(sum(Lines,2) + abs( Lines(:,1)-Lines(:,2) ));
% % % Lines = Lines(ii,:);
% % nV      = size(Vertexes,1);
% % LinesNew= Lines;
% % ii      = 1;
% % for jj=1:nV
% %     [idx1A,idx2A] = find(Lines==jj);
% %     [idx1B,idx2B] = find(Lines==mod(jj,nV)+1);
% %     idx1 = intersect(idx1A,idx1B);
% %     if isempty(idx1)
% %         keyboard
% %     end
% %     LinesNew(ii  ,:) = Lines(idx1(1),:);
% %     ii = ii+1;
% % end
% % Lines = LinesNew;


%calc Lengths
nL      = size(Lines,1);
Lengths = zeros(nL,1);
for jj=1:nL
    P1 = Vertexes(Lines(jj,1), :);
    P2 = Vertexes(Lines(jj,2), :);    
    Lengths(jj) = sqrt(sum((P1-P2).^2));
end









