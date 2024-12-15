#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#define BUFSIZE 4096

typedef struct {
    char** map;
    size_t h;
    size_t w;

    char* instructions;
    size_t instructionLen;
} Input;

Input readInput(const char* file) {
    Input result;
    FILE *fp = fopen(file, "r");
    char line[BUFSIZE];

    result.w = 0;
    result.h = 0;
    while (fgets(line, BUFSIZE, fp)) {
        if (strlen(line) == 1) {
            break;
        }
        result.w = strlen(line) - 1;
        result.h++;
    }

    result.instructionLen = 0;
    while (fgets(line, BUFSIZE, fp)) {
        result.instructionLen += strlen(line) - 1;
    }

    rewind(fp);

    result.instructions = (char*) malloc(sizeof(char) * result.instructionLen);
    result.map = (char**) malloc(sizeof(char*) * result.h);

    for (size_t row = 0; row < result.h; row++) {
        fgets(line, BUFSIZE, fp);

        result.map[row] = (char*) malloc(sizeof(char) * result.w);
        memcpy(result.map[row], line, result.w);
    }

    fgets(line, BUFSIZE, fp);

    size_t i = 0;
    while (fgets(line, BUFSIZE, fp)) {
        memcpy(&result.instructions[i], line, strlen(line) - 1);
        i += strlen(line) - 1;
    }

    fclose(fp);

    return result;
}

int isValid(int y, int x, size_t h, size_t w) {
    return x >= 0 && x < w && y >= 0 && y < h;
}

int hitsWall(char** map, size_t y, size_t x, int dY) {
    if (map[y][x] == '#') {
        return 1;
    }
    if (map[y][x] == '.') {
        return 0;
    }

    if (map[y][x] == '[') {
        return hitsWall(map, y + dY, x, dY) || hitsWall(map, y + dY, x + 1, dY);
    }
    if (map[y][x] == ']') {
        return hitsWall(map, y + dY, x, dY) || hitsWall(map, y + dY, x - 1, dY);
    }

    return hitsWall(map, y + dY, x, dY);
}

void moveLBox(char** map, size_t y, size_t x, int dY) {
    if (map[y][x] == ']') {
        x -= 1;
    }

    if (map[y + dY][x] != '.') {
        moveLBox(map, y + dY, x, dY);
    }

    if (map[y + dY][x + 1] != '.') {
        moveLBox(map, y + dY, x + 1, dY);
    }

    map[y + dY][x] = map[y][x];
    map[y + dY][x+1] = map[y][x+1];
    map[y][x] = '.';
    map[y][x + 1] = '.';
}

void moveBox(char** map, size_t y, size_t x, int dY) {
    if (map[y + dY][x] != '.') {
        moveBox(map, y + dY, x, dY);
    }

    map[y + dY][x] = map[y][x];
    map[y][x] = '.';
}

void moveHor(char instr, char** map, size_t* posY, size_t* posX, size_t h, size_t w) {
    int dX = 0;

    if (instr == '<') {
        dX = -1;
    } else if (instr == '>') {
        dX = 1;
    }

    int newPosY = (int) *posY;
    int newPosX = (int) *posX + dX;

    if (isValid(newPosY, newPosX, h, w) && map[newPosY][newPosX] != '#') {
        if (map[newPosY][newPosX] == '.') {
            *posY = newPosY;
            *posX = newPosX;
        } else {
            int tempY = newPosY;
            int tempX = newPosX + dX;
            while (isValid(tempY, tempX, h, w) && map[tempY][tempX] != '.' && map[tempY][tempX] != '#') {
                tempX += dX;
            }

            if (isValid(tempY, tempX, h, w) && map[tempY][tempX] != '#') {
                int y = tempY;
                int x = tempX;

                while (x != newPosX || y != newPosY) {
                    map[y][x] = map[y][x - dX];
                    x -= dX;
                }
                map[newPosY][newPosX] = '.';

                *posY = newPosY;
                *posX = newPosX;
            }
        }
    }
}

void moveVert(char instr, char** map, size_t* posY, size_t* posX, size_t h, size_t w) {
    int dY = 0;

    if (instr == '^') {
        dY = -1;
    } else if (instr == 'v') {
        dY = 1;
    }

    int newPosY = (int) *posY + dY;
    int newPosX = (int) *posX;

    if (!isValid(newPosY, newPosX, h, w) || map[newPosY][newPosX] == '#') {
        return;
    }
    if (map[newPosY][newPosX] == '.') {
        *posY = newPosY;
        *posX = newPosX;
        return;
    }

    if (!hitsWall(map, newPosY, newPosX, dY)) {
        *posY = newPosY;
        *posX = newPosX;

        if (map[newPosY][newPosX] == 'O') {
            moveBox(map, newPosY, newPosX, dY);
        } else {
            moveLBox(map, newPosY, newPosX, dY);
        }
    }
}

int64_t solve(char** map, size_t posY, size_t posX, size_t h, size_t w, const char* instr, size_t instrLen) {
    for (size_t i = 0; i < instrLen; i++) {
        if (instr[i] == '<' || instr[i] == '>') {
            moveHor(instr[i], map, &posY, &posX, h, w);
        } else {
            moveVert(instr[i], map, &posY, &posX, h, w);
        }
    }

    int64_t result = 0;
    for (size_t row = 0; row < h; row++) {
        for (size_t col = 0; col < w; col++) {
            if (map[row][col] == 'O' || map[row][col] == '[') {
                result += 100 * row + col;
            }
        }
    }

    return result;
}

int64_t part1(const Input input) {
    char** map = (char**) malloc(sizeof(char*) * input.h);
    size_t posY = 0;
    size_t posX = 0;

    for (size_t row = 0; row < input.h; row++) {
        map[row] = (char*) malloc(sizeof(char) * input.w);
        for (size_t col = 0; col < input.w; col++) {
            if (input.map[row][col] != '@') {
                map[row][col] = input.map[row][col];
            } else {
                map[row][col] = '.';
                posY = row;
                posX = col;
            }
        }
    }

    return solve(map, posY, posX, input.h, input.w, input.instructions, input.instructionLen);
}

int64_t part2(const Input input) {
    char** map = (char**) malloc(sizeof(char*) * input.h);
    size_t w = 2 * input.w;
    size_t posY = 0;
    size_t posX = 0;

    for (size_t row = 0; row < input.h; row++) {
        map[row] = (char*) malloc(sizeof(char) * w);
        for (size_t col = 0; col < input.w; col++) {
            if (input.map[row][col] == '#' || input.map[row][col] == '.') {
                map[row][2 * col] = input.map[row][col];
                map[row][2 * col + 1] = input.map[row][col];
            } else if (input.map[row][col] == 'O') {
                map[row][2 * col] = '[';
                map[row][2 * col + 1] = ']';
            } else {
                map[row][2 * col] = '.';
                map[row][2 * col + 1] = '.';

                posY = row;
                posX = 2 * col;
            }
        }
    }

    return solve(map, posY, posX, input.h, w, input.instructions, input.instructionLen);
}

int main() {
    Input input = readInput("../inputs/day15");

    printf("%lld\n", part1(input));
    printf("%lld\n", part2(input));

    return 0;
}