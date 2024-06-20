local suffixes = {
	{ value = 1e9, suffix = "B" },
	{ value = 1e6, suffix = "M" },
	{ value = 1e3, suffix = "K" },
}

return function(number: number): string
	for i = 1, #suffixes do
		if number >= suffixes[i].value then
			local formatted_number = string.format("%.1f%s", number / suffixes[i].value, suffixes[i].suffix)
			formatted_number = string.gsub(formatted_number, "%.0([KMB])", "%1")
			return formatted_number
		end
	end

	return tostring(number)
end

