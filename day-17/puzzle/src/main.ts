import {Point, Ground, GroundType} from "./ground";

class Main {
    maxx = 0;
    maxy = 0;
    miny = 100000;
    fileLines = [];
    ground: Ground;
    constructor(filename: String) {
        this.fileLines = require('fs').readFileSync(filename).toString().match(/^.+$/gm);

        for (let line of this.fileLines) {
            if (line.startsWith("x=")) {
                var byX = this.extractByX(line);
                if (byX[0] > this.maxx) {
                    this.maxx = byX[0]
                }
                if (byX[2] > this.maxy) {
                    this.maxy = byX[2]
                }
                if (byX[1] < this.miny) {
                    this.miny = byX[1]
                }
            }
            if (line.startsWith("y=")) {
                var byY = this.extractByY(line);
                if (byY[0] > this.maxy) {
                    this.maxy = byY[0]
                }
                if (byY[0] < this.miny) {
                    this.miny = byY[0]
                }
                if (byY[2] > this.maxx) {
                    this.maxx = byY[2]
                }
            }
        }
        // console.log(`Size of the ground : ${this.maxx}*${this.maxy}`)

        this.ground = new Ground(this.maxx+1, this.maxy+1, new Point(500, 0));
        for (let line of this.fileLines) {
            if (line.startsWith("x=")) {
                var byX = this.extractByX(line);
                this.ground.setClaysByX(byX[0], byX[1], byX[2])
            }
            if (line.startsWith("y=")) {
                var byY = this.extractByY(line);
                this.ground.setClaysByY(byY[0], byY[1], byY[2])
            }
        }
        // this.ground.display();
    }

    extractByX(str: String) {
        return str
                .replace("x=", "")
                .replace(", y=", " ")
                .replace("..", " ")
                .split(" ")
                .map(item => parseInt(item, 10));
    }

    extractByY(str: String) {
        return str
                .replace("y=", "")
                .replace(", x=", " ")
                .replace("..", " ")
                .split(" ")
                .map(item => parseInt(item, 10));
    }

    resolve() {
        var nbSteps = 0; 
        while(this.ground.step()) {
            nbSteps++;
        }
        // console.log(`nbSteps : ${nbSteps}`);
        // console.log(this.ground.ground[this.maxy]);
        // this.ground.display();

        var countAllWater = 0;
        var countRestWater = 0;
        // console.log("Y looping from "+ this.miny + " to " + this.maxy)
        for (var y = this.miny; y <= this.maxy; y++) {
            for (var x = this.ground.topLeftCorner.x; x <= this.ground.bottomRightCorner.x; x++) {
                if (this.ground.ground[y][x] == GroundType.REST || this.ground.ground[y][x] == GroundType.SPRING) {
                    if (this.ground.ground[y][x] == GroundType.REST) {
                        countRestWater++;
                    }
                    countAllWater++;
                }
            }
        }
        console.log(countAllWater); // 39877
        console.log(countRestWater); // 33291
    }
}

var main = new Main("input.txt");
main.resolve();
