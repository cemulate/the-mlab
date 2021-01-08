class RandomUtil {
    constructor(rng = null) {
        this.rng = rng != null ? rng : Math.random.bind();
    }

    roll(prob) {
        return this.rng() < prob;
    }

    randomChoice(arr) {
        return arr[Math.floor(this.rng() * arr.length)];
    }
    
    randomInRange(n, m) {
        return n + Math.floor(this.rng() * (m - n));
    }
}

const ALPHANUMERIC = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

function titleToSeed(title) {
    let r = new RandomUtil();
    let salt = [0, 1, 2, 3].map(() => r.randomChoice(ALPHANUMERIC)).join('');
    return salt + '-' + title.replaceAll(' ', '+');
}

function seedToTitle(hash) {
    // Strip the salt off the front
    let t = hash.slice(5);
    return t.replaceAll('+', ' ');
}

export { RandomUtil, titleToSeed, seedToTitle };
