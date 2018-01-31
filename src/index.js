import './styles/nlab-theme.scss';

import * as R from './random-utils.js';
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

function makeTocListItem(txt) {
    let li = document.createElement('li');
    let a = document.createElement('a');
    a.innerHTML = txt;
    stripLinks(a);
    li.appendChild(a);
    return li;
}

function makePage() {
    let g = new NearleyGenerator(nlabGrammar);

    let t = capitalize(g.generate('title', 0.3).trim());

    document.getElementById('title').innerHTML = t;
    document.getElementById('window-title').innerHTML = t + ' in mLab';
    stripLinks(document.getElementById('title'));
    stripLinks(document.getElementById('window-title'));

    document.getElementById('favicon').href = fakeLogo;
    document.getElementById('logo-image').src = fakeLogo;

    let sectionTitles = ['Idea', 'Definitions', 'Properties', 'Examples'];

    if (R.roll(0.5)) sectionTitles.push('Related Concepts');
    if (R.roll(0.4)) sectionTitles.push('Further discussion');

    let toc = document.getElementById('toc');
    for (let title of sectionTitles) {
        let li = makeTocListItem(title);
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
        let header = document.createElement('h1');
        header.innerHTML = (index + 1).toString() + '. ' + title;

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

makePage();
