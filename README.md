The mLab
================

This is a parody of [the nLab](https://ncatlab.org/nlab/show/HomePage), a wiki for collaborative work on category theory and higher category theory.
As anyone who's visited is probably aware, the jargon can be absolutely *impenetrable* for the uninitiated -- thus, the idea for this project was born!

How it works
===============

This project uses my package [nearley-generator](https://github.com/cemulate/nearley-generator), a module that can turn a [Nearley grammar](https://nearley.js.org/) into an efficient and controllable fake text generator.
The grammar file for this site can be found at [/src/grammar/nlab.ne](/src/grammar/nlab.ne)

Inspiration
==============

This project was inspired by [Lokaltog](https://github.com/Lokaltog)'s [fake git man page generator](https://git-man-page-generator.lokaltog.net/)
