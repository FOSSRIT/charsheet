import tw2.core
import tw2.forms


class CharsheetForm(tw2.forms.FormPage):
    title = 'Account Usernames'

    class child(tw2.forms.TableForm):
        buttons = [tw2.forms.SubmitButton(id='submit', value='Generate')]
        action = '/charsheet'
        id = tw2.forms.HiddenField()
        github = tw2.forms.TextField('github', label='GitHub')
        ohloh = tw2.forms.TextField('ohloh', label='Ohloh')
        coderwall = tw2.forms.TextField('coderwall', label='Coderwall')
