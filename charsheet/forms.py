import tw2.core
import tw2.forms


class CharsheetForm(tw2.forms.FormPage):
    title = 'Accounts'

    class child(tw2.forms.TableForm):
        buttons = [tw2.forms.SubmitButton(id='submit', value='Generate')]
        action = '/charsheet'
        id = tw2.forms.HiddenField()
        master_label = tw2.forms.Label(text='If this field is completed, its \
                value will be applied to each of the below username fields.')
        master = tw2.forms.TextField('master', label='Master')
        github = tw2.forms.TextField('github', label='GitHub')
        ohloh = tw2.forms.TextField('ohloh', label='Ohloh')
        coderwall = tw2.forms.TextField('coderwall', label='Coderwall')
        stack_exchange = tw2.forms.TextField('stack_exchange',
                label='Stack Exchange')
        fas_label = tw2.forms.Label(text='We cannot authenticate FAS using \
                OpenID at this time.')
        fedora = tw2.forms.TextField(
            'fedora', label='Fedora Account System (FAS)')
        fedora_pass = tw2.forms.PasswordField(
            'fedora_pass', label='FAS password')