import tw2.core
import tw2.forms


class CharsheetForm(tw2.forms.FormPage):
    title = 'Accounts'

    class child(tw2.forms.TableForm):
        buttons = [tw2.forms.SubmitButton(id='submit', value='Generate')]
        action = '/submit'
        id = tw2.forms.HiddenField()
        master = tw2.forms.TextField('master', label='All')
        # I just made github a hidden field because removing it broke
        # the code. I believe other code gets data from it. Anyway, the
        # user doesn't need to fill it out anymore because OAuth has
        # been implemented.
        github = tw2.forms.HiddenField()
        github_token = tw2.forms.HiddenField('github_token')
        ohloh = tw2.forms.TextField('ohloh', label='Ohloh')
        coderwall = tw2.forms.TextField('coderwall', label='Coderwall')


class HandleSearchForm(tw2.forms.FormPage):
    title = 'Handle Search'

    class child(tw2.forms.TableForm):
        buttons = [tw2.forms.SubmitButton(id='submit', value='Search')]
        action = '/charsheet'
        username = tw2.forms.TextField('handle', label='Handle')
