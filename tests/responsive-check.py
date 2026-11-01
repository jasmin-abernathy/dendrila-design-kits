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
    assert 'grid-template-columns:repeat(4,minmax(0,1fr))' in css,style+' footer must have four desktop columns'
    assert '@media(max-width:52rem)' in css and 'grid-template-columns:repeat(2,minmax(0,1fr))' in css,style+' mobile two-column footer missing'
    assert '.d-footer__links a:focus-visible' in css,style+' keyboard focus missing'
    assert 'V8 concluding CTA across all six starter homepages' in css,style+' homepage final CTA missing'
    assert '.d-home-composition>.d-home-tile--cta' in css,style+' CTA not spanning full composition'
    assert 'min-height:48px' in css,style+' CTA hit target too small'


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

# WCAG AA normal-size text and all three burger strokes must be legible.
def luminance(color):
    v=[int(color[i:i+2],16)/255 for i in (1,3,5)]
    v=[t/12.92 if t<=.04045 else ((t+.055)/1.055)**2.4 for t in v]
    return .2126*v[0]+.7152*v[1]+.0722*v[2]

def contrast(a,b):
    hi,lo=sorted((luminance(a),luminance(b)),reverse=True)
    return (hi+.05)/(lo+.05)

menu_palettes={
 'simple-illustrated':('#324a3b','#ffffff','#ffffff','#25302a','#e7eee9'),
 'quiet-elegant':('#303624','#ffffff','#fffdf8','#1f211d','#efe9df'),
 'image-centered':('#e5eee4','#101616','#172020','#f4f5ef','#384b3f'),
 'very-minimal':('#101418','#ffffff','#ffffff','#101418','#edf2ef'),
 'dynamic-graphic':('#3320a0','#ffffff','#fff9e8','#211e57','#eee3c3'),
 'editorial':('#1d2627','#fffdf8','#fffcf5','#1d2627','#e9ebe6')
}
for style,(button_bg,button_fg,panel_bg,panel_fg,hover_bg) in menu_palettes.items():
    css=(ROOT/'themes'/style/'theme.css').read_text()
    assert 'V6 solid high-contrast native mobile navigation' in css,style
    assert f'background-color:{button_bg}!important' in css,style+' burger background not enforced'
    assert f'color:{button_fg}!important' in css,style+' burger label color not enforced'
    assert f'background-color:{panel_bg}!important' in css,style+' menu panel not opaque'
    assert f'background-color:{hover_bg}!important' in css,style+' hover contrast not fixed'
    for caption,a,b in (
      ('burger label and strokes',button_bg,button_fg),
      ('open menu links',panel_bg,panel_fg),
      ('hover menu links',hover_bg,panel_fg),
    ):
        score=contrast(a,b)
        assert score>=4.5,style+' '+caption+' contrast too low: '+str(score)
    print('BURGER_CONTRAST_OK',style,round(contrast(button_bg,button_fg),1),
        round(contrast(panel_bg,panel_fg),1),round(contrast(hover_bg,panel_fg),1))

simple=(ROOT/'themes/simple-illustrated/theme.css').read_text()
for rule in (
 'V9 consistent interior rhythm across all Simple illustré pages',
 '--d-simple-inset:clamp(1.5rem,3.5vw,3rem)',
 '--d-simple-card-inset:clamp(1.35rem,3vw,2.25rem)',
 'padding:var(--d-simple-inset)',
 'padding:var(--d-simple-card-inset)',
 'padding-bottom:clamp(10rem,34vw,15rem)',
 'width:calc(100% - 1.5rem)',
):
    assert rule in simple,'Illustrated responsive spacing missing: '+rule
print('Illustrated layout: desktop and 320-430 px internal padding and image spacing OK')
photo_css=(ROOT/'themes/image-centered/theme.css').read_text()
for n in ('architecture','nature','forest'):
    assert 'url("assets/'+n+'.webp")!important' in photo_css, 'Missing photo card '+n
    assert (ROOT/'themes/image-centered/assets'/(n+'.webp')).is_file(), 'Missing local CC0 photo '+n
for name in ('mountains','architecture','forest','flowers','nature'):
    assert 'url("assets/'+name+'.webp")!important' in photo_css, 'Missing interior photo background '+name
    assert (ROOT/'themes/image-centered/assets'/(name+'.webp')).is_file()
assert 'rgba(7,18,13,.83)' in photo_css, 'Dark overlay for text contrast is missing'
assert 'color:#fff!important' in photo_css, 'White text over dark images is missing'
print('Photo cards: 3 licensed local backgrounds, accessible contrast overlay, responsive size OK')
print('Six responsive kits: menu, keyboard/focus, mobile grids, CSS balance, fallback and reduced motion OK')
