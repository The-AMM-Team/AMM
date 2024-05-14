return function<T>(rarities: {[T]: number}): T

    local randomNumber = Random.new()
    local counter = 0

    for _: T, chance: number in rarities do
        counter += chance
    end

    local chosennumber = randomNumber:NextNumber(0, counter)
    for name: T, chance: number in rarities do
        counter -= chance
        if chosennumber > counter then
            return name
        end
    end

    error("Chance system broke?", 2)
end
