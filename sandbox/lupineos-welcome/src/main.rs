use gettextrs::gettext;
use gtk4 as gtk;

use gtk::prelude::*;
use gtk::{gio, glib};
use gtk::glib::StaticType; // Added StaticType trait
use libadwaita as adw;


mod window;
use window::LupineWelcomeWindow;

mod pages;


const APP_ID: &str = "org.lupineos.Welcome";

fn main() -> glib::ExitCode {
    // Initialize gettext functionality (optional for now but good practice)
    gettextrs::setlocale(gettextrs::LocaleCategory::LcAll, "");
    gettextrs::bindtextdomain("lupineos-welcome", "/usr/share/locale").expect("Unable to bind the text domain");
    gettextrs::bind_textdomain_codeset("lupineos-welcome", "UTF-8").expect("Unable to bind the text domain codeset");
    gettextrs::textdomain("lupineos-welcome").expect("Unable to switch to the text domain");

    // Initialize tracing
    tracing_subscriber::fmt::init();


    // Initialize GTK/Adwaita
    let app = adw::Application::builder()
        .application_id(APP_ID)
        .flags(gio::ApplicationFlags::empty())
        .build();

    app.connect_startup(|_| {
        adw::init().expect("Failed to initialize Libadwaita");
        load_css();
        pages::WelcomePage::static_type();
        pages::AtomicPage::static_type();
        pages::PersonalizePage::static_type();
        pages::SoftwarePage::static_type(); // Ensure type is registered
    });





    app.connect_activate(|app| {
        let window = LupineWelcomeWindow::new(app);
        window.present();
    });

    app.run()
}

fn load_css() {
    let provider = gtk::CssProvider::new();
    provider.load_from_data(include_str!("style.css"));
    
    gtk::style_context_add_provider_for_display(
        &gtk::gdk::Display::default().expect("Could not connect to a display."),
        &provider,
        gtk::STYLE_PROVIDER_PRIORITY_APPLICATION,
    );
}
