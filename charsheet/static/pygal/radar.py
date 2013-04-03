import pygal


radar_chart = pygal.Radar(fill=True)
radar_chart.title = 'Foo'
radar_chart.x_labels = ['C', 'C++', 'Java', 'HTML', 'XML', 'Python', 'PHP',
                        'Javascript', 'Perl', 'Shell', 'Objective-C', 'Ruby',
                        'Haskell', 'Lua', 'Assembly', 'Common-Lisp', 'Scala',
                        'Visual Basic', 'Arduino', 'Erlang', 'Go',
                        'CoffeeScript', 'Emacs-Lisp', 'VimL']
radar_chart.add('C', [6395, 8212, 7520, 7218, 12464, 1660, 2123, 8607])
radar_chart.add('C++', [6395, 8212, 7520, 7218, 12464, 1660, 2123, 8607])
radar_chart.render()
