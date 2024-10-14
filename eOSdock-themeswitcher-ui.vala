public class eOSdock_themeswitcher.Main : Gtk.Application
{
  public Main()
  {
    Object
    (
      application_id: "com.github.teamcons.eosdockthemeswitcher",
      flags: ApplicationFlags.FLAGS_NONE
    );
  }

  public static int main(string[] args)
  {
    var app = new eOSdock_themeswitcher.Main();
    return app.run(args);
  }

  protected override void activate()
  {
    Gtk.ApplicationWindow main_window = new Gtk.ApplicationWindow(this);
    main_window.default_height = 700;
    main_window.default_width = 400;

    Gtk.ListStore list_store = new Gtk.ListStore(HostsManager.TreeView.Columns.N_COLUMNS, typeof(bool), typeof(bool), typeof(string), typeof(string));
    Gtk.TreeIter add_iter = Gtk.TreeIter();

    try
    {
      for (MatchInfo mi = hostsFile.getEntries(); mi.matches(); mi.next())
      {
        list_store.append(out add_iter);
        list_store.set(add_iter,
          HostsManager.TreeView.Columns.COMPLETE,   true,
          HostsManager.TreeView.Columns.ENABLED,    mi.fetch_named("enabled") != "#",
          HostsManager.TreeView.Columns.IPADDRESS,  mi.fetch_named("ipaddress"),
          HostsManager.TreeView.Columns.HOSTNAME,   mi.fetch_named("hostname")
        );
      }
    }
    catch (Error e)
    {
      GLib.error("Regex failed: %s", e.message);
    }

    HostsManager.TreeView tree_view = new HostsManager.TreeView(list_store);

    tree_view.active_toggled.connect((toggle, iter, ipaddress, hostname) =>
    {
      Services.HostsRegex regex = new Services.HostsRegex(ipaddress, hostname);
      hostsFile.setEnabled(regex, toggle.active);

      list_store.set(iter, HostsManager.TreeView.Columns.ENABLED, !toggle.active);
    });

    tree_view.ipaddress_added.connect((iter, ipaddress, hostname) =>
    {
      debug("ipaddress_added");

      try
      {
        hostsFile.add(ipaddress, hostname);
        list_store.set(iter, HostsManager.TreeView.Columns.IPADDRESS, ipaddress);
        list_store.set(iter, HostsManager.TreeView.Columns.COMPLETE, true);
      }
      catch (InvalidArgument err)
      {
        debug("InvalidArgument: %s", err.message);

        if (err.code == 1) // HOSTNAME invalid
        {
          list_store.set(iter, HostsManager.TreeView.Columns.IPADDRESS, ipaddress);
          tree_view.focus_hostname(iter);
        }
      }
    });

    tree_view.ipaddress_edited.connect((iter, ipaddress, hostname, new_ipaddress) =>
    {
      debug("ipaddress_edited");

      try
      {
        Services.HostsRegex regex = new Services.HostsRegex(ipaddress, hostname);
        hostsFile.setIpAddress(regex, new_ipaddress);
        list_store.set(iter, HostsManager.TreeView.Columns.IPADDRESS, new_ipaddress);
      }
      catch (InvalidArgument err)
      {
        debug("InvalidArgument: %s", err.message);
      }
    });

    tree_view.hostname_added.connect((iter, ipaddress, hostname) =>
    {
      debug("hostname_added");

      try
      {
        hostsFile.add(ipaddress, hostname);
        list_store.set(iter, HostsManager.TreeView.Columns.HOSTNAME, hostname);
        list_store.set(iter, HostsManager.TreeView.Columns.COMPLETE, true);
      }
      catch (InvalidArgument err)
      {
        debug("InvalidArgument: %s", err.message);

        if (err.code == 0) // IPADDRESS invalid
        {
          list_store.set(iter, HostsManager.TreeView.Columns.HOSTNAME, hostname);
          tree_view.focus_ipaddress(iter);
        }
      }
    });

    tree_view.hostname_edited.connect((iter, ipaddress, hostname, new_hostname) =>
    {
      debug("hostname_edited");

      try
      {
        Services.HostsRegex regex = new Services.HostsRegex(ipaddress, hostname);
        hostsFile.setHostname(regex, new_hostname);
        list_store.set(iter, HostsManager.TreeView.Columns.HOSTNAME, new_hostname);
      }
      catch (InvalidArgument err)
      {
        debug("InvalidArgument: %s", err.message);
      }
    });

    Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow(null, null);
    scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
    scroll.add(tree_view);

    Gtk.TreeSelection selection = tree_view.get_selection();
    IconButton remove_btn = new IconButton("list-remove", _("Remove entry"));
    remove_btn.clicked.connect(() =>
    {
      debug("Remove rows was clicked");
      Gtk.Dialog dialog = new Gtk.MessageDialog
      (
        main_window,
        Gtk.DialogFlags.MODAL,
        Gtk.MessageType.QUESTION,
        Gtk.ButtonsType.YES_NO,
        _("Do you want to delete the selected entry?")
      );

      dialog.response.connect ((dialog, response_id) =>
      {
        if (Gtk.ResponseType.YES == response_id)
        {
          Gtk.TreeModel model;
          Gtk.TreeIter selected_iter;
          Value ipaddress;
          Value hostname;
          Value is_complete;

          selection.get_selected(out model, out selected_iter);
          model.get_value(selected_iter, HostsManager.TreeView.Columns.IPADDRESS, out ipaddress);
          model.get_value(selected_iter, HostsManager.TreeView.Columns.HOSTNAME, out hostname);
          model.get_value(selected_iter, HostsManager.TreeView.Columns.COMPLETE, out is_complete);

          if ((bool) is_complete)
          {
            Services.HostsRegex regex = new Services.HostsRegex(ipaddress, hostname);
            hostsFile.remove(regex);
          }

          list_store.remove(ref selected_iter);
        }

        dialog.destroy();
      });

      dialog.show_all();
    });



    Gtk.HeaderBar header_bar = new Gtk.HeaderBar();
        header_bar.set_title("eOSdock-themeswitcher");
        header_bar.set_show_close_button(true);

    main_window.set_titlebar(header_bar);
    main_window.add(scroll);
    main_window.show_all();
  }
}
