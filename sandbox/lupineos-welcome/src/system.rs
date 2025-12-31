use std::process::Command;

pub fn update_system() -> Result<(), String> {
    // Uses pkexec to request password for root privileges
    // Spawns a terminal to show progress since rpm-ostree takes time
    // In a real app, we might want to capture stdout/stderr and show it in the GUI
    
    // For now, let's try to spawn it in a terminal context if possible, 
    // or just run it and hope the user has a polkit agent running.
    // A better UX for a Welcome App is often to open a terminal window running the command.
    
    // Command: gnome-terminal -- bash -c "rpm-ostree upgrade; read -p 'Press Enter to close'"
    // Adjust for available terminal. using 'kgx' (GNOME Console) or 'gnome-terminal'
    
    let status = Command::new("kgx")
        .arg("-e")
        .arg("bash -c 'pkexec rpm-ostree upgrade; echo \"Done. Reboot to apply.\"; read -p \"Press Enter to close\"'")
        .spawn()
        .map_err(|e| format!("Failed to spawn terminal: {}", e))?;

    Ok(())
}

pub fn install_packages(packages: &[&str]) -> Result<(), String> {
    if packages.is_empty() {
        return Ok(());
    }

    let package_list = packages.join(" ");
    let cmd = format!("flatpak install -y {}; echo \"Done.\"; read -p \"Press Enter to close\"", package_list);

    let _ = Command::new("kgx")
        .arg("-e")
        .arg("bash")
        .arg("-c")
        .arg(&cmd)
        .spawn()
        .map_err(|e| format!("Failed to spawn terminal: {}", e))?;

    Ok(())
}

pub fn set_dark_mode(enabled: bool) {
    let scheme = if enabled { "prefer-dark" } else { "default" };
    
    // Sets the global portal setting for dark mode
    let _ = Command::new("gsettings")
        .args(["set", "org.gnome.desktop.interface", "color-scheme", scheme])
        .spawn();
}
