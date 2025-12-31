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
        <template class="SoftwarePage" parent="AdwBin">
            <child>
                <object class="AdwStatusPage">
                    <property name="title">Software Lab</property>
                    <property name="description">Install your favorite tools in one click.</property>
                    <property name="icon-name">applications-system-symbolic</property>
                    
                    <child>
                        <object class="gtkBox">
                            <property name="orientation">vertical</property>
                            <property name="halign">center</property>
                            <property name="spacing">24</property>
                            <property name="margin-top">24</property>

                            <child>
                                <object class="AdwPreferencesGroup">
                                    <property name="title">Web Browsers</property>
                                    <child>
                                        <object class="AdwActionRow">
                                            <property name="title">Firefox</property>
                                            <property name="subtitle">Fast, private, and safe.</property>
                                            <child>
                                                <object class="gtkCheckButton" id="chk_firefox">
                                                    <property name="valign">center</property>
                                                    <property name="active">true</property>
                                                </object>
                                            </child>
                                        </object>
                                    </child>
                                    <child>
                                        <object class="AdwActionRow">
                                            <property name="title">Chromium</property>
                                            <property name="subtitle">Open source web browser project.</property>
                                            <child>
                                                <object class="gtkCheckButton" id="chk_chromium">
                                                    <property name="valign">center</property>
                                                </object>
                                            </child>
                                        </object>
                                    </child>
                                </object>
                            </child>

                            <child>
                                <object class="AdwPreferencesGroup">
                                    <property name="title">Gaming</property>
                                    <child>
                                        <object class="AdwActionRow">
                                            <property name="title">Steam</property>
                                            <property name="subtitle">The ultimate entertainment platform.</property>
                                            <child>
                                                <object class="gtkCheckButton" id="chk_steam">
                                                    <property name="valign">center</property>
                                                </object>
                                            </child>
                                        </object>
                                    </child>
                                </object>
                            </child>

                            <child>
                                <object class="gtkButton" id="btn_install">
                                    <property name="label">Install Selected</property>
                                    <property name="halign">center</property>
                                    <style>
                                        <class name="suggested-action"/>
                                        <class name="pill"/>
                                    </style>
                                </object>
                            </child>

                        </object>
                    </child>
                </object>
            </child>
        </template>
    </interface>
    "#)]
    pub struct SoftwarePage {
        #[template_child]
        pub chk_firefox: TemplateChild<gtk::CheckButton>,
        #[template_child]
        pub chk_chromium: TemplateChild<gtk::CheckButton>,
        #[template_child]
        pub chk_steam: TemplateChild<gtk::CheckButton>,
        #[template_child]
        pub btn_install: TemplateChild<gtk::Button>,
    }

    #[glib::object_subclass]
    impl ObjectSubclass for SoftwarePage {
        const NAME: &'static str = "SoftwarePage";
        type Type = super::SoftwarePage;
        type ParentType = adw::Bin;

        fn class_init(klass: &mut Self::Class) {
            klass.bind_template();
        }

        fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
            obj.init_template();
        }
    }

    impl ObjectImpl for SoftwarePage {
        fn constructed(&self) {
            self.parent_constructed();

            let btn_install = self.btn_install.get();
            let chk_firefox = self.chk_firefox.get();
            let chk_chromium = self.chk_chromium.get();
            let chk_steam = self.chk_steam.get();

            btn_install.connect_clicked(move |_| {
                let mut apps = Vec::new();
                if chk_firefox.is_active() { apps.push("firefox"); }
                if chk_chromium.is_active() { apps.push("chromium"); }
                if chk_steam.is_active() { apps.push("steam"); }

                if apps.is_empty() {
                    tracing::warn!("No apps selected to install.");
                } else {
                    tracing::info!("Batch Installing: {:?}", apps);
                    if let Err(e) = crate::system::install_packages(&apps) {
                        tracing::error!("Failed to start install: {}", e);
                    }
                }

            });
        }
    }
    impl WidgetImpl for SoftwarePage {}
    impl BinImpl for SoftwarePage {}
}

glib::wrapper! {
    pub struct SoftwarePage(ObjectSubclass<imp::SoftwarePage>)
        @extends gtk::Widget, adw::Bin;
}

impl SoftwarePage {
    pub fn new() -> Self {
        glib::Object::builder().build()
    }
}
