import tw2.core
import tw2.forms


class CharsheetForm(tw2.forms.FormPage):
    title = 'Accounts'

    class child(tw2.forms.TableForm):
        buttons = [tw2.forms.SubmitButton(id='submit', value='Generate')]
        action = '/charsheet'
        id = tw2.forms.HiddenField()
        master = tw2.forms.TextField('master', label='Master')
        master_label = tw2.forms.Label(text='Master field autocompletes \
                these 3:')
        github = tw2.forms.TextField('github', label='GitHub')
        ohloh = tw2.forms.TextField('ohloh', label='Ohloh')
        coderwall = tw2.forms.TextField('coderwall', label='Coderwall')

        spacer1 = tw2.forms.Spacer()
        se_label = tw2.forms.Label(text='stackexchange.com/users/ID/USERNAME')
        stack_exchange = tw2.forms.TextField('stack_exchange',
                label='Stack Exchange ID')

        spacer2 = tw2.forms.Spacer()
        fas_label = tw2.forms.Label(text='No OpenID at this time. :(')
        fedora = tw2.forms.TextField(
            'fedora', label='Fedora Account System (FAS)')
        fedora_pass = tw2.forms.PasswordField(
            'fedora_pass', label='FAS password')
