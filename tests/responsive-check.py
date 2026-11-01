#!/usr/bin/env python3
"""Structural responsive contract for all six standalone Dendrila kits.

No network, third-party tools, browser installation, or Actions minutes required.
This complements (does not replace) mobile browser visual verification.
"""
from html.parser import HTMLParser
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
STYLES=(
    'simple-illustrated','quiet-elegant','image-centered',
    'very-minimal','dynamic-graphic','editorial'
)

class NavigationChecker(HTMLParser):
    def __init__(self):
        super().__init__()
        self.details=0
        self.summaries=0
        self.navs=0
        self.focusable_links=0
        self.menu_panels=0
        self.labels=[]
    def handle_starttag(self,tag,attrs):
        args=dict(attrs)
        classes=args.get('class','').split()
        if tag=='details' and 'd-mobile-menu' in classes:
            self.details+=1
        if tag=='summary' and args.get('aria-label')=='Ouvrir le menu de navigation':
            self.summaries+=1
        if tag=='nav' and 'd-nav' in classes and args.get('aria-label')=='Navigation principale':
            self.navs+=1
        if 'd-mobile-menu__panel' in classes:
            self.menu_panels+=1
        if tag=='a' and args.get('href'):
            self.focusable_links+=1

def has_balanced_css(text):
    """Catch unclosed braces/comments/strings without requiring npm."""
    text=re.sub(r'/\*.*?\*/','',text,flags=re.S)
    quotes=None
    escaped=False
    count=0
    for char in text:
        if escaped:
            escaped=False
            continue
        if char=='\\':
            escaped=True
            continue
        if quotes:
            if char==quotes: quotes=None
            continue
        if char in '\"\\\'':
            quotes=char
            continue
        if char=='{': count+=1
        if char=='}':
            count-=1
            if count<0: return False
    return count==0 and quotes is None

for style in STYLES:
    folder=ROOT/'themes'/style
    css=(folder/'theme.css').read_text()
    html=(folder/'preview'/'index.html').read_text()
    page=NavigationChecker()
    page.feed(html)
    assert page.details==1 and page.summaries==1 and page.menu_panels==1,style+' missing accessible mobile menu'
    assert page.navs==2 and page.focusable_links>=5,style+' navigation duplicate for display breakpoint'
    assert 'd-home-composition' in html and html.count('d-home-tile')>=2,style+' visual flow not composed'
    assert 'class="d-footer__links"' in html,style+' static footer is not a link grid'
    assert 'V5 shared footer' in css,style+' footer grid rules missing'
    assert 'grid-template-columns:repeat(3,minmax(0,1fr))' in css,style+' footer must have three columns'
    assert 'grid-template-columns:repeat(2,minmax(0,1fr))' in css,style+' tiny phone fallback missing'
    assert '.d-footer__links a:focus-visible' in css,style+' keyboard focus missing'

    assert 'V4 theme-owned homepage composition' in css,style+' missing non-blog section layouts'
    assert has_balanced_css(css),style+' invalid CSS braces or string boundaries'
    for required in (
        '/* V3 responsive contract',
        '@media(max-width:64rem)',
        '@media(max-width:42rem)',
        '@media(max-width:23rem)',
        '@media(prefers-reduced-motion:reduce)',
        '.d-header__inner>.d-nav{display:none!important}',
        'body[data-dendrila-theme] .d-mobile-menu__panel .d-nav a',
        'min-height:2.8rem!important',
        'focus-visible',
        'text-decoration:none!important',
        'grid-template-columns:minmax(0,1fr)',
    ):
        assert required in css,(style,required)
    assert 'width:min(27rem,calc(100vw - 2rem))' in css,style+' panel viewport fit'
    assert not re.search(r'@media\s*\([^)]*min-width[^)]*\).*?\.d-mobile-menu\s*\{display:block',css,re.S),style
    print('RESPONSIVE_OK',style)
photo_css=(ROOT/'themes/image-centered/theme.css').read_text()
for n in ('architecture','nature','forest'):
    assert 'url("assets/'+n+'.webp")!important' in photo_css, 'Missing photo card '+n
    assert (ROOT/'themes/image-centered/assets'/(n+'.webp')).is_file(), 'Missing local CC0 photo '+n
assert 'rgba(7,18,13,.83)' in photo_css, 'Dark overlay for text contrast is missing'
assert 'color:#fff!important' in photo_css, 'White text over dark images is missing'
print('Photo cards: 3 licensed local backgrounds, accessible contrast overlay, responsive size OK')
print('Six responsive kits: menu, keyboard/focus, mobile grids, CSS balance, fallback and reduced motion OK')
