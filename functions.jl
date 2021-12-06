using Images, ImageView, FileIO, Plots

function hist_equalization(mat)
    R, C = size(mat)
    L = 256
    minr = maxr = mat[1, 1]

    nl = zeros(Int, L)
    for i in 1:R, j in 1:C
        l = round(Int, mat[i, j].val * (L - 1)) # Convert to Int, ranging from 0 to 255.

        l = min(l, L - 1)
        l = max(l, 1)

        nl[l] += 1
    end

    s = []
    for r in 1:L
        push!(s, round(Int, (L - 1) / (R * C) * sum([nl[l] for l in 1:r])))
    end

    k = 1
    new_img = Array{Float64, 2}(undef, R, C)
    for i in 1:R, j in 1:C
        l = round(Int, mat[i, j].val * (L - 1))

        l = min(l, L - 1)
        l = max(l, 1)

        new_img[i, j] = s[l] / (L - 1)
        k += 1
    end

    return new_img, s, nl
end

function hist_matching(img_a, img_b)
    eq_img_a, s_a, nl_a = hist_equalization(img_a)
    eq_img_b, s_b, nl_b = hist_equalization(img_b)

    R, C = size(img_a)
    L = 256
    new_img = Array{Float64, 2}(undef, R, C)
    for (i, v) in enumerate(img_a)
        r = round(Int, v.val * (L - 1)) # Convert to Int, ranging from 0 to 255.

        r = min(r, L - 1)
        r = max(r, 1)

        r_closest = find_closest(s_a[r], s_b)
        new_img[i] = r_closest / (L - 1)
    end

    return new_img
end

function find_closest(value, vector)
    min = abs(vector[1] - value)
    i_cl = 1
    for (i, v) in enumerate(vector)
        if abs(v - value) < min - 0.00001
            min = abs(v - value)
            i_cl = i
        end
    end

    return i_cl
end

function hist_img(img, figname)
    L = 256
    s = reshape(img, 1, length(img))
    s = map(x -> floor(Int, x.val * (L - 1)), s)
    nl = zeros(Int, L)
    [nl[l + 1] += 1 for l in s]
    p = plot(0:(L - 1), nl, xaxis="Nível de cinza", yaxis="Quantidade de pixels com nível de cinza", legend=false)
    display(p)
    savefig(p, figname)
end

function hist_img2(img, figname)
    L = 256
    s = reshape(img, 1, length(img))
    s = map(x -> floor(Int, x * (L - 1)), s)
    nl = zeros(Int, L)
    [nl[l + 1] += 1 for l in s]
    p = plot(0:(L - 1), nl, xaxis="Nível de cinza", yaxis="Quantidade de pixels com nível de cinza", legend=false)
    display(p)
    savefig(p, figname)
end

function rgb_yiq(img_rgb)
   m, n = size(img_rgb)
   img_yiq = Array{Any}(undef, m, n)

   for j in 1:m, k in 1:n
      c = img_rgb[j, k]
      y = 0.299 * red(c) + 0.587 * green(c) + 0.114 * blue(c)
      i = 0.596 * red(c) - 0.274 * green(c) - 0.322 * blue(c)
      q = 0.211 * red(c) - 0.523 * green(c) + 0.312 * blue(c)
      img_yiq[j, k] = YIQ(y, i, q)
   end

   return img_yiq
end
