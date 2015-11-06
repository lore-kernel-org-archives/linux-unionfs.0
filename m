From: Jeff Mahoney <jeffm@jeffm.io>
Subject: Re: kernel BUG when fsync'ing file in a overlayfs merged dir, located
 on btrfs
Date: Thu, 5 Nov 2015 21:57:35 -0500
Message-ID: <563C171F.30702@jeffm.io>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ox9t372uwrWrsNUl5H7aepGuJ8ceQQfT8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Roman Lebedev <lebedev.ri@gmail.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
List-Id: linux-unionfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ox9t372uwrWrsNUl5H7aepGuJ8ceQQfT8
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/30/15 3:57 PM, Roman Lebedev wrote:
> Hello.
>=20
> My / is btrfs.
> To do some my local stuff more cleanly i wanted to use overlayfs,=20
> but it didn't quite work.
>=20
> Simple non-automatic sequence to reproduce the issue:
>  mkdir lower upper work merged
>  mount -t overlay overlay -olowerdir=3Dlower,upperdir=3Dupper,workdir=3D=
work merged
>  vi merged/file
>  :wq

Filipe and I got a chance to look into this today.  The crash is due to
commit 4bacc9c9234 (overlayfs: Make f_path always point to the overlay
and f_inode to the underlay)  Incidentally, the test case is as simple
as ":> file ; fsync file" after mounting.

The short version is that after this commit, we see:

file->f_mapping->host =3D <actual fs inode>
file->f_inode =3D <actual fs inode>
file->f_path.dentry->d_inode =3D <overlayfs inode>

So now file_operations callbacks can't assume that file->f_path.dentry
belongs to the same file system that implements the callback.  More than
that, any code that could ultimately get a dentry that comes from an
open file can't trust that it's from the same file system.

This crash is due to this issue.  Unlike xfs and ext2/3/4, we use
file->f_path.dentry->d_inode to resolve the inode.  Using file_inode()
is an easy enough fix here, but we run into trouble later.  We have
logic in the btrfs fsync() call path (check_parent_dirs_for_sync) that
walks back up the dentry chain examining the inode's last transaction
and last unlink transaction to determine whether a full transaction
commit is required.  This obviously doesn't work if we're walking the
overlayfs path instead.  Regardless of any argument over whether that's
doing the right thing, it's a pretty common pattern to assume that
file->f_path.dentry comes from the same file system when using a
file_operation.  Is it intended that that assumption is no longer valid?

-Jeff

> Results in vi being killed on exit, and the following trace appears in =
dmesg:
>=20
> [34304.047841] BUG: unable to handle kernel paging request at 000000000=
9618e56
> [34304.047846] IP: [<ffffffffa01667b6>] btrfs_sync_file+0xa6/0x350 [btr=
fs]
> [34304.047864] PGD 0=20
> [34304.047866] Oops: 0002 [#12] SMP=20
> [34304.047867] Modules linked in: overlay cpufreq_userspace cpufreq_sta=
ts cpufreq_powersave cpufreq_conservative binfmt_misc nfsd auth_rpcgss oi=
d_registry nfs_acl nfs lockd grace fscache sunrpc fglrx(PO) nls_utf8 joyd=
ev nls_cp437 vfat fat hid_generic usbhid kvm_amd hid kvm crct10dif_pclmul=
 crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek snd_hda_codec_gen=
eric snd_hda_codec_hdmi sha256_ssse3 sha256_generic snd_hda_intel snd_hda=
_codec hmac drbg ansi_cprng aesni_intel snd_hda_core aes_x86_64 mxm_wmi s=
nd_hwdep lrw eeepc_wmi snd_pcm gf128mul asus_wmi sparse_keymap rfkill vid=
eo snd_timer glue_helper sp5100_tco evdev ablk_helper e1000e ohci_pci pcs=
pkr snd ohci_hcd xhci_pci edac_mce_amd ehci_pci serio_raw xhci_hcd soundc=
ore fam15h_power ehci_hcd cryptd edac_core ptp pps_core usbcore k10temp i=
2c_piix4
> [34304.047893]  sg usb_common acpi_cpufreq wmi tpm_infineon button proc=
essor shpchp tpm_tis tpm thermal_sys tcp_yeah tcp_vegas it87 hwmon_vid lo=
op parport_pc ppdev lp parport autofs4 crc32c_generic btrfs xor raid6_pq =
sd_mod crc32c_intel ahci libahci libata scsi_mod
> [34304.047905] CPU: 4 PID: 13990 Comm: vi Tainted: P      D    O    4.2=
=2E0-1-amd64 #1 Debian 4.2.1-2
> [34304.047906] Hardware name: To be filled by O.E.M. To be filled by O.=
E.M./CROSSHAIR V FORMULA-Z, BIOS 2201 03/23/2015
> [34304.047908] task: ffff8803d5f7f2c0 ti: ffff8806a3ec8000 task.ti: fff=
f8806a3ec8000
> [34304.047909] RIP: 0010:[<ffffffffa01667b6>]  [<ffffffffa01667b6>] btr=
fs_sync_file+0xa6/0x350 [btrfs]
> [34304.047920] RSP: 0018:ffff8806a3ecbe88  EFLAGS: 00010246
> [34304.047921] RAX: ffff8803d5f7f2c0 RBX: ffff8807b2d46600 RCX: fffffff=
f81a6ad00
> [34304.047922] RDX: 0000000080000000 RSI: 0000000000000000 RDI: ffff880=
7c19f8970
> [34304.047923] RBP: ffff8807c19f8970 R08: 0000000000000000 R09: 0000000=
000000001
> [34304.047924] R10: 0000000000000000 R11: 0000000000000246 R12: ffff880=
7c19f88c8
> [34304.047925] R13: 0000000000000000 R14: 0000000009618b22 R15: 000055c=
b20184a70
> [34304.047926] FS:  00007f31c5492800(0000) GS:ffff88082fd00000(0000) kn=
lGS:0000000000000000
> [34304.047927] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [34304.047928] CR2: 0000000009618e56 CR3: 000000044af44000 CR4: 0000000=
0000406e0
> [34304.047929] Stack:
> [34304.047930]  0000000000000001 7fffffffffffffff ffff880403d5b918 8000=
000000000000
> [34304.047932]  0000000000000000 0000000000000000 000055cb20186d40 ffff=
8807b2d46600
> [34304.047933]  0000000000000004 ffff88044b249000 0000000000000020 ffff=
8807b2d46600
> [34304.047935] Call Trace:
> [34304.047939]  [<ffffffff811e7038>] ? do_fsync+0x38/0x60
> [34304.047940]  [<ffffffff811e72b0>] ? SyS_fsync+0x10/0x20
> [34304.047943]  [<ffffffff8154de72>] ? system_call_fast_compare_end+0xc=
/0x6b
> [34304.047944] Code: 49 8b 0f 48 85 c9 75 e9 eb b3 48 8b 44 24 08 49 8d=
 ac 24 a8 00 00 00 48 89 ef 4c 29 e8 48 83 c0 01 48 89 44 24 18 e8 3a 59 =
3e e1 <f0> 41 ff 86 34 03 00 00 49 8b 84 24 70 ff ff ff 48 c1 e8 07 83=20
> [34304.047959] RIP  [<ffffffffa01667b6>] btrfs_sync_file+0xa6/0x350 [bt=
rfs]
> [34304.047970]  RSP <ffff8806a3ecbe88>
> [34304.047970] CR2: 0000000009618e56
> [34304.047972] ---[ end trace 414199893a542949 ]---
>=20
> I was able to create a new fstests test that reproduces my issue,
> and i'm sending it as follow-up to this message.
>=20
> Roman Lebedev (1):
>   fstests: generic: Test that fsync works on file in overlayfs merged
>     directory
>=20
>  tests/generic/111     | 80 +++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  tests/generic/111.out |  5 ++++
>  tests/generic/group   |  1 +
>  3 files changed, 86 insertions(+)
>  create mode 100755 tests/generic/111
>  create mode 100644 tests/generic/111.out
>=20


--=20
Jeff Mahoney
SUSE Labs



--ox9t372uwrWrsNUl5H7aepGuJ8ceQQfT8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJWPBciAAoJEB57S2MheeWyAxEP/jiGkDos7xnAWUXszeUmHjGv
UjnFp2VAUaoa6GG0BDWMxoJnaFk+3XGnNrfXYv8nZeTv/spyS3J4rzfL5OWGSxT3
WBjlqZ3Fw2tQrvJxgIyuhrvnQjdeO5CGb+VBRDQ8oANAROES4eHi1KK7pn/++Vg1
eLHq8ys8Zpu9bNChyVTXqlPxkiNx+seHwh45EYzS8lBUeb5A6NhKMacHBVOnM7dp
aZW3WMCYJkyN5ez8lLGuYq/mbFH9yHek0NuUzx3Z/swxzP87PBhC8WhclavPH2hp
eJTn/N0JRJRrxX4jmaHVPDqppm17VuCpqysHn98+lDFp/S8X/vjxVnLfcMsJpc0C
D/oKNiyMSmYIe6hs3xGGHv8JZq9ikfc6cZwDoO4p4LdguZp6IuEOaxUHLl5V8CDk
5oKIfam5/DTFNdpEpRtcdvtnoMqW1Zc6oU7n7+d+qJotuY1yrTv9jidQh9cG8rLg
enMSsjbjh83z6+LV8QbbpVxGDtP2gQhjAwzka29zCtwYwDsgkYRCO6JMnoRVA1rH
tVM/yDgCuXYpyckwvYHaNevBycGq4iaibFcgf+NDKiB295JQx/GhJqD9Z6u3tyXm
GJNRRV01B+fCZ1uN1rVMhzV8CpqUu3xJeC2TUgzLC/InQSe4WkbjiGGl61rt50E1
wJo3gGNC8/LSpx3vy0h4
=/Rpg
-----END PGP SIGNATURE-----

--ox9t372uwrWrsNUl5H7aepGuJ8ceQQfT8--
