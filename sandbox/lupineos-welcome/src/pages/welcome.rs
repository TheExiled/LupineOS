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
        <template class="WelcomePage" parent="AdwBin">
            <child>
                <object class="AdwStatusPage">
                    <property name="title">Welcome to LupineOS</property>
                    <property name="description">Experience the future of Atomic Linux.</property>
                    <property name="icon-name">computer-symbolic</property>

                    <child>
                        <object class="gtkBox">
                            <property name="orientation">vertical</property>
                            <property name="halign">center</property>
                            <property name="spacing">12</property>
                            
                            <child>
                                <object class="gtkButton">
                                    <property name="label">Start Setup</property>
                                    <property name="action-name">win.start-setup</property>
                                    <style>
                                        <class name="pill"/>
                                        <class name="suggested-action"/>
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
    pub struct WelcomePage;

    #[glib::object_subclass]
    impl ObjectSubclass for WelcomePage {
        const NAME: &'static str = "WelcomePage";
        type Type = super::WelcomePage;
        type ParentType = adw::Bin;

        fn class_init(klass: &mut Self::Class) {
            klass.bind_template();
        }

        fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
            obj.init_template();
        }
    }

    impl ObjectImpl for WelcomePage {}
    impl WidgetImpl for WelcomePage {}
    impl BinImpl for WelcomePage {}

}

glib::wrapper! {
    pub struct WelcomePage(ObjectSubclass<imp::WelcomePage>)
        @extends gtk::Widget, adw::Bin;
}

impl WelcomePage {
    pub fn new() -> Self {
        glib::Object::builder().build()
    }
}
