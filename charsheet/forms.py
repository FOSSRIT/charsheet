import tw2.core
import tw2.forms


class CharsheetForm(tw2.forms.FormPage):
    title = 'Accounts'

    class child(tw2.forms.TableForm):
        buttons = [tw2.forms.SubmitButton(id='submit', value='Generate')]
        action = '/charsheet'
        id = tw2.forms.HiddenField()
        optional_label = tw2.forms.Label(text="All services optional.")
        master = tw2.forms.TextField('master', label='Master')
        master_label = tw2.forms.Label(text='Master field autocompletes \
                next four.')
        github = tw2.forms.TextField('github', label='GitHub')
        ohloh = tw2.forms.TextField('ohloh', label='Ohloh')
        coderwall = tw2.forms.TextField('coderwall', label='Coderwall')
        fedora = tw2.forms.TextField(
                'fedora', label='Fedora Account System (FAS)')
        fedora_pass = tw2.forms.PasswordField(
                'fedora_pass', label='FAS Password')
        stack_exchange = tw2.forms.TextField('stack_exchange',
                label='Stack Exchange ID')
        se_label = tw2.forms.Label(text='stackexchange.com/users/ID/USERNAME')
