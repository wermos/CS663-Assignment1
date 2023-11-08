function image_output = myPCADenoising2(image_input, sigma_noise, size_patch, size_neighborhood, K)
	size_patch_threshold = (size_patch - 1) / 2;
	size_neighborhood_threshold = (size_neighborhood - 1) / 2;
	[number_of_rows, number_of_columns] = size(image_input);
	image_pad = padarray(image_input, [size_neighborhood_threshold, size_neighborhood_threshold]);
	number_of_patches_in_row = (size_neighborhood - size_patch) + 1;
	number_of_patches = number_of_patches_in_row^2;
	image_output = zeros(size(image_input));
	number_of_overlapping_patches = zeros(size(image_input));

	patches = zeros(size_patch*size_patch, number_of_patches);
	patches_distance = zeros(number_of_patches, 1);
	for i = 1:number_of_rows+1-size_patch
        for j = 1:number_of_columns+1-size_patch
        	patches_count = 1;
        	image_neighborhood = image_pad(i:i+size_neighborhood-1, j:j+size_neighborhood-1);
        	image_patch = image_input(i:i+size_patch-1, j:j+size_patch-1);
        	for x = 1:number_of_patches_in_row
        		for y = 1:number_of_patches_in_row
        			temp_patch = image_neighborhood(x:x+size_patch-1, y:y+size_patch-1);
        			patches_distance(patches_count) = norm(temp_patch - image_patch, "fro");
        			patches(:, patches_count) = reshape(temp_patch, [size_patch*size_patch 1]);
        			patches_count = patches_count + 1;
        		end
        	end
        	[patches_distance_sorted , indices] = sort(patches_distance);
        	patches_nearest = patches(:, indices(1:K));

        	[eigenvectors, singular_values] = eig(patches_nearest * patches_nearest');
        	eigencoefficients = eigenvectors' * patches_nearest;
        	eigencoefficients_denoised = zeros(size(eigencoefficients, 1), 1);
        	for k = 1:size_patch*size_patch
    			eigencoefficients_mean = max(0, (1/K * norm(eigencoefficients(k,:))^2 - sigma_noise^2));
    			eigencoefficients_denoised(k) = eigencoefficients(k,1)/(1 + (sigma_noise^2 / eigencoefficients_mean));
        	end
        	patch_reconstructed = reshape(eigenvectors * eigencoefficients_denoised, [size_patch size_patch]);
        	image_output(i:i+size_patch-1, j:j+size_patch-1) = image_output(i:i+size_patch-1, j:j+size_patch-1) + patch_reconstructed;
        	number_of_overlapping_patches(i:i+size_patch-1, j:j+size_patch-1) = number_of_overlapping_patches(i:i+size_patch-1, j:j+size_patch-1) + ones(size_patch, size_patch);
        end
    end
    image_output = image_output ./ number_of_overlapping_patches;
end