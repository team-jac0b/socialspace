# spacy.explain('<tag>')

#
# import spacy
# nlp = spacy.load("en_core_web_sm")
# doc = nlp(u"This is a sentence.")
# print([(w.text, w.pos_) for w in doc])

import spacy
# spacy.explain('pos)

nlp = spacy.load("en_core_web_sm")

text = "I'm going to be visiting Japan this summer with family"

text2 = "I'm going to be doing an internship this summer"

# Process the text
doc = nlp(text)

for chunk in doc.noun_chunks:
    print(chunk.text, chunk.root.text, chunk.root.dep_,
            chunk.root.head.text)

# for token in doc:
#     # Get the token text, part-of-speech tag and dependency label
#     token_text = token.text
#     token_pos = token.pos_
#     token_dep = token.dep_
#     # This is for formatting only
#     print("{:<12}{:<10}{:<10}".format(token_text, token_pos, token_dep))