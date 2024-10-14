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

    // need an apply button at bottom

    // For each css file in themes
    // add a radio button

    var live = new Gtk.CheckButton.with_label ("Live");
    var laugh = new Gtk.CheckButton.with_label ("Laugh");
    var love = new Gtk.CheckButton.with_label ("Love");

    laugh.group = live;
    love.group = live;

    // then execute the bash script when apply is clicked



    Gtk.HeaderBar header_bar = new Gtk.HeaderBar();
        header_bar.set_title("eOSdock-themeswitcher");
        header_bar.set_show_close_button(true);

    main_window.set_titlebar(header_bar);
    main_window.add(scroll);
    main_window.show_all();
  }
}
