LC1 = imread("LC1.png");
LC2 = imread("LC2.jpg");

global_eq_LC1 = histeq(LC1, 256);
global_eq_LC2 = histeq(LC2, 256);

imwrite(global_eq_LC1, "global_histogram_LC1.jpg");
imwrite(global_eq_LC2, "global_histogram_LC2.jpg");

% figure
% imhist(LC1, 256)

LC1 = double(LC1);
LC2 = double(LC2);

smol_block_size = 7;
smol_LC1 = padarray(LC1, [3 3], "symmetric", "both");
smol_LC2 = padarray(LC2, [3 3], "symmetric", "both");

enhanced_LC1 = AdaptiveHistogramEqualization(smol_LC1, smol_block_size);
enhanced_LC2 = AdaptiveHistogramEqualization(smol_LC2, smol_block_size);

imwrite(uint8(enhanced_LC1), "smol_enhanced_LC1.png");
imwrite(uint8(enhanced_LC2), "smol_enhanced_LC2.png");

medium_block_size = 31;
medium_LC1 = padarray(LC1, [15 15], "symmetric", "both");
medium_LC2 = padarray(LC2, [15 15], "symmetric", "both");

enhanced_LC1 = AdaptiveHistogramEqualization(medium_LC1, medium_block_size);
enhanced_LC2 = AdaptiveHistogramEqualization(medium_LC2, medium_block_size);

imwrite(uint8(enhanced_LC1), "medium_enhanced_LC1.png");
imwrite(uint8(enhanced_LC2), "medium_enhanced_LC2.png");

big_block_size = 51;
big_LC1 = padarray(LC1, [25 25], "symmetric", "both");
big_LC2 = padarray(LC2, [25 25], "symmetric", "both");

enhanced_LC1 = AdaptiveHistogramEqualization(big_LC1, big_block_size);
enhanced_LC2 = AdaptiveHistogramEqualization(big_LC2, big_block_size);

imwrite(uint8(enhanced_LC1), "big_enhanced_LC1.png");
imwrite(uint8(enhanced_LC2), "big_enhanced_LC2.png");

chonky_block_size = 71;
chonky_LC1 = padarray(LC1, [35 35], "symmetric", "both");
chonky_LC2 = padarray(LC2, [35 35], "symmetric", "both");

enhanced_LC1 = AdaptiveHistogramEqualization(chonky_LC1, chonky_block_size);
enhanced_LC2 = AdaptiveHistogramEqualization(chonky_LC2, chonky_block_size);

imwrite(uint8(enhanced_LC1), "chonky_enhanced_LC1.png");
imwrite(uint8(enhanced_LC2), "chonky_enhanced_LC2.png");