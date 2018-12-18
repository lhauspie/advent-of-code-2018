import {Point, GroundType, Ground} from  "./ground";
import { expect } from "chai"; 
import "mocha";
 
describe("Point", () => {
  it("goDown increase Y", () => {
    const point = new Point(1,0);
    point.goDown();
    expect(new Point(1,1)).to.deep.equal(point); 
  });
  it("goUp decrease Y", () => {
    const point = new Point(1,1);
    point.goUp();
    expect(new Point(1,0)).to.deep.equal(point);
  });
  it("goRight increase X", () => {
    const point = new Point(1,0);
    point.goRight();
    expect(new Point(2,0)).to.deep.equal(point);
  });
  it("goLeft decrease X", () => {
    const point = new Point(1,0);
    point.goLeft();
    expect(new Point(0,0)).to.deep.equal(point);
  });
});

describe("Ground", () => {
  it("initialized with only Sand", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    expect([
      ['.', '.', '|', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.']
    ]).to.deep.equal(ground.ground);
  });
  
  it("initialized with only Sand and one Clay", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    ground.setClay(new Point(2, 1))
    expect([
      ['.', '.', '|', '.', '.'],
      ['.', '.', '#', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.']
    ]).to.deep.equal(ground.ground);
  });
 
  it("initialized with a range of X", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    ground.setClaysByX(1, 1, 4);
    expect([
      ['.', '.', '|', '.', '.'],
      ['.', '#', '.', '.', '.'],
      ['.', '#', '.', '.', '.'],
      ['.', '#', '.', '.', '.'],
      ['.', '#', '.', '.', '.']
    ]).to.deep.equal(ground.ground);
  });
 
  it("initialized with a range of Y", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    ground.setClaysByY(1, 1, 4);
    expect([
      ['.', '.', '|', '.', '.'],
      ['.', '#', '#', '#', '#'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.']
    ]).to.deep.equal(ground.ground);
  });
});

describe("Ground with no groundwater", () => {
  it("one step with one clay", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    ground.setClay(new Point(2, 1));
    ground.step();
    expect([
      ['.', '|', '|', '|', '.'],
      ['.', '.', '#', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.']
    ]).to.deep.equal(ground.ground);
  });

  it("two steps with one clay", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    ground.setClay(new Point(2, 1));
    ground.step();
    ground.step();
    expect([
      ['.', '|', '|', '|', '.'],
      ['.', '|', '#', '|', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.']
    ]).to.deep.equal(ground.ground);
  });

  it("three steps with one clay", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    ground.setClay(new Point(2, 1));
    ground.step();
    ground.step();
    ground.step();
    expect([
      ['.', '|', '|', '|', '.'],
      ['.', '|', '#', '|', '.'],
      ['.', '|', '.', '|', '.'],
      ['.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.']
    ]).to.deep.equal(ground.ground);
  });
});

describe("Ground with simple groundwater", () => {
  it("can detect a single spring that is jailed and then transform to rest water", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    ground.setClay(new Point(1, 1));
    ground.setClay(new Point(1, 2));
    ground.setClay(new Point(1, 3));
    ground.setClay(new Point(1, 4));
    ground.setClay(new Point(3, 1));
    ground.setClay(new Point(3, 2));
    ground.setClay(new Point(3, 3));
    ground.setClay(new Point(3, 4));
    ground.setClay(new Point(2, 4));
    // check the starting point
    expect([
      ['.', '.', '|', '.', '.'],
      ['.', '#', '.', '#', '.'],
      ['.', '#', '.', '#', '.'],
      ['.', '#', '.', '#', '.'],
      ['.', '#', '#', '#', '.']
    ]).to.deep.equal(ground.ground);

    ground.step();
    ground.step();
    ground.step();
    
    expect([
      ['.', '|', '|', '|', '.'],
      ['.', '#', '~', '#', '.'],
      ['.', '#', '~', '#', '.'],
      ['.', '#', '~', '#', '.'],
      ['.', '#', '#', '#', '.']
    ]).to.deep.equal(ground.ground);
    // expect(true).to.equal(ground.transformJailedSpringToRestWater(new Point(2,3)));
  });

  it("can detect a large spring that is jailed and then transform to rest water", () => {
    const ground = new Ground(5, 5, new Point(2,0));
    ground.setClay(new Point(0, 1));
    ground.setClay(new Point(0, 2));
    ground.setClay(new Point(0, 3));
    ground.setClay(new Point(0, 4));
    ground.setClay(new Point(4, 1));
    ground.setClay(new Point(4, 2));
    ground.setClay(new Point(4, 3));
    ground.setClay(new Point(4, 4));
    ground.setClay(new Point(1, 4));
    ground.setClay(new Point(2, 4));
    ground.setClay(new Point(3, 4));

    // check the initial state
    expect([
      ['.', '.', '|', '.', '.'],
      ['#', '.', '.', '.', '#'],
      ['#', '.', '.', '.', '#'],
      ['#', '.', '.', '.', '#'],
      ['#', '#', '#', '#', '#']
    ]).to.deep.equal(ground.ground);

    ground.step();
    ground.step();
    ground.step();
    ground.step();
    
    // check the final state
    expect([
      ['.', '|', '|', '|', '.'],
      ['#', '~', '~', '~', '#'],
      ['#', '~', '~', '~', '#'],
      ['#', '~', '~', '~', '#'],
      ['#', '#', '#', '#', '#']
    ]).to.deep.equal(ground.ground);
  });

  it("steps until the end", () => {
    const ground = new Ground(10, 10, new Point(4,0));
    ground.setClaysByX(1, 1, 3);
    ground.setClaysByX(5, 1, 3);
    ground.setClaysByX(4, 5, 8);
    ground.setClaysByX(9, 5, 8);
    ground.setClaysByY(3, 2, 4);
    ground.setClaysByY(8, 5, 8);

    // check the initial state
    expect([
      ['.', '.', '.', '.', '|', '.', '.', '.', '.', '.'],
      ['.', '#', '.', '.', '.', '#', '.', '.', '.', '.'],
      ['.', '#', '.', '.', '.', '#', '.', '.', '.', '.'],
      ['.', '#', '#', '#', '#', '#', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '#', '.', '.', '.', '.', '#'],
      ['.', '.', '.', '.', '#', '.', '.', '.', '.', '#'],
      ['.', '.', '.', '.', '#', '.', '.', '.', '.', '#'],
      ['.', '.', '.', '.', '#', '#', '#', '#', '#', '#'],
      ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.']
    ]).to.deep.equal(ground.ground);

    while(ground.step()) {
    }
    // ground.display();
    
    // check the final state
    expect([
      ['|', '|', '|', '|', '|', '|', '|', '.', '.', '.'],
      ['|', '#', '~', '~', '~', '#', '|', '.', '.', '.'],
      ['|', '#', '~', '~', '~', '#', '|', '.', '.', '.'],
      ['|', '#', '#', '#', '#', '#', '|', '.', '.', '.'],
      ['|', '.', '.', '|', '|', '|', '|', '|', '|', '|'],
      ['|', '.', '.', '|', '#', '~', '~', '~', '~', '#'],
      ['|', '.', '.', '|', '#', '~', '~', '~', '~', '#'],
      ['|', '.', '.', '|', '#', '~', '~', '~', '~', '#'],
      ['|', '.', '.', '|', '#', '#', '#', '#', '#', '#'],
      ['|', '.', '.', '|', '.', '.', '.', '.', '.', '.']
    ]).to.deep.equal(ground.ground);
  });
});

