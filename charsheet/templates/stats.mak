<%inherit file="base.mak"/>

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
        </table>
        <h3>Sheets Generated by Class</h3>
        <table>
          % for class_name, sheet_count in stats.get('class_sheets').items():
            <tr><td>${class_name}</td><td>${sheet_count}</td></tr>
          % endfor
        </table>
        <h3>Sheets Generated by Top Language</h3>
        <table>
          % for class_name, sheet_count in stats.get('language_sheets').items():
            <tr><td>${class_name}</td><td>${sheet_count}</td></tr>
          % endfor
        </table>
      </div>
      <div class="grid_6">
        <h3>Top Foo</h3>
        <table>
          <% i = 1 %>
          % if len(stats['top_foo']) < 1:
            <p>No one has generated a charsheet yet!</p>
          % else:
            % for user in stats['top_foo']:
              <tr>
                <td>
                  <strong>${i}.</strong>
                  <a href='${request.route_url('charsheet', username=user[0])}'>${user[0]}</a>
                </td>
                <td>${'%.2f' % user[1]}</td>
              </tr>
              <% i += 1 %>
            % endfor
          % endif
        </table>
        <h3>Average Stats</h3>
        <table>
          <tr>
            <td>Average Foo</td>
            <td>${'%.2f' % stats['avg_foo']}</td>
          </tr>
          <tr>
            <td>Average Strength</td>
            <td>${'%.2f' % stats['avg_strength']}</td>
          </tr>
          <tr>
            <td>Average Dexterity</td>
            <td>${'%.2f' % stats['avg_dexterity']}</td>
          </tr>
          <tr>
            <td>Average Wisdom</td>
            <td>${'%.2f' % stats['avg_wisdom']}</td>
          </tr>
          <tr>
            <td>Average Leadership</td>
            <td>${'%.2f' % stats['avg_leadership']}</td>
          </tr>
          <tr>
            <td>Average Determination</td>
            <td>${'%.2f' % stats['avg_determination']}</td>
          </tr>
          <tr>
            <td>Average Number of Languages</td>
            <td>${'%.2f' % stats['avg_num_languages']}</td>
          </tr>
          <tr>
            <td>Average Coderwall Badges</td>
            <td>${'%.2f' % stats['avg_badges']}</td>
          </tr>
        </table>
      </div>
      <div class="grid_6">
        <table>
        </table>
      </div>
    % endif <!-- End stats area -->
  <div class="clear"></div>
</div>

<%def name='title()'>Charsheet | Global Stats</%def>
