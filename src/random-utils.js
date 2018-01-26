let roll = probability => Math.random() < probability;

function randomChoice(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

function randomInRange(n, m) {
    return n + Math.floor(Math.random() * (m - n));
}

export { roll, randomChoice, randomWeightedChoice, randomInRange, genWithExponentialBackoff };
