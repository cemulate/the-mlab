let roll = probability => Math.random() < probability;

function randomChoice(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

function randomInRange(n, m) {
    return n + Math.floor(Math.random() * (m - n));
}

// Written to be fast
// summing w/ for loop is TEN TIMES faster than .reduce()
function randomWeightedChoice(arr, weights) {
    let sum = 0;
    for (let i = 0; i < weights.length; i ++) {
        sum += weights[i];
    }
    let r = Math.random() * sum;
    for (let i = 0; i < weights.length; i ++) {
        r -= weights[i];
        if (r < 0) return arr[i];
    }
}

function* genWithExponentialBackoff(p, fn) {
    let prob = 1;
    while (true) {
        if (roll(prob)) {
            yield fn();
        } else {
            break;
        }
        prob = prob * p;
    }
}

export { roll, randomChoice, randomWeightedChoice, randomInRange, genWithExponentialBackoff };
