# -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <link href='${request.static_url(
            'charsheet:static/css/reset.css')}'
            rel='stylesheet' type='text/css' media='all'>
        <link href='${request.static_url(
            'charsheet:static/css/960_12_col.css')}'
            rel='stylesheet' type='text/css' media="all">
        <link href='${request.static_url('charsheet:static/css/app.css')}'          rel='stylesheet' type='text/css'>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
        <title>Charsheet | Global Stats</title>
    </head>
    <body>

        <!-- Header logo -->
        <a href=".."><h1 class='logo-text'><img class='logo' alt='Charsheet logo'
            src='${request.static_url('charsheet:static/img/icon_64x64.png')}' />
        Charsheet</h1></a>
        <!-- End header logo -->

        <div class="container_12">
            <div class="clear"></div>
            <div class="grid_12">
                <a class="button" href="..">Back</a>
            </div>
            <div class="clear"></div>
            <div class="grid_12">
            <h2>Global Stats</h2>
            </div>
            <div class="clear"></div>
            <!-- Begin stats area -->
            % if not stats:
            <div class="grid_12">
            <h3>Stats are currently unavailable.</h3>
            <p>It pains me to say it; it really does.</p>
            </div>
            % else:
            <div class="grid_6">
                <h3>General Info</h3>
                <table>
                    <tr>
                        <td>Sheets Generated</td>
                        <td>${stats['sheets_generated']}</td>
                    </tr>
                    <tr>
                        <td>Unique Sheets</td>
                        <td>${stats['sheets_unique']}</td>
                    </tr>
                </table>
            </div>
            <div class="grid_6">
                <h3>Top Foo</h3>
                <table>
                <% i = 1 %>
                % for user in stats['top_foo']:
                    <tr>
                        <td>
                            <strong>${i}.</strong>
                            <a href='${request.route_url('charsheet', username=user[0])}'>${user[0]}</a>
                        </td>
                        <td>${user[1]}</td>
                    </tr>
                    <% i += 1 %>
                % endfor
                </table>
            </div>
            <div class="clear"></div>
            <div class="grid_6">
                <h3>Average Stats</h3>
                <table>
                <tr>
                    <td>Average Foo</td>
                    <td>${stats['avg_foo']}</td>
                </tr>
                <tr>
                    <td>Average Strength</td>
                    <td>${stats['avg_strength']}</td>
                </tr>
                <tr>
                    <td>Average Dexterity</td>
                    <td>${stats['avg_dexterity']}</td>
                </tr>
                <tr>
                    <td>Average Wisdom</td>
                    <td>${stats['avg_wisdom']}</td>
                </tr>
                <tr>
                    <td>Average Leadership</td>
                    <td>${stats['avg_leadership']}</td>
                </tr>
                <tr>
                    <td>Average Determination</td>
                    <td>${stats['avg_determination']}</td>
                </tr>
                <tr>
                    <td>Average Number of Languages</td>
                    <td>${stats['avg_num_languages']}</td>
                </tr>
                <tr>
                    <td>Average Coderwall Badges</td>
                    <td>${stats['avg_badges']}</td>
                </tr>
                </table>
            </div>
            <div class="grid_6">
                <table>
                </table>
            </div>
            % endif <!-- End stats area -->
            <div class="clear"></div>
            <div class="grid_12">
                <div class="footer">
                <a rel="license"
                    href="http://creativecommons.org/licenses/by/3.0/">
                        <img alt="Creative Commons License"
                        style="border-width:0"
                    src="${request.static_url('charsheet:static/img/cc30.png')}" />
                </a>
                <br />This work is licensed under a
                <a rel="license" href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported License</a>.
                Code freely available
                <a href="https://github.com/FOSSRIT/charsheet">on GitHub</a>.
                </div>
            </div>
        </div>
    </body>
</html>
