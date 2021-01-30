function [patches, ground_truth_patches, cracks, transparent] = extract_patches(f,crack_3d,ps,alpha, ground_truth)
% a function to extract patches from f and crack locations from crack_3d
% INPUT:
% f is the image (with cracks randomly filled in)
% crack_3d is thelogical crack map (true means crack)
% ps is the patch size (an odd number)
% [m,n] is the size of the original (unpadded) image, i.e. f.
% OUTPUT:
% size(patches) = size(cracks) = [3*ps^2,m*n]
% every column of "patches" will be a patch from f
% every column of "cracks" will be a patch from crack_3d

[m, n, ~] = size(f);
f_pad = padarray(f,[(ps-1)/2 (ps-1)/2],'symmetric'); % symmetric padding to avoid boundary issue
crack_3d_pad = padarray(crack_3d,[(ps-1)/2 (ps-1)/2],'symmetric'); 
alpha_pad = padarray(alpha,[(ps-1)/2 (ps-1)/2],'symmetric');
ground_truth_pad = padarray(ground_truth,[(ps-1)/2 (ps-1)/2],'symmetric');

figure(4); imshow(f_pad); title('padded raw input plus random pixel inpainting')

patches = zeros(3*ps^2, n*m);
ground_truth_patches = zeros(3*ps^2, n*m);
cracks = false(3*ps^2, n*m);% a logical matrix
transparent = false(1,n*m);
% I'm writing a code for easy understanding, this is not the optimal code
% interms of speed
count = 0;
f = waitbar(0, 'Please wait...');
for jj=1:n
    for ii = 1:m
        waitbar
         percent_progress = jj/n;
         to_display = strcat('jj', num2str(jj), ' out of ', num2str(n), ' percent ', num2str(percent_progress));
         waitbar(percent_progress, f, to_display);
        count = count + 1;
        %disp(ii)
        %disp(jj)
        patches(:,count) = reshape(f_pad(ii:ii+ps-1,jj:jj+ps-1,:),[],1);
        alpha_patch = alpha_pad(ii:ii+ps-1,jj:jj+ps-1);
        if mean(alpha_patch(:)) ~= 255
            transparent(:,count) = 1;
        end
        %patches = cat(2, patches, reshape(f_pad(ii:ii+ps-1,jj:jj+ps-1,:),[],1));
        %cracks = cat(2, cracks, reshape(f_pad(ii:ii+ps-1,jj:jj+ps-1,:),[],1));
        
        patches(:,count) = reshape(f_pad(ii:ii+ps-1,jj:jj+ps-1,:),[],1);
        cracks(:,count) = reshape(crack_3d_pad(ii:ii+ps-1,jj:jj+ps-1,:),[],1);
        ground_truth_patches(:, count) =  reshape(ground_truth_pad(ii:ii+ps-1,jj:jj+ps-1,:),[],1);     
    end
end

%selected = size(patches, 2);
%patches = patches(:,2:selected);
%cracks = cracks(:,2:selected);

close(f)