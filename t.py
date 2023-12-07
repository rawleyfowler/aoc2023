        if seed_range[0] < source_start and seed_range[0] + seed_range[1] > source_start and seed_range[0] + seed_range[1] <= source_start + length:
            left_range = (seed_range[0], source_start - seed_range[0])
            right_range = (dest_start, seed_range[1] - left_range[1])
            expanded = expanded + expand(mappers, mapping[0], dest, right_range) + expand(mappers, source, dest, left_range)
            break
        elif seed_range[0] >= source_start and seed_range[0] < source_start + length and seed_range[0] + seed_range[1] > source_start + length:
            left_range = (dest_start + seed_range[0] - source_start, source_start + length - seed_range[0])
            right_range = (source_start + length, seed_range[0] + seed_range[1] - source_start - length)
            expanded = expanded + expand(mappers, mapping[0], dest, left_range) + expand(mappers, source, dest, right_range)
            break
        elif seed_range[0] >= source_start and seed_range[0] + seed_range[1] <= source_start + length:
            expanded = expanded + expand(mappers, mapping[0], dest, (dest_start + seed_range[0] - source_start, seed_range[1]))
            break
        elif seed_range[0] < source_start and seed_range[0] + seed_range[1] > source_start + length:
            left_range = (seed_range[0], source_start - seed_range[0])
            right_range = (source_start + length, seed_range[0] + seed_range[1] - source_start - length)
            middle_range = (dest_start, length)
            expanded = expanded + expand(mappers, source, dest, right_range) + expand(mappers, mapping[0], dest, middle_range) + expand(mappers, source, dest, left_range)
            break