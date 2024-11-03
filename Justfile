build:
    find -name '*.moon' -print0 | xargs -0 moonc

run: build
    love .
