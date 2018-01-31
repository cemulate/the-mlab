# Core ==================================

_ -> " "
link[X] -> "<a href=\".\">" $X "</a>"
strong[X] -> "<strong>" $X "</strong>"
ml[X] -> $X | link[$X]
maybe[X] -> $X | null
either[X,Y] -> $X | $Y

scareQuote[X] -> "\"" $X "\""

# Math ==================================

mathfrak[X] -> "\\mathfrak{" $X "}"
mathcal[X] -> "\\mathcal{" $X "}"
mathscr[X] -> "\\mathscr{" $X "}"
mathbf[X] -> "\\mathbf{" $X "}"

overline[X] -> "\\overline{" $X "}"
widehat[X] -> "\\widehat{" $X "}"
hat[X] -> "\\hat{" $X "}"
dot[X] -> "\\dot{" $X "}"
ddot[X] -> "\\ddot{" $X "}"

decorate[X] -> overline[$X] | widehat[$X] | hat[$X] | dot[$X] | ddot[$X]

paren[X] -> "\\left(" $X "\\right)"
bracket[X] -> "\\left[" $X "\\right]"
group[X] -> paren[$X] | bracket[$X]
maybeGroup[X] -> $X | group[$X]

mLower -> "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "m" | "n" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z" | "\\ell"
mUpper -> "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
mAnyChar -> mLower | mUpper
mAnyCharF -> mathfrak[mAnyChar] | mathcal[mAnyChar] | mathscr[mAnyChar] | mathbf[mAnyChar]
mAnyCharFA -> either[mAnyCharF, either[mAnyCharF, either[mAnyCharF, decorate[mAnyCharF]]]]

mBinOp -> "+" | "-" | "\\cdot" | "\\bullet" | "\\vee" | "\\wedge" | "\\backslash" | "\\circ"
mArrow -> "\\leftarrow" | "\\rightarrow" | "\\leftrightarrow" | "\\Leftarrow" | "\\Rightarrow" | "\\Leftrightarrow"

tex[X] -> "\\(" $X "\\)"
dtex[X] -> "\\[" $X "\\]"

mCategoryish -> mUpper | mAnyCharFA | mAnyCharFA
mFunctorish -> mCategoryish _ mArrow _ mCategoryish

mSmallExpr ->
  "{" mSmallExpr "}_{"  mSmallExpr "}"
| "{" mSmallExpr "}^{" mSmallExpr "}"
| group[mSmallExpr]
| mSmallExpr _ mBinOp _ mSmallExpr
| mCategoryish
| mFunctorish
| mAnyCharFA

mBigOp -> "\\sum" | "\\prod" | "\\coprod" | "\\int" | "\\bigcap" | "\\bigcup" | "\\bigsqcup" | "\\bigvee" | "\\bigwedge" | "\\bigodot" | "\\bigotimes" | "\\bigoplus"
mBigOpFull -> mBigOp "_{" mLower maybe[":" _ mFunctorish] "}" maybe["^{" mAnyCharFA "}"]

mDisplayMath ->
  mBigOpFull _ mSmallExpr
| mBigOpFull _ mSmallExpr _ mBinOp _ mBigOpFull _ mSmallExpr
| group[mBigOpFull _ mSmallExpr] _ "^{" mSmallExpr "}"
| mAnyChar _ group[mBigOpFull _ mSmallExpr]

mDisplayMathStatement ->
  mDisplayMath _ "=" _ mDisplayMath

# Main ==================================

@include "src/grammar/noun-literals.ne"
@include "src/grammar/adjective-literals.ne"

description ->
  ml[adverb] _ description
| ml[adj]
| tex[mSmallExpr] "-" adj

nounPhrase ->
  maybe[description] _ ml[noun] _ maybe[tex[mSmallExpr]]
| "lift" _ maybe[tex[mSmallExpr]] _ "of a" _ maybe[description _] nounPhrase _ maybe[tex[mSmallExpr]]

nounPhrases ->
  maybe[description] _ ml[nouns]
| ml[adj] _ ml[nouns]
| maybe[description] _ ml[nouns] _ "over the" _ ml[noun] _ "of" _ ml[nouns]
| maybe[description] _ ml[nouns] _ "arising from" _ ml[adj] _ ml[nouns]

connective -> "generally" | "moreover" | "therefore" | "it follows that" | "similarly" | "sometimes" | "historically" | "note that" | "as such" | "trivially" | "in a sense" | "certainly" | "conversely" | "informally" | "usually"
openingConnective -> "generally" | "sometimes" | "historically" | "informally" | "in certain contexts"

iffy ->
  "in the case that"
| "when"
| "for situations where"
| "provided that"
| "if"

inTheSense ->
  "in the sense that"
| "in that"
| "corresponding to the fact that"
| "in the following manner: "

plainAlgebraicStructure -> "group" | "ring" | "field" | maybe["free" _] "module" | "vector space"
algebraicStructure -> plainAlgebraicStructure | plainAlgebraicStructure "oid"

vagueWord ->
  "canonical"
| "standard"
| "structure-preserving"
| "visible"
| algebraicStructure "-like"

easyWord -> "obvious" | "trivial" | "evident" | "straightforward" | "definitional" | "elementary"

qualification ->
  dtex[mDisplayMathStatement]
| "all" _ nounPhrases _ "commute"
| "the" _ easyWord _ "diagram commutes"
| "all the" _ easyWord _ "diagrams commute"
| nounPhrases _ "are" _ scareQuote[vagueWord] _ "from" _ tex[mUpper] "'s" _ "point of view"
| "the appropriate" _ nounPhrases _ "are considered"
| tex[mSmallExpr] _ "is" _ description
| "the" _ description _ "object factors through" _ tex[mSmallExpr]

statement ->
  "a" _ nounPhrase _ maybe["satisfying" _ dtex[mDisplayMathStatement]] "is always" _ description maybe[_ iffy _ qualification]
| "a" _ nounPhrase _ "satisfies the" _ description _ "property" maybe[_ iffy _ qualification]
| "a" _ nounPhrase _ "embeds" _ adverb _ "into all" _ description _ nounPhrases
| "a" _ nounPhrase _ "is" _ description _ iffy _ qualification
| "all" _ nounPhrases _ "are" _ description maybe[_ inTheSense _ dtex[mDisplayMathStatement]]
| nounPhrases _ "are" _ nounPhrases

parentheticalBody ->
  "where by" _ "\"" description "\"" _ "we mean" maybe[", of course,"] _ statement
| "meaning" _ tex[mSmallExpr] _ "is" _ description

parenthetical -> " (" parentheticalBody ") "

sentenceBody ->
  iffy _ qualification "," _ statement "."
| iffy _ qualification "," _ "it is said that" _ statement "."
| iffy _ tex[mSmallExpr] _ "is" _ description maybe[parenthetical] "," _ "then so is" _ tex[mSmallExpr]
| nounPhrases _ "may be computed using" _ nounPhrases _ "or" _ nounPhrases either[".", _ "by observing that" dtex[mDisplayMathStatement]]
| nounPhrases _ "may be computed using" _ nounPhrases _ iffy _ qualification "."
| "provided" _ qualification maybe[parenthetical] "," _ statement "."
| "the notion of a" _ nounPhrase _ "is an approximate solution to the problem of finding" _ nounPhrases _ "that satisfy" _ dtex[mDisplayMathStatement] maybe["with respect to" _ ml[nounPhrases]]
| "an analogous definition makes sense in the context of" _ nounPhrases maybe[parenthetical] "."
| "in" _ vagueWord _ nounPhrases maybe[parenthetical] "," _ statement "."

sentence -> maybe[connective "," _] sentenceBody _
openingSentence -> maybe[openingConnective "," _] sentenceBody _

defnBody ->
  "A" _ strong[nounPhrase] _ "is a" _ nounPhrase _ "along with a" _ nounPhrase _ "that satisfies certain properties" maybe[":" _ dtex[mDisplayMathStatement]]
| "A" _ strong[nounPhrase] _ "is a generalization of the notion of a" _ nounPhrase _ "into the context of" _ nounPhrases
| "In the context of" _ nounPhrases "," _ nounPhrases _ "are simply" _ nounPhrases _ "over" _ nounPhrases
| "A" _ nounPhrase _ "is called" _ strong[adj] _ iffy _ qualification
| nounPhrases _ "are said to be" _ strong[adj] _ iffy _ qualification
| "Given" _ tex[mSmallExpr] _ "and" _ tex[mSmallExpr] _ "," _ "a" _ nounPhrase _ "is" _ strong[adj] _ iffy _ qualification

defn -> strong["Definition"] ": " defnBody

title -> maybe[adverb] _ adj _ noun
