package 'qemu-kvm'
package 'libvirt-bin'
package 'virtinst'
package 'ebtables'
package 'python-vm-builder'

include_recipe "cephco-senta::ssh-keys"
include_recipe "cephco-senta::serial"
include_recipe "cephco-senta::networking"
include_recipe "cephco-senta::libvirt"
