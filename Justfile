build:
    for moonfile in **/*.moon; do moonc "$moonfile"; done

run: build
    love .
