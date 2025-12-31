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
        <template class="AtomicPage" parent="AdwBin">
            <child>
                <object class="AdwStatusPage">
                    <property name="title">Atomic Mastery</property>
                    <property name="description">LupineOS is an immutable operating system.</property>
                    <property name="icon-name">system-software-install-symbolic</property>
                    
                    <child>
                        <object class="gtkBox">
                            <property name="orientation">vertical</property>
                            <property name="halign">center</property>
                            <property name="spacing">24</property>
                            <property name="margin-top">24</property>

                            <child>
                                <object class="AdwPreferencesGroup">
                                    <property name="title">Unbreakable Reliability</property>
                                    <property name="description">System files are read-only. Updates are applied in the background.</property>
                                    <child>
                                        <object class="AdwActionRow">
                                            <property name="title">Update System</property>
                                            <property name="subtitle">Downloads the latest image.</property>
                                            <child>
                                                <object class="gtkButton" id="update_button">
                                                    <property name="label">Update Now</property>
                                                    <property name="valign">center</property>
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

                            <child>
                                <object class="AdwPreferencesGroup">
                                    <property name="title">Safety Net</property>
                                    <property name="description">Update broke something? You can always go back.</property>
                                    <child>
                                        <object class="AdwActionRow">
                                            <property name="title">How to Rollback</property>
                                            <property name="subtitle">Hold 'Shift' during boot to select the previous version.</property>
                                            <child>
                                                <object class="gtkImage">
                                                    <property name="icon-name">edit-undo-symbolic</property>
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
    pub struct AtomicPage {
        #[template_child]
        pub update_button: TemplateChild<gtk::Button>,
    }

    #[glib::object_subclass]
    impl ObjectSubclass for AtomicPage {
        const NAME: &'static str = "AtomicPage";
        type Type = super::AtomicPage;
        type ParentType = adw::Bin;

        fn class_init(klass: &mut Self::Class) {
            klass.bind_template();
        }

        fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
            obj.init_template();
        }
    }

    impl ObjectImpl for AtomicPage {
        fn constructed(&self) {
            self.parent_constructed();
            
            let update_button = self.update_button.get();
            update_button.connect_clicked(|_| {
                tracing::info!("Mock Logic: Triggering System Update (rpm-ostree upgrade)");
            });
        }
    }
    impl WidgetImpl for AtomicPage {}
    impl BinImpl for AtomicPage {}
}

glib::wrapper! {
    pub struct AtomicPage(ObjectSubclass<imp::AtomicPage>)
        @extends gtk::Widget, adw::Bin;
}

impl AtomicPage {
    pub fn new() -> Self {
        glib::Object::builder().build()
    }
}
