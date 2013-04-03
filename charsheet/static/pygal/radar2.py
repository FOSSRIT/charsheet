import pygal
from pygal.style import LightSolarizedStyle

langs = ['C', 'C++', 'Java', 'HTML', 'XML', 'Python', 'PHP',
         'Javascript', 'Perl', 'Shell', 'Objective-C', 'Ruby',
         'Haskell', 'Lua', 'Assembly', 'Common-Lisp', 'Scala',
         'Visual Basic', 'Arduino', 'Erlang', 'Go',
         'CoffeeScript', 'Emacs-Lisp', 'VimL']

foo_vals = [(30, 20, 40, 50, 40, 35, 30, 35, 25, 27, 25, 20, 27, 20, 25, 27, 20, 25, 20, 25, 27, 25, 20, 27)]

radar_chart = pygal.Radar(fill=True, value_font_size=0, show_legend=False, style=LightSolarizedStyle)
radar_chart.title = 'Foo'

radar_chart.x_labels = ['C', 'C++', 'Java', 'HTML', 'XML', 'Python', 'PHP',
                        'Javascript', 'Perl', 'Shell', 'Objective-C', 'Ruby',
                        'Haskell', 'Lua', 'Assembly', 'Common-Lisp', 'Scala',
                        'Visual Basic', 'Arduino', 'Erlang', 'Go',
                        'CoffeeScript', 'Emacs-Lisp', 'VimL']
for lang, val in zip(langs, foo_vals):
    radar_chart.add(lang, val)

radar_chart.render_to_file('radar2.svg')
