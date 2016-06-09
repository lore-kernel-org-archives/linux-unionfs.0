Return-Path: <ericvh@gmail.com>
MIME-Version: 1.0
References: <CAPk1OjE6exSg2OA5y-K6=2hdNzto3_UyBhn2QT_YRBVbc5g2wQ@mail.gmail.com>
In-Reply-To: <CAPk1OjE6exSg2OA5y-K6=2hdNzto3_UyBhn2QT_YRBVbc5g2wQ@mail.gmail.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Thu, 09 Jun 2016 23:00:28 +0000
Message-ID: <CAFkjPTneuH4aoeZoM61RuUb2j-KptqGPWrkkYnv5oHgXxDgBzg@mail.gmail.com>
Subject: Re: WARNING and OOPS using 9p with overlay
Content-Type: multipart/alternative; boundary=001a114e60a401293e0534e0648c
To: Alessio Igor Bogani <alessioigorbogani@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>, Miklos Szeredi <miklos@szeredi.hu>, Ron Minnich <rminnich@sandia.gov>
Cc: linux-unionfs@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-ID: <linux-unionfs@vger.kernel.org>

--001a114e60a401293e0534e0648c
Content-Type: text/plain; charset=UTF-8

There have been problems reported in the past, but this looks different.
I'll try and free up sometime this weekend to take a closer look....

On Thu, Jun 9, 2016 at 7:36 AM Alessio Igor Bogani <
alessioigorbogani@gmail.com> wrote:

> Hi All,
>
> I obtain this warning message mounting a 9p filesystem using overlay:
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 110 at /fs/inode.c:337 inc_nlink+0x74/0x78
> Modules linked in:
> CPU: 0 PID: 110 Comm: mount Not tainted 4.7.0-rc2 #2
> Hardware name: Generic AM33XX (Flattened Device Tree)
> [<c010ff7c>] (unwind_backtrace) from [<c010c6dc>] (show_stack+0x20/0x24)
> [<c010c6dc>] (show_stack) from [<c04a9848>] (dump_stack+0x24/0x28)
> [<c04a9848>] (dump_stack) from [<c012d130>] (__warn+0xf4/0x10c)
> [<c012d130>] (__warn) from [<c012d218>] (warn_slowpath_null+0x30/0x38)
> [<c012d218>] (warn_slowpath_null) from [<c024f990>] (inc_nlink+0x74/0x78)
> [<c024f990>] (inc_nlink) from [<c0373a70>]
> (v9fs_vfs_mkdir_dotl+0x140/0x1dc)
> [<c0373a70>] (v9fs_vfs_mkdir_dotl) from [<c0240220>] (vfs_mkdir+0xc0/0x10c)
> [<c0240220>] (vfs_mkdir) from [<c036e3a4>] (ovl_create_real+0xc4/0x100)
> [<c036e3a4>] (ovl_create_real) from [<c036ccf0>]
> (ovl_fill_super+0x984/0x9a8)
> [<c036ccf0>] (ovl_fill_super) from [<c0236d00>] (mount_nodev+0x54/0xac)
> [<c0236d00>] (mount_nodev) from [<c036bcec>] (ovl_mount+0x24/0x28)
> [<c036bcec>] (ovl_mount) from [<c0237d30>] (mount_fs+0x54/0x170)
> [<c0237d30>] (mount_fs) from [<c0255a00>] (vfs_kern_mount+0x58/0x124)
> [<c0255a00>] (vfs_kern_mount) from [<c025911c>] (do_mount+0x1f0/0xd1c)
> [<c025911c>] (do_mount) from [<c0259f8c>] (SyS_mount+0x84/0xac)
> [<c0259f8c>] (SyS_mount) from [<c0108160>] (ret_fast_syscall+0x0/0x3c)
> ---[ end trace 87b507e269adb5b5 ]---
>
> So executing `cat README.txt` inside the overlayed mountpoint brings me to:
>
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000008
> pgd = cdd20000
> [00000008] *pgd=8dd74831, *pte=00000000, *ppte=00000000
> Internal error: Oops: 17 [#1] PREEMPT ARM
> Modules linked in:
> CPU: 0 PID: 114 Comm: cat Tainted: G        W       4.7.0-rc2 #2
> Hardware name: Generic AM33XX (Flattened Device Tree)
> task: cdae9000 ti: cdd3a000 task.ti: cdd3a000
> PC is at idr_get_empty_slot+0x18/0x3a4
> LR is at idr_alloc+0xc0/0x11c
> pc : [<c04aad20>]    lr : [<c04ab16c>]    psr: 600b0093
> sp : cdd3bc70  ip : cdd3bcb8  fp : cdd3bcb4
> r10: 00000000  r9 : 00000000  r8 : 00000001
> r7 : 00000000  r6 : cdd3bcc4  r5 : 200b0013  r4 : 00000000
> r3 : 02000000  r2 : cdd3bcc4  r1 : 00000000  r0 : 00000000
> Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c5387d  Table: 8dd20019  DAC: 00000051
> Process cat (pid: 114, stack limit = 0xcdd3a210)
> Stack: (0xcdd3bc70 to 0xcdd3c000)
> bc60:                                     cfeb7494 cfeb7484 cdd3bca4
> cdd3bc88
> bc80: c01d6344 c0174870 cda7d6b0 00000000 200b0013 cdd3bcc4 00000000
> 00000000
> bca0: 00000000 00000000 cdd3bcfc cdd3bcb8 c04ab16c c04aad14 00000000
> cdd3bcc8
> bcc0: c04c61b4 c04c6064 cdd3bcfc cdd3bcd8 c04aa22c c04c61a4 c0fabe28
> 00000000
> bce0: 200b0013 00000000 cdd4b800 00000000 cdd3bd1c cdd3bd00 c08c195c
> c04ab0b8
> bd00: 02000000 00000000 cdd6a2c0 cdd94c88 cdd3bd3c cdd3bd20 c08c017c
> c08c1914
> bd20: 00000000 cdd94c8c cdd94c88 00000000 cdd3bd7c cdd3bd40 c08c04cc
> c08c0144
> bd40: 00008000 00000000 cdd27780 cd3ddb28 cdd4b800 00000000 00000000
> cdd27780
> bd60: cd3ddb28 cdd4b800 00000000 00000000 cdd3bd8c cdd3bd80 c03765f4
> c08c0498
> bd80: cdd3bdbc cdd3bd90 c0374900 c03765d0 c045dfd8 c027a1ac 00000000
> cdd27780
> bda0: cdd27788 c037485c cd3ddb28 cdd9e880 cdd3bdec cdd3bdc0 c0230fa8
> c0374868
> bdc0: cdd9e880 cdd27780 cdd3bea8 00000000 00000000 cdd3bea8 00000000
> 00000000
> bde0: cdd3be0c cdd3bdf0 c0232240 c0230de8 c02400e4 cdd9e880 00000000
> cdd3bf5c
> be00: cdd3bea4 cdd3be10 c024277c c02321e0 c01155bc c01517b0 cdd3bebc
> cdd3be28
> be20: c020a0d0 c0115560 00000000 00000000 00000000 cfeb54e0 fffffdfa
> cdd3a000
> be40: cdd27780 00000000 00000000 00000004 cd3d9330 00000041 cdd22db8
> 00000000
> be60: 00000002 cd3db3d0 cdd68e50 cd3da3b8 cdc7e630 b6fd1000 cdc7ea50
> 00000003
> be80: cdd3bf5c cdd3bea8 00000001 c0108368 cdd3a000 00000000 cdd3bf4c
> cdd3bea8
> bea0: c0244308 c0242224 cdd68e50 cd3da3b8 a4a3e205 0000000a cdd77010
> c0165310
> bec0: 00000000 c0f217d4 cd3db3d0 00000101 00000002 00000040 00000000
> 00000000
> bee0: 00000000 cdd3bee8 00000003 cd88da80 cd88da94 00000000 00000400
> c02543f4
> bf00: cdd3bf3c cdd3bf10 c02543f4 c01517b0 00000000 00000000 cdd77000
> 00000000
> bf20: 00000005 c0108368 ffffff9c 00000000 00000003 ffffff9c cdd77000
> 00000005
> bf40: cdd3bf94 cdd3bf50 c02325a8 c02442a4 cdd3bf6c cdd3bf60 c0235834
> 00000000
> bf60: cdd30000 00000004 00000100 00000001 bec37e88 bec37f72 0000000a
> 00000005
> bf80: c0108368 cdd3a000 cdd3bfa4 cdd3bf98 c0232684 c0232498 00000000
> cdd3bfa8
> bfa0: c0108160 c0232664 bec37e88 bec37f72 bec37f72 00000000 000001b6
> 0000004d
> bfc0: bec37e88 bec37f72 0000000a 00000005 00093ac0 bec37f72 00093af4
> 00000000
> bfe0: 00000000 bec37cc4 00010f1c b6ec435c 600b0010 bec37f72 8fef6861
> 8fef6c61
> [<c04aad20>] (idr_get_empty_slot) from [<c04ab16c>] (idr_alloc+0xc0/0x11c)
> [<c04ab16c>] (idr_alloc) from [<c08c195c>] (p9_idpool_get+0x54/0xd8)
> [<c08c195c>] (p9_idpool_get) from [<c08c017c>] (p9_fid_create+0x44/0x110)
> [<c08c017c>] (p9_fid_create) from [<c08c04cc>] (p9_client_walk+0x40/0x228)
> [<c08c04cc>] (p9_client_walk) from [<c03765f4>] (v9fs_fid_clone+0x30/0x38)
> [<c03765f4>] (v9fs_fid_clone) from [<c0374900>] (v9fs_file_open+0xa4/0x150)
> [<c0374900>] (v9fs_file_open) from [<c0230fa8>]
> (do_dentry_open+0x1cc/0x31c)
> [<c0230fa8>] (do_dentry_open) from [<c0232240>] (vfs_open+0x6c/0x90)
> [<c0232240>] (vfs_open) from [<c024277c>] (path_openat+0x564/0x120c)
> [<c024277c>] (path_openat) from [<c0244308>] (do_filp_open+0x70/0xd4)
> [<c0244308>] (do_filp_open) from [<c02325a8>] (do_sys_open+0x11c/0x1cc)
> [<c02325a8>] (do_sys_open) from [<c0232684>] (SyS_open+0x2c/0x30)
> [<c0232684>] (SyS_open) from [<c0108160>] (ret_fast_syscall+0x0/0x3c)
> Code: e24cb004 e24dd01c e3a08001 e1a09000 (e5907008)
> ---[ end trace 87b507e269adb5b6 ]---
> note: cat[114] exited with preempt_count 2
> Segmentation fault
>
> Is 9p supposed to work with overlay?
>
> Thanks!
>
> Ciao,
> Alessio
>

--001a114e60a401293e0534e0648c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div style=3D"white-space:pre-wrap">There have been problems reported in th=
e past, but this looks different.  I&#39;ll try and free up sometime this w=
eekend to take a closer look....</div><br><div class=3D"gmail_quote"><div d=
ir=3D"ltr">On Thu, Jun 9, 2016 at 7:36 AM Alessio Igor Bogani &lt;<a href=
=3D"mailto:alessioigorbogani@gmail.com" target=3D"_blank">alessioigorbogani=
@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi All,<=
br>
<br>
I obtain this warning message mounting a 9p filesystem using overlay:<br>
<br>
------------[ cut here ]------------<br>
WARNING: CPU: 0 PID: 110 at /fs/inode.c:337 inc_nlink+0x74/0x78<br>
Modules linked in:<br>
CPU: 0 PID: 110 Comm: mount Not tainted 4.7.0-rc2 #2<br>
Hardware name: Generic AM33XX (Flattened Device Tree)<br>
[&lt;c010ff7c&gt;] (unwind_backtrace) from [&lt;c010c6dc&gt;] (show_stack+0=
x20/0x24)<br>
[&lt;c010c6dc&gt;] (show_stack) from [&lt;c04a9848&gt;] (dump_stack+0x24/0x=
28)<br>
[&lt;c04a9848&gt;] (dump_stack) from [&lt;c012d130&gt;] (__warn+0xf4/0x10c)=
<br>
[&lt;c012d130&gt;] (__warn) from [&lt;c012d218&gt;] (warn_slowpath_null+0x3=
0/0x38)<br>
[&lt;c012d218&gt;] (warn_slowpath_null) from [&lt;c024f990&gt;] (inc_nlink+=
0x74/0x78)<br>
[&lt;c024f990&gt;] (inc_nlink) from [&lt;c0373a70&gt;] (v9fs_vfs_mkdir_dotl=
+0x140/0x1dc)<br>
[&lt;c0373a70&gt;] (v9fs_vfs_mkdir_dotl) from [&lt;c0240220&gt;] (vfs_mkdir=
+0xc0/0x10c)<br>
[&lt;c0240220&gt;] (vfs_mkdir) from [&lt;c036e3a4&gt;] (ovl_create_real+0xc=
4/0x100)<br>
[&lt;c036e3a4&gt;] (ovl_create_real) from [&lt;c036ccf0&gt;] (ovl_fill_supe=
r+0x984/0x9a8)<br>
[&lt;c036ccf0&gt;] (ovl_fill_super) from [&lt;c0236d00&gt;] (mount_nodev+0x=
54/0xac)<br>
[&lt;c0236d00&gt;] (mount_nodev) from [&lt;c036bcec&gt;] (ovl_mount+0x24/0x=
28)<br>
[&lt;c036bcec&gt;] (ovl_mount) from [&lt;c0237d30&gt;] (mount_fs+0x54/0x170=
)<br>
[&lt;c0237d30&gt;] (mount_fs) from [&lt;c0255a00&gt;] (vfs_kern_mount+0x58/=
0x124)<br>
[&lt;c0255a00&gt;] (vfs_kern_mount) from [&lt;c025911c&gt;] (do_mount+0x1f0=
/0xd1c)<br>
[&lt;c025911c&gt;] (do_mount) from [&lt;c0259f8c&gt;] (SyS_mount+0x84/0xac)=
<br>
[&lt;c0259f8c&gt;] (SyS_mount) from [&lt;c0108160&gt;] (ret_fast_syscall+0x=
0/0x3c)<br>
---[ end trace 87b507e269adb5b5 ]---<br>
<br>
So executing `cat README.txt` inside the overlayed mountpoint brings me to:=
<br>
<br>
Unable to handle kernel NULL pointer dereference at virtual address 0000000=
8<br>
pgd =3D cdd20000<br>
[00000008] *pgd=3D8dd74831, *pte=3D00000000, *ppte=3D00000000<br>
Internal error: Oops: 17 [#1] PREEMPT ARM<br>
Modules linked in:<br>
CPU: 0 PID: 114 Comm: cat Tainted: G=C2=A0 =C2=A0 =C2=A0 =C2=A0 W=C2=A0 =C2=
=A0 =C2=A0 =C2=A04.7.0-rc2 #2<br>
Hardware name: Generic AM33XX (Flattened Device Tree)<br>
task: cdae9000 ti: cdd3a000 task.ti: cdd3a000<br>
PC is at idr_get_empty_slot+0x18/0x3a4<br>
LR is at idr_alloc+0xc0/0x11c<br>
pc : [&lt;c04aad20&gt;]=C2=A0 =C2=A0 lr : [&lt;c04ab16c&gt;]=C2=A0 =C2=A0 p=
sr: 600b0093<br>
sp : cdd3bc70=C2=A0 ip : cdd3bcb8=C2=A0 fp : cdd3bcb4<br>
r10: 00000000=C2=A0 r9 : 00000000=C2=A0 r8 : 00000001<br>
r7 : 00000000=C2=A0 r6 : cdd3bcc4=C2=A0 r5 : 200b0013=C2=A0 r4 : 00000000<b=
r>
r3 : 02000000=C2=A0 r2 : cdd3bcc4=C2=A0 r1 : 00000000=C2=A0 r0 : 00000000<b=
r>
Flags: nZCv=C2=A0 IRQs off=C2=A0 FIQs on=C2=A0 Mode SVC_32=C2=A0 ISA ARM=C2=
=A0 Segment none<br>
Control: 10c5387d=C2=A0 Table: 8dd20019=C2=A0 DAC: 00000051<br>
Process cat (pid: 114, stack limit =3D 0xcdd3a210)<br>
Stack: (0xcdd3bc70 to 0xcdd3c000)<br>
bc60:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cfeb7494 cfeb=
7484 cdd3bca4 cdd3bc88<br>
bc80: c01d6344 c0174870 cda7d6b0 00000000 200b0013 cdd3bcc4 00000000 000000=
00<br>
bca0: 00000000 00000000 cdd3bcfc cdd3bcb8 c04ab16c c04aad14 00000000 cdd3bc=
c8<br>
bcc0: c04c61b4 c04c6064 cdd3bcfc cdd3bcd8 c04aa22c c04c61a4 c0fabe28 000000=
00<br>
bce0: 200b0013 00000000 cdd4b800 00000000 cdd3bd1c cdd3bd00 c08c195c c04ab0=
b8<br>
bd00: 02000000 00000000 cdd6a2c0 cdd94c88 cdd3bd3c cdd3bd20 c08c017c c08c19=
14<br>
bd20: 00000000 cdd94c8c cdd94c88 00000000 cdd3bd7c cdd3bd40 c08c04cc c08c01=
44<br>
bd40: 00008000 00000000 cdd27780 cd3ddb28 cdd4b800 00000000 00000000 cdd277=
80<br>
bd60: cd3ddb28 cdd4b800 00000000 00000000 cdd3bd8c cdd3bd80 c03765f4 c08c04=
98<br>
bd80: cdd3bdbc cdd3bd90 c0374900 c03765d0 c045dfd8 c027a1ac 00000000 cdd277=
80<br>
bda0: cdd27788 c037485c cd3ddb28 cdd9e880 cdd3bdec cdd3bdc0 c0230fa8 c03748=
68<br>
bdc0: cdd9e880 cdd27780 cdd3bea8 00000000 00000000 cdd3bea8 00000000 000000=
00<br>
bde0: cdd3be0c cdd3bdf0 c0232240 c0230de8 c02400e4 cdd9e880 00000000 cdd3bf=
5c<br>
be00: cdd3bea4 cdd3be10 c024277c c02321e0 c01155bc c01517b0 cdd3bebc cdd3be=
28<br>
be20: c020a0d0 c0115560 00000000 00000000 00000000 cfeb54e0 fffffdfa cdd3a0=
00<br>
be40: cdd27780 00000000 00000000 00000004 cd3d9330 00000041 cdd22db8 000000=
00<br>
be60: 00000002 cd3db3d0 cdd68e50 cd3da3b8 cdc7e630 b6fd1000 cdc7ea50 000000=
03<br>
be80: cdd3bf5c cdd3bea8 00000001 c0108368 cdd3a000 00000000 cdd3bf4c cdd3be=
a8<br>
bea0: c0244308 c0242224 cdd68e50 cd3da3b8 a4a3e205 0000000a cdd77010 c01653=
10<br>
bec0: 00000000 c0f217d4 cd3db3d0 00000101 00000002 00000040 00000000 000000=
00<br>
bee0: 00000000 cdd3bee8 00000003 cd88da80 cd88da94 00000000 00000400 c02543=
f4<br>
bf00: cdd3bf3c cdd3bf10 c02543f4 c01517b0 00000000 00000000 cdd77000 000000=
00<br>
bf20: 00000005 c0108368 ffffff9c 00000000 00000003 ffffff9c cdd77000 000000=
05<br>
bf40: cdd3bf94 cdd3bf50 c02325a8 c02442a4 cdd3bf6c cdd3bf60 c0235834 000000=
00<br>
bf60: cdd30000 00000004 00000100 00000001 bec37e88 bec37f72 0000000a 000000=
05<br>
bf80: c0108368 cdd3a000 cdd3bfa4 cdd3bf98 c0232684 c0232498 00000000 cdd3bf=
a8<br>
bfa0: c0108160 c0232664 bec37e88 bec37f72 bec37f72 00000000 000001b6 000000=
4d<br>
bfc0: bec37e88 bec37f72 0000000a 00000005 00093ac0 bec37f72 00093af4 000000=
00<br>
bfe0: 00000000 bec37cc4 00010f1c b6ec435c 600b0010 bec37f72 8fef6861 8fef6c=
61<br>
[&lt;c04aad20&gt;] (idr_get_empty_slot) from [&lt;c04ab16c&gt;] (idr_alloc+=
0xc0/0x11c)<br>
[&lt;c04ab16c&gt;] (idr_alloc) from [&lt;c08c195c&gt;] (p9_idpool_get+0x54/=
0xd8)<br>
[&lt;c08c195c&gt;] (p9_idpool_get) from [&lt;c08c017c&gt;] (p9_fid_create+0=
x44/0x110)<br>
[&lt;c08c017c&gt;] (p9_fid_create) from [&lt;c08c04cc&gt;] (p9_client_walk+=
0x40/0x228)<br>
[&lt;c08c04cc&gt;] (p9_client_walk) from [&lt;c03765f4&gt;] (v9fs_fid_clone=
+0x30/0x38)<br>
[&lt;c03765f4&gt;] (v9fs_fid_clone) from [&lt;c0374900&gt;] (v9fs_file_open=
+0xa4/0x150)<br>
[&lt;c0374900&gt;] (v9fs_file_open) from [&lt;c0230fa8&gt;] (do_dentry_open=
+0x1cc/0x31c)<br>
[&lt;c0230fa8&gt;] (do_dentry_open) from [&lt;c0232240&gt;] (vfs_open+0x6c/=
0x90)<br>
[&lt;c0232240&gt;] (vfs_open) from [&lt;c024277c&gt;] (path_openat+0x564/0x=
120c)<br>
[&lt;c024277c&gt;] (path_openat) from [&lt;c0244308&gt;] (do_filp_open+0x70=
/0xd4)<br>
[&lt;c0244308&gt;] (do_filp_open) from [&lt;c02325a8&gt;] (do_sys_open+0x11=
c/0x1cc)<br>
[&lt;c02325a8&gt;] (do_sys_open) from [&lt;c0232684&gt;] (SyS_open+0x2c/0x3=
0)<br>
[&lt;c0232684&gt;] (SyS_open) from [&lt;c0108160&gt;] (ret_fast_syscall+0x0=
/0x3c)<br>
Code: e24cb004 e24dd01c e3a08001 e1a09000 (e5907008)<br>
---[ end trace 87b507e269adb5b6 ]---<br>
note: cat[114] exited with preempt_count 2<br>
Segmentation fault<br>
<br>
Is 9p supposed to work with overlay?<br>
<br>
Thanks!<br>
<br>
Ciao,<br>
Alessio<br>
</blockquote></div>

--001a114e60a401293e0534e0648c--
