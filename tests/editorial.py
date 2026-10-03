"""Catalogue-to-CMS contract and semantic preview regression checks."""
from html.parser import HTMLParser
from pathlib import Path
import json

catalog = json.loads(Path('catalog.json').read_text())
expected = {'simple-illustrated':'simple-illustrated', 'image-centered':'image-forward',
            'quiet-elegant':'quiet-elegant', 'very-minimal':'ultra-minimal',
            'dynamic-graphic':'graphic-rhythm', 'editorial':'editorial'}
assert {t['id']:t['design_style_id'] for t in catalog['themes']} == expected

class Preview(HTMLParser):
    def __init__(self):
        super().__init__(); self.ids=[]; self.links=[]; self.articles=0; self.h1=0; self.faq=0
    def handle_starttag(self, tag, attrs):
        a=dict(attrs)
        if 'id' in a: self.ids.append(a['id'])
        if tag == 'a': self.links.append(a.get('href',''))
        if tag == 'article': self.articles+=1
        if tag == 'h1': self.h1+=1
        if tag == 'summary': self.faq+=1
        assert tag != 'iframe', 'External media must stay blocked in preview'
        if tag == 'img':
            assert a.get('alt'), 'Preview photos need descriptive alternatives'
            assert 'width' in a and 'height' in a, 'Reserve image space'
p=Preview(); html=Path('themes/editorial/preview/index.html').read_text();p.feed(html)
assert p.articles==6 and p.h1==1 and p.faq==3
assert len(p.ids)==len(set(p.ids))
assert all(link[1:] in p.ids for link in p.links if link.startswith('#'))
assert 'd-stats' not in html and 'En quelques chiffres' not in html
assert html.index('id="explorer"') < html.index('id="images"') < html.index('id="questions"')
for file in ['preview.css','preview.js']:
    assert (Path('themes/editorial/preview')/file).is_file()
print('Editorial preview and six CMS style mappings passed.')
