use gtk4::prelude::*;
use gtk4::{glib, Align, Box as GtkBox, Orientation, Label, Switch, Button};
use libadwaita::prelude::*;
use libadwaita::{
    ActionRow, Application, ApplicationWindow, Carousel, CarouselIndicatorDots, StatusPage,
    Leaflet, NavigationDirection,
};
use std::fs;
use std::path::PathBuf;
use std::process::Command;
use std::cell::RefCell;
use std::rc::Rc;

const CONFIG_FILE_NAME: &str = ".config/lupineos-welcome-done";

struct AppState {
    admin_switch: Switch,
    sec_switch: Switch,
    data_switch: Switch,
    dev_switch: Switch,
}

fn main() {
    let app = Application::builder()
        .application_id("com.lupineos.welcome")
        .build();

    if is_first_run() {
        app.connect_activate(build_ui);
    } else {
        println!("Welcome app has already run.");
        std::process::exit(0);
    }

    app.run();
}

fn build_ui(app: &Application) {
    let window = ApplicationWindow::builder()
        .application(app)
        .title("Welcome to LupineOS")
        .default_width(850)
        .default_height(650)
        .build();

    let carousel = Carousel::builder().build();
    let dots = CarouselIndicatorDots::builder().carousel(&carousel).build();

    // --- Page 1: Welcome ---
    let welcome_page = StatusPage::builder()
        .icon_name("system-help-symbolic")
        .title("Welcome to the WolfPack")
        .description("Your system is ready. Let's configure your hunting grounds.")
        .build();
    carousel.append(&welcome_page);

    // --- Page 2: The Pack (Selection) ---
    let selection_box = GtkBox::builder()
        .orientation(Orientation::Vertical)
        .spacing(24)
        .valign(Align::Center)
        .margin_top(32)
        .margin_bottom(32)
        .margin_start(32)
        .margin_end(32)
        .build();

    let title_label = Label::builder()
        .label("<span size='x-large' weight='bold'>Choose Your Pack</span>")
        .use_markup(true)
        .build();
    selection_box.append(&title_label);

    let list_box = gtk4::ListBox::builder()
        .selection_mode(gtk4::SelectionMode::None)
        .css_classes(vec!["boxed-list"])
        .build();

    // -- State Holders --
    let admin_switch = Switch::builder().active(false).valign(Align::Center).build();
    let sec_switch = Switch::builder().active(false).valign(Align::Center).build();
    let data_switch = Switch::builder().active(false).valign(Align::Center).build();
    let dev_switch = Switch::builder().active(true).valign(Align::Center).build(); // Default on for tools

    // -- Rows with Descriptions --
    fn create_row(title: &str, subtitle: &str, switch: &Switch) -> ActionRow {
        let row = ActionRow::builder()
            .title(title)
            .subtitle(subtitle)
            .activatable_widget(switch)
            .build();
        row.add_suffix(switch);
        row
    }

    list_box.append(&create_row(
        "Admin Container (Alpha)", 
        "Ubuntu-based. Includes Ansible, Terraform, AWS CLI, and server management tools.", 
        &admin_switch
    ));
    list_box.append(&create_row(
        "Security Container (Omega)", 
        "Kali Linux-based. Pre-loaded with Nmap, Metasploit, Burp Suite, and pentesting tools.", 
        &sec_switch
    ));
    list_box.append(&create_row(
        "Data Lab (Beta)", 
        "Fedora-based. Python data stack (Pandas, Jupyter), PostgreSQL, and math libraries.", 
        &data_switch
    ));
    list_box.append(&create_row(
        "Dev Tools (Host)", 
        "Installs enhanced Rust updates for standard tools (ripgrep, bat, antigravity, gemini).", 
        &dev_switch
    ));

    selection_box.append(&list_box);
    carousel.append(&selection_box);

    // --- Page 3: Finish ---
    let finish_box = GtkBox::builder()
        .orientation(Orientation::Vertical)
        .spacing(24)
        .valign(Align::Center)
        .build();

    let finish_page = StatusPage::builder()
        .icon_name("emblem-ok-symbolic")
        .title("Ready to Initialize")
        .description("Click below to launch the setup terminal. You can observe the build process live.")
        .child(&finish_box)
        .build();

    let install_btn = Button::builder()
        .label("Initialize System")
        .css_classes(vec!["suggested-action", "pill"])
        .halign(Align::Center)
        .width_request(200)
        .height_request(50)
        .build();
    
    finish_box.append(&install_btn);
    carousel.append(&finish_page);

    // --- Layout ---
    let main_box = GtkBox::builder().orientation(Orientation::Vertical).build();
    main_box.append(&carousel);
    main_box.append(&dots);
    window.set_child(Some(&main_box));

    // --- Logic ---
    let state = Rc::new(AppState {
        admin_switch,
        sec_switch,
        data_switch,
        dev_switch,
    });

    let app_clone = app.clone();
    install_btn.connect_clicked(move |_| {
        let mut script_cmd = String::from("echo '🐺 Initializing The Pack...'; sleep 1;");
        let base_path = "/opt/lupineos/scripts";

        if state.admin_switch.is_active() {
            script_cmd.push_str(&format!(" {}/setup_admin.sh;", base_path));
        }
        if state.sec_switch.is_active() {
            script_cmd.push_str(&format!(" {}/setup_sec.sh;", base_path));
        }
        if state.data_switch.is_active() {
            script_cmd.push_str(&format!(" {}/setup_data.sh;", base_path));
        }
        if state.dev_switch.is_active() {
            script_cmd.push_str(&format!(" {}/install_rust_tools.sh;", base_path));
        }
        
        script_cmd.push_str(" echo; echo '✅ Setup Complete. Press Enter to exit.'; read");

        // Launch Cosmic Terminal
        let _ = Command::new("cosmic-term")
            .arg("-e")
            .arg("bash")
            .arg("-c")
            .arg(&script_cmd)
            .spawn();

        let _ = mark_as_done();
        app_clone.quit();
    });

    window.present();
}

fn get_config_path() -> Option<PathBuf> {
    dirs::home_dir().map(|h| h.join(CONFIG_FILE_NAME))
}

fn is_first_run() -> bool {
    if let Some(path) = get_config_path() {
        !path.exists()
    } else {
        false 
    }
}

fn mark_as_done() -> std::io::Result<()> {
    if let Some(path) = get_config_path() {
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent)?;
        }
        fs::write(path, "done")?;
    }
    Ok(())
}
