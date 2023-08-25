function output = JointEntropy(I1, I2)
    [I1_height, I1_width] = size(I1);
    [I2_height, I2_width] = size(I2);

    p1 = ImageHistogram(I1) / (I1_height * I1_width);
    p2 = ImageHistogram(I2) / (I2_height * I2_width);

    % now we have the probability distributions for both images

    output = 0;
    for i = 1:26
        for j = 1:26
            if p1(i) ~= 0 && p2(j) ~= 0
                output = output + (p1(i) * p2(j) * log2(p1(i) * p2(j)));
            end
        end
    end
    output = output * -1;
end