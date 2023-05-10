% SHWFS_GET_CENTRES     Gets the spots centres.
%   CENTRES = SH_GET_CENTRES(IMG, SHSTRUCT, MYFUNCENTROID) gets the
%   pixel coordinates of the spots from an image in doubles of
%   the Shack-Hartmann wavefront sensor. centres is stored in
%   the (x, y) plot() reference frame after imshow().
%   The origin is in the top left corner. centres(:, 1) are
%   the displacements in X (left to right). centres(:, 2) are
%   the displacements in Y (top to bottom). Displacements
%   are ordered according shstruct.enumeration. centres(i, 1)
%   corresponds to the i-th spot (shstruct.enumeration(i)).
%


function move = shwfs_get_centres(frame, shstruct)
nspots=shstruct.nspots;
ordgrid = shstruct.squaregrid;
%myfuncentroid =shstruct.centroid
move=zeros(nspots, 2);

for ith=1:nspots
    cc = ordgrid(ith, :);

    % images are height by width!
%     if (shstruct.use_bg)
%         subimage = frame(cc(3):cc(4), cc(1):cc(2)) - ...
%             shstruct.sh_flat_bg(cc(3):cc(4), cc(1):cc(2));
%     else
        subimage = frame(cc(3):cc(4), cc(1):cc(2));
         
  
    
    iimin = min(min(subimage));
    iimax = max(max(subimage));
    level = 0;
   
% A=sort(subimage(:));
%  meanA=mean(A([110:end]));
%       standard_deviationA=std(A([110:end]));
%       level=meanA+3.*standard_deviationA;

    dd= centroid(subimage, level);
    % centroid returns in column major order
    %move(ith, :) = dd;
    move(ith, :) = [cc(1)+dd(1)-1, cc(3)+dd(2)-1];
end
end


