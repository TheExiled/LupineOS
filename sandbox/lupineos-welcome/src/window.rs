use gtk4 as gtk;
use gtk::prelude::*;
use gtk::{gio, glib, CompositeTemplate};
use libadwaita as adw;
use libadwaita::subclass::prelude::*;

use crate::pages::{WelcomePage, AtomicPage, PersonalizePage, SoftwarePage};

mod imp {

    use super::*;

    #[derive(Default, CompositeTemplate)]
    #[template(string = r#"
    <interface>
      <template class="LupineWelcomeWindow" parent="AdwApplicationWindow">
        <property name="title">Welcome to LupineOS</property>
        <property name="default-width">1100</property>
        <property name="default-height">750</property>
        <child>
            <object class="AdwOverlaySplitView">
                <property name="sidebar-position">start</property>
                
                <property name="sidebar">
                    <object class="AdwStatusPage">
                        <property name="title">Menu</property>
                        <child>
                            <object class="gtkListBox" id="sidebar_list">
                                <property name="selection-mode">single</property>
                                <style>
                                    <class name="navigation-sidebar"/>
                                </style>
                                <child>
                                    <object class="AdwActionRow">
                                        <property name="name">welcome_row</property>
                                        <property name="title">Welcome</property>
                                        <property name="icon-name">star-symbolic</property>
                                    </object>
                                </child>
                                <child>
                                    <object class="AdwActionRow">
                                        <property name="name">atomic_row</property>
                                        <property name="title">Atomic Mastery</property>
                                        <property name="icon-name">system-software-install-symbolic</property>
                                    </object>
                                </child>
                                <child>
                                    <object class="AdwActionRow">
                                        <property name="name">personalize_row</property>
                                        <property name="title">Personalize</property>
                                        <property name="icon-name">preferences-desktop-theme-symbolic</property>
                                    </object>
                                </child>
                                <child>
                                    <object class="AdwActionRow">
                                        <property name="name">software_row</property>
                                        <property name="title">Software Lab</property>
                                        <property name="icon-name">applications-system-symbolic</property>
                                    </object>
                                </child>
                            </object>
                        </child>
                    </object>
                </property>
                
                <property name="content">
                    <object class="AdwViewStack" id="view_stack">
                        <child>
                            <object class="AdwViewStackPage">
                                <property name="name">welcome</property>
                                <property name="child">
                                    <object class="WelcomePage" id="welcome_page" />
                                </property>
                            </object>
                        </child>
                        <child>
                            <object class="AdwViewStackPage">
                                <property name="name">atomic</property>
                                <property name="title">Atomic Mastery</property>
                                <property name="child">
                                    <object class="AtomicPage" id="atomic_page" />
                                </property>
                            </object>
                        </child>
                        <child>
                            <object class="AdwViewStackPage">
                                <property name="name">personalize</property>
                                <property name="title">Personalize</property>
                                <property name="child">
                                    <object class="PersonalizePage" id="personalize_page" />
                                </property>
                            </object>
                        </child>
                        <child>
                            <object class="AdwViewStackPage">
                                <property name="name">software</property>
                                <property name="title">Software Lab</property>
                                <property name="child">
                                    <object class="SoftwarePage" id="software_page" />
                                </property>
                            </object>
                        </child>
                    </object>

                </property>

            </object>
        </child>
      </template>
    </interface>
    "#)]
    pub struct LupineWelcomeWindow {
        #[template_child]
        pub view_stack: TemplateChild<adw::ViewStack>,
        #[template_child]
        pub sidebar_list: TemplateChild<gtk::ListBox>,
    }

    #[glib::object_subclass]
    impl ObjectSubclass for LupineWelcomeWindow {
        const NAME: &'static str = "LupineWelcomeWindow";
        type Type = super::LupineWelcomeWindow;
        type ParentType = adw::ApplicationWindow;

        fn class_init(klass: &mut Self::Class) {
            klass.bind_template();
        }

        fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
            obj.init_template();
        }
    }

    impl ObjectImpl for LupineWelcomeWindow {
        fn constructed(&self) {
            self.parent_constructed();
            let obj = self.obj();
            
            let sidebar_list = self.sidebar_list.get();
            let view_stack = self.view_stack.get();

            sidebar_list.connect_row_activated(move |_, row| {
                let name = row.widget_name();
                let page_name = match name.as_str() {
                    "welcome_row" => "welcome",
                    "atomic_row" => "atomic", // Placeholder
                    "personalize_row" => "personalize",
                    "software_row" => "software",
                    _ => return,
                };

                view_stack.set_visible_child_name(page_name);
            });

        }
    }

    impl WidgetImpl for LupineWelcomeWindow {}
    impl WindowImpl for LupineWelcomeWindow {}
    impl ApplicationWindowImpl for LupineWelcomeWindow {}
    impl AdwApplicationWindowImpl for LupineWelcomeWindow {}
}

glib::wrapper! {
    pub struct LupineWelcomeWindow(ObjectSubclass<imp::LupineWelcomeWindow>)
        @extends gtk::Widget, gtk::Window, gtk::ApplicationWindow, adw::ApplicationWindow,
        @implements gio::ActionMap, gio::ActionGroup;
}

impl LupineWelcomeWindow {
    pub fn new<P: glib::IsA<gtk::Application>>(app: &P) -> Self {
        glib::Object::builder()
            .property("application", app)
            .build()
    }
}
