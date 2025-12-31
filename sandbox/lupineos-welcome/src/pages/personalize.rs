use gtk4 as gtk;
use gtk::prelude::*;
use gtk::{glib, CompositeTemplate};
use libadwaita as adw;
use libadwaita::subclass::prelude::*;

mod imp {
    use super::*;

    #[derive(Default, CompositeTemplate)]
    #[template(string = r#"
    <interface>
        <template class="PersonalizePage" parent="AdwBin">
            <child>
                <object class="AdwStatusPage">
                    <property name="title">Personalize</property>
                    <property name="description">Make LupineOS your own.</property>
                    <property name="icon-name">preferences-desktop-theme-symbolic</property>
                    
                    <child>
                        <object class="gtkBox">
                            <property name="orientation">vertical</property>
                            <property name="halign">center</property>
                            <property name="spacing">24</property>
                            <property name="margin-top">24</property>

                            <child>
                                <object class="AdwPreferencesGroup">
                                    <property name="title">Appearances</property>
                                    <property name="description">Choose your preferred theme.</property>
                                    
                                    <child>
                                        <object class="AdwActionRow">
                                            <property name="title">Dark Mode</property>
                                            <property name="subtitle">Reduces eye strain.</property>
                                            <property name="icon-name">weather-clear-night-symbolic</property>
                                            <property name="activatable-widget">dark_switch</property>
                                            <child>
                                                 <object class="gtkSwitch" id="dark_switch">
                                                    <property name="valign">center</property>
                                                 </object>
                                            </child>
                                        </object>
                                    </child>
                                </object>
                            </child>

                            <child>
                                <object class="AdwPreferencesGroup">
                                    <property name="title">Accent Color</property>
                                    <property name="description">Select a system-wide highlight color.</property>
                                    
                                    <child>
                                        <object class="AdwActionRow">
                                            <child>
                                                <object class="gtkBox">
                                                    <property name="spacing">10</property>
                                                    <child>
                                                        <object class="gtkButton" id="btn_blue">
                                                            <property name="label">Blue</property>
                                                            <style><class name="pill"/></style>
                                                        </object>
                                                    </child>
                                                    <child>
                                                        <object class="gtkButton" id="btn_purple">
                                                            <property name="label">Purple</property>
                                                            <style><class name="pill"/></style>
                                                        </object>
                                                    </child>
                                                    <child>
                                                        <object class="gtkButton" id="btn_green">
                                                            <property name="label">Green</property>
                                                            <style><class name="pill"/></style>
                                                        </object>
                                                    </child>
                                                    <child>
                                                        <object class="gtkButton" id="btn_orange">
                                                            <property name="label">Orange</property>
                                                            <style><class name="pill"/></style>
                                                        </object>
                                                    </child>
                                                </object>
                                            </child>
                                        </object>
                                    </child>
                                </object>
                            </child>

                        </object>
                    </child>
                </object>
            </child>
        </template>
    </interface>
    "#)]
    pub struct PersonalizePage {
        #[template_child]
        pub dark_switch: TemplateChild<gtk::Switch>,
        #[template_child]
        pub btn_blue: TemplateChild<gtk::Button>,
        #[template_child]
        pub btn_purple: TemplateChild<gtk::Button>,
        #[template_child]
        pub btn_green: TemplateChild<gtk::Button>,
        #[template_child]
        pub btn_orange: TemplateChild<gtk::Button>,
    }

    #[glib::object_subclass]
    impl ObjectSubclass for PersonalizePage {
        const NAME: &'static str = "PersonalizePage";
        type Type = super::PersonalizePage;
        type ParentType = adw::Bin;

        fn class_init(klass: &mut Self::Class) {
            klass.bind_template();
        }

        fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
            obj.init_template();
        }
    }

    impl ObjectImpl for PersonalizePage {
        fn constructed(&self) {
            self.parent_constructed();
            
            let dark_switch = self.dark_switch.get();
            dark_switch.connect_active_notify(|s| {
                let style_manager = adw::StyleManager::default();
                if s.is_active() {
                    style_manager.set_color_scheme(adw::ColorScheme::ForceDark);
                } else {
                    style_manager.set_color_scheme(adw::ColorScheme::ForceLight);
                }
            });

            // Mock Accent Colors
            let colors = [
                (self.btn_blue.get(), "Blue"),
                (self.btn_purple.get(), "Purple"),
                (self.btn_green.get(), "Green"),
                (self.btn_orange.get(), "Orange"),
            ];

            for (btn, name) in colors {
                btn.connect_clicked(move |_| {
                    tracing::info!("Mock Logic: Setting Accent Color to {}", name);
                });
            }
        }
    }
    impl WidgetImpl for PersonalizePage {}
    impl BinImpl for PersonalizePage {}
}

glib::wrapper! {
    pub struct PersonalizePage(ObjectSubclass<imp::PersonalizePage>)
        @extends gtk::Widget, adw::Bin;
}

impl PersonalizePage {
    pub fn new() -> Self {
        glib::Object::builder().build()
    }
}

    // We will bind signals in code instead of template callbacks for safety and older libadwaita support

