export enum GroundType {
    SAND = '.',
    CLAY = '#',
    REST = '~',
    SPRING = '|'
}

export class Point {
    x: number;
    y: number;
    constructor(x:number, y:number) {
        this.x = x;
        this.y = y;
    }

    up(): Point {
        return new Point(this.x, this.y-1);
    }
    down(): Point {
        return new Point(this.x, this.y+1);
    }
    left(): Point {
        return new Point(this.x-1, this.y);
    }
    right(): Point {
        return new Point(this.x+1, this.y);
    }

    goUp() { this.y -= 1; return this; }
    goDown() { this.y += 1; return this; }
    goLeft() { this.x -= 1; return this; }
    goRight() { this.x += 1; return this; }

    toString() { return `${this.x}|${this.y}`;}
}

export class Ground {
    topLeftCorner: Point;
    bottomRightCorner: Point;
    ground: GroundType[][];
    constructor(width: number, height: number, spring: Point) {
        // at the beginning, the water flows only on a little square meter
        this.topLeftCorner = new Point(spring.x, spring.y)
        this.bottomRightCorner = new Point(spring.x, spring.y)
        this.ground = [];
        for (var y: number = 0; y < height; y++) {
            this.ground[y] = [];
            for (var x: number = 0; x < width; x++) {
                this.ground[y][x] = GroundType.SAND;
            }
        }
        this.ground[spring.y][spring.x] = GroundType.SPRING;
    }

    setClay(clay: Point) {
        this.ground[clay.y][clay.x] = GroundType.CLAY;
    }

    setClaysByX(x: number, miny:number, maxy: number) {
        for (var y = miny; y<=maxy; y++) {
            this.ground[y][x] = GroundType.CLAY;
        }
    }
    
    setClaysByY(y: number, minx:number, maxx: number) {
        for (var x = minx; x<=maxx; x++) {
            this.ground[y][x] = GroundType.CLAY;
        }
    }
    
    step() {
        var springContinuesToFlow = false;
        // console.log(`topLeftCorner ${this.topLeftCorner.x}|${this.topLeftCorner.y}`);
        // console.log(`bottomRightCorner ${this.bottomRightCorner.x}|${this.bottomRightCorner.y}`);
        // loop over the water zone in bottom-up
        var new_topLeftCorner = new Point(this.topLeftCorner.x, this.topLeftCorner.y);
        var new_bottomRightCorner = new Point(this.bottomRightCorner.x, this.bottomRightCorner.y);

        // console.log(`for y from ${this.bottomRightCorner.y} to ${this.topLeftCorner.y} included`)
        for (var y = this.bottomRightCorner.y; y >= this.topLeftCorner.y; y-- ) {
            // console.log(`for x from ${this.topLeftCorner.x} to ${this.bottomRightCorner.x} included`)
            for (var x = this.topLeftCorner.x; x <= this.bottomRightCorner.x; x++ ) {
                // this.display();
                var currentCell = new Point(x, y);
                // console.log(`is the currentcell ${currentCell.x}|${currentCell.y} a Spring ?`)
                if (this.is(currentCell, GroundType.SPRING)) {
                    // console.log("is the currentcell a Spring => YES")
                    var down = currentCell.down();
                    if (this.is(down, GroundType.SAND)) {
                        // console.log(currentCell.toString() + " => flowing down")
                        springContinuesToFlow = true;
                        this.ground[down.y][down.x] = GroundType.SPRING;
                        new_bottomRightCorner.y = Math.max(new_bottomRightCorner.y, down.y); // increase water zone
                        // here the spring is just flowing down, so we want to check if the SPRING becomes a REST
                        this.transformJailedSpringToRestWater(down)
                        // this.display();
                    }
        
                    if (this.is(down, GroundType.CLAY) || this.is(down, GroundType.REST)) {
                        var left = currentCell.left();
                        var right = currentCell.right();
                        if (this.is(left, GroundType.SAND)) {
                            springContinuesToFlow = true;
                            // console.log(currentCell.toString() + " => flowing left");
                            this.ground[left.y][left.x] = GroundType.SPRING;
                            new_topLeftCorner.x = Math.min(new_topLeftCorner.x, left.x); // increase water zone to the left
                            // here the spring is just flowing left, so we want to check if the SPRING becomes a REST
                            // this.display();
                        }
                        if (this.is(right, GroundType.SAND)) {
                            springContinuesToFlow = true;
                            // console.log(currentCell.toString() + " => flowing right");
                            this.ground[right.y][right.x] = GroundType.SPRING;
                            new_bottomRightCorner.x = Math.max(new_bottomRightCorner.x, right.x); // increase water zone to the right

                            // here the spring is just flowing right, so we want to check if the SPRING becomes a REST
                            // this.display();
                        }
                        this.transformJailedSpringToRestWater(currentCell);
                    }
                }
            }
        }
        this.topLeftCorner = new_topLeftCorner
        this.bottomRightCorner = new_bottomRightCorner
        // this.display();
        if (!springContinuesToFlow) {
            // console.log("nothing to do on " + currentCell.toString());
        }

        return springContinuesToFlow;
    }

    transformJailedSpringToRestWater(spring: Point) {
        // don't try to evaluate the jailing because the spring is close to the ground limits
        if (spring.y >= this.ground.length-1 || spring.x <= 0 || spring.x >= this.ground[spring.y].length-1) {
            return false;
        }
        // search the leftmost spring from the param spring
        var leftmostSpring: Point = new Point(spring.x, spring.y)
        var downCellContent = this.ground[leftmostSpring.y+1][leftmostSpring.x]
        var leftCellContent = this.ground[leftmostSpring.y][leftmostSpring.x-1]
        while ((downCellContent == GroundType.CLAY || downCellContent == GroundType.REST) && leftCellContent == GroundType.SPRING) {
            leftmostSpring.goLeft();
            downCellContent = this.ground[leftmostSpring.y+1][leftmostSpring.x]
            leftCellContent = this.ground[leftmostSpring.y][leftmostSpring.x-1]
        }

        // this.display()

        // search the rightmost spring from the param spring
        var rightmostSpring: Point = new Point(spring.x, spring.y)
        var downCellContent = this.ground[rightmostSpring.y+1][rightmostSpring.x]
        var rightCellContent = this.ground[rightmostSpring.y][rightmostSpring.x+1]
        while ((downCellContent == GroundType.CLAY || downCellContent == GroundType.REST) && rightCellContent == GroundType.SPRING) {
            rightmostSpring.goRight();
            downCellContent = this.ground[rightmostSpring.y+1][rightmostSpring.x]
            rightCellContent = this.ground[rightmostSpring.y][rightmostSpring.x+1]
        }

        // console.log("Found leftmost and right most spring")
        // console.log(leftmostSpring)
        // console.log(rightmostSpring)
        var jailed = false
        if (this.is(leftmostSpring.left(), GroundType.CLAY) && this.is(rightmostSpring.right(), GroundType.CLAY)
         && this.isNot(leftmostSpring.down(), GroundType.SAND) && this.isNot(leftmostSpring.down(), GroundType.SAND)) {
            // console.log("IS JAILED")
            jailed = true;
            // console.log("looping from "+ leftmostSpring.x + " to " + rightmostSpring.x)
            for (var x = leftmostSpring.x; x <= rightmostSpring.x ; x++) {
                this.ground[spring.y][x] = GroundType.REST;         
            }
        }
        return jailed;
    }

    is(point: Point, gt: GroundType) {
        if (point.y >= this.ground.length || point.x < 0 || point.x >= this.ground[point.y].length) {
            return false;
        }
        return this.ground[point.y][point.x] == gt;
    }

    isNot(point: Point, gt: GroundType) { 
        if (point.y >= this.ground.length || point.x < 0 || point.x >= this.ground[point.y].length) {
            return true;
        }
        return this.ground[point.y][point.x] != gt;
    }

    display() {
        console.log("------------------");
        this.ground.forEach(row => {
            var strRow = ""
            row.forEach(cell => {
                strRow += cell;
            });
            console.log(strRow);
        });
        console.log("------------------");
    }

    clean() {
        
    }
}

