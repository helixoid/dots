#!/bin/bash

# --- Script Configuration and Setup ---
# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u

# Define script-specific constants
PACKAGES_FILE="packages.txt" # Name of the file containing packages to install
# Log file path in the user's HOME directory, with a timestamp for uniqueness
LOG_FILE="$HOME/arch_install_$(date +%Y%m%d_%H%M%S).log"

# --- Logging Function ---
# This function prints messages to the console and appends them to the log file.
log_message() {
  local message="$1"
  # Print to console
  echo "--> $message"
  # Append to log file with a timestamp
  echo "$(date +%Y-%m-%d_%H:%M:%S) --> $message" >>"$LOG_FILE"
}

# --- Core Functions ---

# Function to check for root privileges
# Exits the script if not run as root.
check_root_privileges() {
  if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges to install packages." | tee -a "$LOG_FILE"
    echo "Please run it with 'sudo ./$(basename "$0")'" | tee -a "$LOG_FILE"
    exit 1
  fi
  log_message "Root privileges confirmed. Starting installation."
}

# Function to install paru-bin (AUR Helper)
# Checks if paru is already installed, otherwise builds and installs it.
install_paru_bin() {
  log_message "--- Starting paru-bin installation ---"

  if command -v paru &>/dev/null; then
    log_message "paru is already installed. Skipping paru-bin installation."
    return 0 # Indicate success
  fi

  log_message "paru not found. Attempting to install paru-bin from AUR..."

  # Ensure git and base-devel are installed, as they are required for building AUR packages.
  log_message "Ensuring git and base-devel are installed (required for makepkg)..."
  # Note: 'pacman' is run without 'sudo' here because the script itself is already running as root.
  pacman -S --needed --noconfirm git base-devel 2>&1 | tee -a "$LOG_FILE"

  # Create a secure temporary directory for building paru.
  # mktemp -d creates a unique directory and is safer than a fixed path.
  local TEMP_DIR=$(mktemp -d)
  log_message "Created temporary build directory: $TEMP_DIR"

  # Clone the paru-bin AUR repository into the temporary directory.
  log_message "Cloning paru-bin AUR repository..."
  git clone https://aur.archlinux.org/paru-bin.git "$TEMP_DIR/paru-bin" 2>&1 | tee -a "$LOG_FILE" ||
    {
      log_message "Error: Failed to clone paru-bin repository. Exiting."
      exit 1
    }

  # Build and install paru-bin.
  log_message "Building and installing paru-bin..."
  (
    # Change to the cloned directory.
    # The '||' ensures that if cd fails, an error is logged and the script exits.
    cd "$TEMP_DIR/paru-bin" || {
      log_message "Error: Could not change directory to paru-bin. Exiting."
      exit 1
    }
    # makepkg -si builds the package and then installs it. --noconfirm prevents prompts.
    makepkg -si --noconfirm 2>&1 | tee -a "$LOG_FILE" ||
      {
        log_message "Error: Failed to build or install paru-bin. Exiting."
        exit 1
      }
  )

  # Clean up the temporary directory.
  log_message "Cleaning up temporary build directory: $TEMP_DIR"
  rm -rf "$TEMP_DIR" 2>&1 | tee -a "$LOG_FILE"

  log_message "paru-bin installed successfully!"
}

# Function to install GPU drivers based on user input
install_gpu_drivers() {
  log_message "--- Starting GPU driver installation ---"

  local gpu_choice=""
  local intel_gen_choice=""
  local packages_to_install=""

  while true; do
    read -p "Which GPU hardware do you have? (i) Intel, (a) AMD, (n) Nvidia: " -n 1 -r gpu_choice
    echo                                                          # Move to a new line after input
    gpu_choice=$(echo "$gpu_choice" | tr '[:upper:]' '[:lower:]') # Convert input to lowercase

    case "$gpu_choice" in
    i)
      log_message "Intel GPU selected."
      # Add thermald for Intel CPUs
      packages_to_install="thermald"
      while true; do
        read -p "Is your Intel CPU 11th generation or newer? (y/n): " -n 1 -r intel_gen_choice
        echo # Move to a new line
        intel_gen_choice=$(echo "$intel_gen_choice" | tr '[:upper:]' '[:lower:]')

        case "$intel_gen_choice" in
        y)
          log_message "Intel 11th Gen or newer detected. Adding vpl-gpu-rt and vulkan-intel."
          packages_to_install+=" vpl-gpu-rt vulkan-intel"
          break 2 # Exit both inner and outer loops
          ;;
        n)
          log_message "Intel 10th Gen or older detected. Adding intel-media-driver and vulkan-intel."
          packages_to_install+=" intel-media-driver vulkan-intel"
          break 2 # Exit both inner and outer loops
          ;;
        *)
          log_message "Invalid choice for Intel generation. Please enter 'y' or 'n'."
          ;;
        esac
      done
      ;;
    a)
      log_message "AMD GPU selected. Installing vulkan-radeon."
      packages_to_install="vulkan-radeon"
      break # Exit outer loop
      ;;
    n)
      log_message "Nvidia GPU selected. Installing nvidia-open-dkms nvidia-utils."
      packages_to_install="nvidia-open-dkms nvidia-utils"
      break # Exit outer loop
      ;;
    *)
      log_message "Invalid choice. Please enter 'i' for Intel, 'a' for AMD, or 'n' for Nvidia."
      ;;
    esac
  done

  if [[ -n "$packages_to_install" ]]; then
    log_message "Installing selected GPU and related packages: $packages_to_install"
    # 'pacman' is run without 'sudo' as the script is already running as root.
    pacman -S --needed --noconfirm $packages_to_install 2>&1 | tee -a "$LOG_FILE" ||
      { log_message "Warning: Failed to install some GPU driver packages. Please check the log."; }
  else
    log_message "No GPU driver packages selected for installation."
  fi

  log_message "--- GPU driver installation finished ---"
}

# Function to install packages from packages.txt
install_packages_from_file() {
  log_message "--- Starting package installation from $PACKAGES_FILE ---"

  if [[ ! -f "$PACKAGES_FILE" ]]; then
    log_message "Error: The file '$PACKAGES_FILE' was not found in the current directory."
    log_message "Please create it and list your desired packages, one per line."
    exit 1
  fi

  log_message "Installing packages listed in $PACKAGES_FILE..."

  # Read packages line by line.
  # IFS= prevents leading/trailing whitespace issues.
  # -r prevents backslash escapes from being interpreted.
  while IFS= read -r package; do
    # Remove leading/trailing whitespace from package name
    package=$(echo "$package" | xargs)

    # Skip empty lines and lines starting with # (comments).
    if [[ -z "$package" || "$package" =~ ^# ]]; then
      continue
    fi

    log_message "Attempting to install: $package"
    # 'pacman' is run without 'sudo' as the script is already running as root.
    if pacman -S --needed --noconfirm "$package" 2>&1 | tee -a "$LOG_FILE"; then
      log_message "Successfully installed/skipped (already installed): $package"
    else
      log_message "Warning: Failed to install $package. It might be an AUR package or an invalid name."
      log_message "If it's an AUR package, you might need to install it manually using 'paru -S $package'."
    fi
  done <"$PACKAGES_FILE"

  log_message "--- Package installation from $PACKAGES_FILE finished ---"
}

# --- Main Script Execution ---
main() {
  # Initialize log file with a header
  echo "Arch Linux System Setup Log - $(date)" >"$LOG_FILE"
  echo "=======================================" >>"$LOG_FILE"

  log_message "Starting Arch Linux system setup script..."
  log_message "Log file location: $LOG_FILE"

  check_root_privileges
  install_paru_bin
  install_gpu_drivers
  install_packages_from_file

  log_message "Script finished. All sections have been processed."
  log_message "Please review any warnings or errors in the log file for failed installations."
  echo "" # Add an empty line for better readability

  echo "========================================================" | tee -a "$LOG_FILE"
  echo "Installation complete. For detailed logs, please check:" | tee -a "$LOG_FILE"
  echo "$LOG_FILE" | tee -a "$LOG_FILE"
  echo "========================================================" | tee -a "$LOG_FILE"
}

# Call the main function to start the script execution
main
