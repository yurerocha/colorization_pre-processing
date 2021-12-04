include("functions.jl")

imga_name = "einstein_horizontal.jpg"
imgb_name = "julius-rock.jpg"

# Load and convert the image to gray.
imga = Gray.(load("imgs_in/" * imga_name))

# Compute and save the equalized histogram of imga.
img, _, _ = hist_equalization(imga)
save("imgs_out/eq_" * imga_name, img)

# Compute the histogram of imga.
hist_img(imga, "hists_out/hist_" * imga_name * ".png")

# Load and convert image to gray.
# imgb = Gray.(load("imgs_in/" * imgb_name))
imgb = Gray.(load("imgs_in/" * imgb_name))

# Compute and save the histogram of imgb.
hist_img(imgb, "hists_out/hist_" * imgb_name * ".png")

# Perform the histogram matching.
new_imga = hist_matching(imga, imgb)

# Compute and save the histogram of the matched image.
hist_img2(new_imga, "hists_out/hist_new_" * imga_name * ".png")

# Save the histogram matched image.
save("imgs_out/mat_" * imga_name, new_imga)
