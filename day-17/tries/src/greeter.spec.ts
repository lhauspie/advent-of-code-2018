import { sayHello } from "./greeter";
import { expect } from "chai";
import 'mocha';

describe('Hello function', () => {

  it('should return hello Logan', () => {
    const result = sayHello("Logan");
    expect(result).to.equal('Hello Logan!');
  });

});