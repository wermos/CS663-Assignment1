function array = ImageHistogram(I)
    array = zeros(1, 26);
    for index = 1:numel(I)
        intensity = I(index);
        bin = uint8(floor((intensity / 10) + 1));
        array(bin) = array(bin) + 1;
    end
end