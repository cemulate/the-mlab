import './styles/nlab-theme.scss';

import seedrandom from 'seedrandom';
import { RandomUtil, seedToTitle, titleToSeed } from './random-utils.js';
import nlabGrammar from './grammar/nlab.ne';
import NearleyGenerator from 'nearley-generator';

import fakeLogo from './img/fakelogo.png';

function stripLinks(el) {
    while (el.children.length > 0) {
        el.children[0].replaceWith(el.children[0].innerText);
    }
}

function capitalize(s) {
    return s.charAt(0).toUpperCase() + s.slice(1);
}

function makeTocListItem(txt, anchor) {
    let li = document.createElement('li');
    let a = document.createElement('a');
    a.innerHTML = txt;
    if (anchor) a.href = '#' + anchor
    stripLinks(a);
    li.appendChild(a);
    return li;
}

function makePage(seed = null) {
    let rng = null;
    let title = null;
    if (seed == null) {
        // Generate a title randomly.
        let tGenerator = new NearleyGenerator(nlabGrammar);
        title = tGenerator.generate('title', 0.3).trim();

        // Use that title (plus a salt) as the seed for the remainder of the page
        seed = titleToSeed(title);
        rng = seedrandom(seed);

        location.hash = seed;
    } else {
        // Find out what the title was,
        title = seedToTitle(seed);
        // Generate an identical page using the seed.
        rng = seedrandom(seed);
    }

    let g = new NearleyGenerator(nlabGrammar, rng)
    let R = new RandomUtil(rng);

    let capTitle = capitalize(title);
    document.getElementById('title').innerHTML = capTitle
    document.getElementById('window-title').innerHTML = capTitle + ' in mLab';
    stripLinks(document.getElementById('title'));
    stripLinks(document.getElementById('window-title'));

    document.getElementById('favicon').href = fakeLogo;
    document.getElementById('logo-image').src = fakeLogo;

    let sectionTitles = ['Idea', 'Definitions', 'Properties', 'Examples'];

    if (R.roll(0.5)) sectionTitles.push('Related Concepts');
    if (R.roll(0.4)) sectionTitles.push('Further discussion');

    let toc = document.getElementById('toc');
    for (let [index, title] of sectionTitles.entries()) {
        let li = makeTocListItem(title, 'section-' + (index + 1).toString());
        if (R.roll(0.5)) {
            let innerList = document.createElement('ul');
            let n = R.randomInRange(2, 5);
            for (let i = 0; i < n; i ++) {
                let content = capitalize(g.generate('nounPhrases', 0.3).trim());
                let li = makeTocListItem(content);
                innerList.appendChild(li);
            }
            li.appendChild(innerList);
        }
        toc.appendChild(li);
    }

    let main = document.getElementById('content');

    for (let [index, title] of sectionTitles.entries()) {
        let header = document.createElement('h2');
        header.innerHTML = (index + 1).toString() + '. ' + title;
        header.id = 'section-' + (index + 1).toString();

        main.appendChild(header);

        let nSentences = R.randomInRange(3, 7);

        let defnProbs = [0.8, 0.5, 0.15];
        let listProbs = [0.7, 0.3];
        let [defns, lists] = [0, 0];

        let runningPar = document.createElement('p');
        for (let i = 0; i < nSentences; i ++) {
            let span = document.createElement('span');
            span.innerHTML = capitalize(g.generate((i === 0) ? 'openingSentence' : 'sentence', 0.6).trimLeft());
            runningPar.appendChild(span);

            if (defns < defnProbs.length && R.roll(defnProbs[defns])) {
                main.appendChild(runningPar);
                runningPar = document.createElement('p');

                let dp = document.createElement('p');
                dp.innerHTML = g.generate('defn', 0.5);
                main.appendChild(dp);
                defns ++;
            }

            if (lists < listProbs.length && R.roll(listProbs[lists])) {
                let list = document.createElement('ul');
                let nItems = R.randomInRange(2, 5);
                for (let i = 0; i < nItems; i ++) {
                    let li = document.createElement('li');
                    li.innerHTML = capitalize(g.generate('statement', 0.5).trim());
                    list.appendChild(li);
                }
                runningPar.appendChild(list);
                lists ++;
            }
        }

        main.appendChild(runningPar);
    }
}

if (location.hash.length == 0) {
    makePage();
} else {
    makePage(location.hash.slice(1));
}
