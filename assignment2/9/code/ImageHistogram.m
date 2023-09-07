function array = ImageHistogram(I)
    array = zeros(1, 256);

    for index = 1:numel(I)
        % intensity is from 0 to 255, but MATLAB indexes arrays from 1
        bin = I(index) + 1;
        array(bin) = array(bin) + 1;
    end
end