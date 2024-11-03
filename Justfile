build:
    for moonfile in *.moon; do moonc "$moonfile"; done
    for moonfile in **/*.moon; do moonc "$moonfile"; done

run: build
    love .
