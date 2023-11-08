function image_output = myPCADenoising2(image_input, sigma_noise, size_patch, size_neighborhood, K)
	size_patch_threshold = (size_patch - 1) / 2;
	size_neighborhood_threshold = (size_neighborhood - 1) / 2;
	[number_of_rows, number_of_columns] = size(image_input);
	image_pad = padarray(image_input, [size_neighborhood_threshold, size_neighborhood_threshold]);
	number_of_patches_in_row = (size_neighborhood - size_patch) + 1;
	number_of_patches = number_of_patches_in_row^2;
	image_output = zeros(size(image_pad));

	patches = zeros(size_patch*size_patch, number_of_patches);
	patches_distance = zeros(number_of_patches, 1);
	for i = 1:number_of_rows
        for j = 1:number_of_columns
        	patches_count = 1;
        	image_neighborhood = image_pad(i-size_neighborhood_threshold:i+size_neighborhood_threshold, j-size_neighborhood_threshold:j+size_neighborhood_threshold);
        	image_patch = image_pad(size_neighborhood_threshold+i-size_patch_threshold:size_neighborhood_threshold+i+size_patch_threshold, size_neighborhood_threshold+j-size_patch_threshold:size_neighborhood_threshold+j+size_patch_threshold);
        	for x = 1:number_of_patches_in_row
        		for y = 1:number_of_patches_in_row
        			temp_patch = image_neighborhood(x:x+size_patch-1, y:y+size_patch-1);
        			patches_distance[patches_count] = norm(temp_patch - image_patch, "fro");
        			patches[patches_count] = reshape(temp_patch, [size_patch*size_patch 1]);
        			patches_count = patches_count + 1;
        		end
        	end
        	[patches_distance_sorted , indices] = sort(patches_distance);
        	patches_nearest = patches(:, indices(1:K));

        	[eigenvectors, singular_values] = eig(patches_nearest * patches_nearest');
        	eigencoefficients = eigenvectors' * eigenvectors;
        end
    end
end