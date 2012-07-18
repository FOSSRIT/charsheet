import tw2.core
import tw2.forms


class CharsheetForm(tw2.forms.FormPage):
    title = 'Account Usernames'

    class child(tw2.forms.TableForm):
        id = tw2.forms.HiddenField()
        github = tw2.forms.TextField('github', label='GitHub')
        ohloh = tw2.forms.TextField('ohloh', label='Ohloh')
        coderwall = tw2.forms.TextField('coderwall', label='Coderwall')
