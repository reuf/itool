function D = update_dataterm(obj,dataterm,ran_t) % for video
%UPDATE_DATATERM 计算等辐照线方向和边界法向的内积
%
    D = dataterm;
    for frame = ran_t
        ix1 = obj.movie_Y_Gx(:,:,frame); %取Y分量x方向的梯度
        iy1 = obj.movie_Y_Gy(:,:,frame); %取Y分量y方向的梯度
        
        ix2 = obj.movie_U_Gx(:,:,frame); %取U分量x方向的梯度
        iy2 = obj.movie_U_Gy(:,:,frame); %取U分量y方向的梯度
        
        ix3 = obj.movie_V_Gx(:,:,frame); %取V分量x方向的梯度
        iy3 = obj.movie_V_Gy(:,:,frame); %取V分量y方向的梯度
                
        ix = (ix1+ix2+ix3)/255; % 将YUV三个分量在x方向的梯度合并
        iy = (iy1+iy2+iy3)/255; % 将YUV三个分量在y方向的梯度合并
        
        temp = ix; ix = -iy; iy = temp;  % 梯度旋转90度即为等照度线方向
        
        [nx,ny] = gradient(double(obj.mask3d(:,:,frame)));  % 对蒙板图像求梯度
        nx = nx ./ sqrt(nx.^2 + ny.^2); nx(~isfinite(nx)) = 0; %得到边界法向
        ny = ny ./ sqrt(nx.^2 + ny.^2); ny(~isfinite(ny)) = 0; %得到边界法向
         
        D(:,:,frame) = abs(ix.*nx+iy.*ny);
    end
end

