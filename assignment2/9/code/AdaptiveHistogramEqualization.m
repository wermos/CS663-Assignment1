function cropped_img = AdaptiveHistogramEqualization(I, block_size)
    [height, width] = size(I);

    pad_length = (block_size - 1) / 2;

    for i = 1:height
        for j = 1:width
            left = max(1, i - pad_length);
            right = min(i + pad_length, height);

            top = max(1, j - pad_length);
            bottom = min(j + pad_length, width);

            img_hist = ImageHistogram(I(left:right, top:bottom));

            cdf = cumsum(img_hist) / (block_size * block_size);

            I(i, j) = round(255 * cdf(I(i, j) + 1));
        end
    end

    cropped_img = I(pad_length:height-pad_length-1,pad_length:width-pad_length-1);
end