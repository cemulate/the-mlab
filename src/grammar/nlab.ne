# Core ==================================

_ -> " "
link[X] -> "<a href=\"#\">" $X "</a>"
strong[X] -> "<strong>" $X "</strong>"
ml[X] -> $X | link[$X]
maybe[X] -> $X | null

scareQuote[X] -> "\"" $X "\""

# Math ==================================

mathfrak[X] -> "\\mathfrak{" $X "}"
mathcal[X] -> "\\mathcal{" $X "}"
mathscr[X] -> "\\mathscr{" $X "}"
mathbf[X] -> "\\mathbf{" $X "}"

paren[X] -> "\\left(" $X "\\right)"
bracket[X] -> "\\left[" $X "\\right]"
group[X] -> paren[$X] | bracket[$X]

mLower -> "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "m" | "n" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z" | "\\ell"
mUpper -> "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
mAnyChar -> mLower | mUpper
mAnyCharF -> mathfrak[mAnyChar] | mathcal[mAnyChar] | mathscr[mAnyChar] | mathbf[mAnyChar]

mBinOp -> "+" | "-" | "\\cdot" | "\\bullet" | "\\vee" | "\\wedge" | "\\backslash" | "\\circ"
mArrow -> "\\leftarrow" | "\\rightarrow" | "\\leftrightarrow" | "\\Leftarrow" | "\\Rightarrow" | "\\Leftrightarrow"

tex[X] -> "\\(" $X "\\)"
dtex[X] -> "\\[" $X "\\]"

mCategoryish -> mUpper | mathcal[mUpper] | mathbf[mUpper]
mFunctorish -> mCategoryish _ mArrow _ mCategoryish

mSmallExpr ->
  "{" mSmallExpr "}_{"  mSmallExpr "}"
| "{" mSmallExpr "}^{" mSmallExpr "}"
| group[mSmallExpr]
| mSmallExpr _ mBinOp _ mSmallExpr
| mCategoryish
| mFunctorish
| mAnyCharF

# Main ==================================

@include "src/grammar/noun-literals.ne"
@include "src/grammar/adjective-literals.ne"

description ->
  ml[adverb] _ description
| ml[adj]
| tex[mSmallExpr] "-" adj

nounPhrase ->
  maybe[description] _ ml[noun] _ maybe[tex[mSmallExpr]]

nounPhrases ->
  ml[nouns]
| ml[adj] _ ml[nouns]
| ml[nouns] _ "over the" _ ml[noun] _ "of" _ ml[nouns]

defn -> strong["Definition"] ": " defnBody
defnBody ->
  "A" _ strong[nounPhrase] _ "is a" _ nounPhrase _ "along with a" _ nounPhrase _ "that satisfies certain properties"
| "A" _ strong[nounPhrase] _ "is a generalization of the notion of a" _ nounPhrase _ "into the context of" _ nounPhrases
| "In the context of" _ nounPhrases "," _ nounPhrases _ "are simply" _ nounPhrases _ "over" _ nounPhrases

connective -> "Generally" | "Moreover" | "Therefore" | "It follows that" | "Similarly" | "Sometimes" | "Historically" | "Note that" | "As such" | "Trivially" | "In a sense" | "Certainly" | "Conversely"

iffy ->
  "in the case that"
| "when"
| "for situations where"
| "provided that"

plainAlgebraicStructure -> "group" | "ring" | "field"
algebraicStructure -> plainAlgebraicStructure | plainAlgebraicStructure "oid"

vagueWord ->
  "canonical"
| "standard"
| "structure-preserving"
| "visible"
| algebraicStructure "-like"

qualification ->
  nounPhrases _ "are" _ scareQuote[vagueWord] _ "from" _ tex[mUpper] "'s" _ "point of view"
| "the appropriate" _ nounPhrases _ "are considered"
| tex[mSmallExpr] _ "is" _ description

statement ->
  "a" _ nounPhrase _ "is always" _ description maybe[_ iffy _ qualification]
| "a" _ nounPhrase _ "satisfies the" _ description _ "property" maybe[_ iffy _ qualification]
| "a" _ nounPhrase _ "embeds" _ adverb _ "into all" _ description _ nounPhrases

conditional ->
  "if" _ statement "," _ "then" _ statement
| "in the case that" _ statement "," _ statement
| "when" _ statement "," _ "it is said that" _ statement

sentence -> connective "," _ conditional "." _
openingSentence -> conditional "." _
listItem -> statement
title -> maybe[adverb] _ adj _ noun
