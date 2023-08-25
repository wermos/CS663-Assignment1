function array = JointHistogram(I1, I2)
    array = zeros(26, 26);
    for i = 1:numel(I1)
        for j = 1:numel(I2)
            intensity_x = I1(i);
            bin_x = uint8(floor((intensity_x / 10) + 1));
            
            intensity_y = I2(j);
            bin_y = uint8(floor((intensity_y / 10) + 1));
            array(bin_x, bin_y) = array(bin_x, bin_y) + 1;
        end
    end
end