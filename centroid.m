% RET = CENTROID(IM, THR)
%
%   RET = CENTROID(IMG, THR) computes the
%   centroid of IMG using THR as the relative
%   threshold. Centroid works on column major
%   order. shstruct.ord_centres and shstruct.ord_sqgrid
%   is stored in the x,y plot() axes, (origin is in
%   the top left, x points right, y points down).
%   [cc(1)+dd(2)-1, cc(3)+dd(1)-1].
%
% Author: Jacopo Antonello, <jack at antonello dot org>
% $Id: 2f24ca9622d12b909096e1b65d76288fced96bb6 $
% Technische Universiteit Delft

function [ret] = centroid(im, thr)

%assert(isa(im, 'double'));

% global select;

if (nargin < 2)
    thr = 0;
end

[w h] = size(im);

mass = 0;
sumx = 0;
sumy = 0;

parfor x=1:w
    for y=1:h
        val = im(x, y);
        if (val >= thr)
            sumx = sumx + val*x;
            sumy = sumy + val*y;
            mass = mass + val;
        end
    end
end


ret = [sumx/mass-1;sumy/mass-1];
% ret = round(ret);

% if select
% sfigure(12);
% imshow(im);
% hold on;
% plot(ret(2), ret(1), 'xr');
% pause(0.1);
% end

end
