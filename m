From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: kernel BUG at arch/x86/mm/physaddr.c:LINE!
Date: Wed, 10 Oct 2018 19:08:45 +0300
Message-ID: <CAOQ4uxivKY8hjfKbr-MAg4WXP8f5Bb9_bhuOcMnvwdm=-V03QQ@mail.gmail.com>
References: <0000000000000542c10577e14e22@google.com> <alpine.DEB.2.21.1810101721430.15060@nanos.tec.linutronix.de>
 <CACT4Y+YLWiZqctdUfGDJuFdHAPkpYcCo5efaWyZ=bmOsRG8LFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0000000000004d95b40577e21249"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+YLWiZqctdUfGDJuFdHAPkpYcCo5efaWyZ=bmOsRG8LFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, syzbot+ff03fe05c717b82502d0@syzkaller.appspotmail.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, linux-kernel <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, syzkaller-bugs@googlegroups.com, x86@kernel.org, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

--0000000000004d95b40577e21249
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 10, 2018 at 6:36 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, Oct 10, 2018 at 5:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 10 Oct 2018, syzbot wrote:
> >
> > Cc+: Miklos
>
> It seems reasonable to ignore arch/.*/mm/physaddr.c as suspected
> guilty file in future -- we already ignore everything related to
> kmalloc/kfree and this is called from kfree.
> I've made the corresponding change to syzkaller:
> https://github.com/google/syzkaller/commit/ba8cd6d708b97d6be4f9164758b6a7c690d252b2
>
> Thanks for re-routing this one, Thomas!
>
>
> >> Hello,
> >>
> >> syzbot found the following crash on:
> >>
> >> HEAD commit:    0854ba5ff5c9 Merge git://git.kernel.org/pub/scm/linux/kern..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=15e64ea1400000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=88e9a8a39dc0be2d
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=ff03fe05c717b82502d0
> >> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e516a1400000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d6e93a400000
> >>
> >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >> Reported-by: syzbot+ff03fe05c717b82502d0@syzkaller.appspotmail.com
> >>
> >> RBP: 00007ffc881226c0 R08: 0000000020000100 R09: 0000000000000100
> >> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> >> R13: ffffffffffffffff R14: 0000000000000000 R15: 0000000000000000
> >> overlayfs: failed to verify origin (syzkaller.Ry8w8Y/file0, ino=16483,
> >> err=-12)
> >> ------------[ cut here ]------------
> >> kernel BUG at arch/x86/mm/physaddr.c:22!
> >> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> >> CPU: 0 PID: 5918 Comm: syz-executor189 Not tainted 4.19.0-rc7+ #53
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
> >> 01/01/2011
> >> RIP: 0010:__phys_addr+0xff/0x120 arch/x86/mm/physaddr.c:22
> >> Code: 3c 02 00 75 31 4c 8b 25 ff c3 ee 07 48 89 de bf ff ff ff 1f e8 a2 7a 46
> >> 00 49 01 dc 48 81 fb ff ff ff 1f 76 a7 e8 61 79 46 00 <0f> 0b e8 6a e9 89 00
> >> e9 7a ff ff ff e8 c0 e9 89 00 eb c8 0f 1f 40
> >> RSP: 0018:ffff8801c3387770 EFLAGS: 00010093
> >> RAX: ffff8801c323a080 RBX: 000000007ffffff4 RCX: ffffffff81385c1e
> >> RDX: 0000000000000000 RSI: ffffffff81385c2f RDI: 0000000000000007
> >> RBP: ffff8801c3387788 R08: ffff8801c323a080 R09: ffffed003b5c4fe8
> >> R10: ffffed003b5c4fe8 R11: ffff8801dae27f47 R12: 000000007ffffff4
> >> R13: 0000000000000001 R14: ffffffff882f8c80 R15: 0000000000004063
> >> FS:  000000000148d880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
> >> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> CR2: 0000000000619570 CR3: 00000001c4ab0000 CR4: 00000000001406f0
> >> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >> Call Trace:
> >> virt_to_head_page include/linux/mm.h:658 [inline]
> >> virt_to_cache mm/slab.c:399 [inline]
> >> kfree+0x7b/0x230 mm/slab.c:3809
> >> ovl_verify_set_fh+0xba/0x180 fs/overlayfs/namei.c:435
> >> ovl_verify_origin fs/overlayfs/overlayfs.h:316 [inline]
> >> ovl_get_indexdir fs/overlayfs/super.c:1139 [inline]
> >> ovl_fill_super+0x3026/0x3f7b fs/overlayfs/super.c:1441
> >> mount_nodev+0x6b/0x110 fs/super.c:1204
> >> ovl_mount+0x2c/0x40 fs/overlayfs/super.c:1518
> >> mount_fs+0xae/0x31d fs/super.c:1261
> >> vfs_kern_mount.part.35+0xdc/0x4f0 fs/namespace.c:961
> >> vfs_kern_mount fs/namespace.c:951 [inline]
> >> do_new_mount fs/namespace.c:2457 [inline]
> >> do_mount+0x581/0x31f0 fs/namespace.c:2787
> >> ksys_mount+0x12d/0x140 fs/namespace.c:3003
> >> __do_sys_mount fs/namespace.c:3017 [inline]
> >> __se_sys_mount fs/namespace.c:3014 [inline]
> >> __x64_sys_mount+0xbe/0x150 fs/namespace.c:3014
> >> do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> >> entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >> RIP: 0033:0x4418e9
> >> Code: 26 02 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48
> >> 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f
> >> 83 cb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> >> RSP: 002b:00007ffc88122678 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> >> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004418e9
> >> RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 0000000000400000
> >> RBP: 00007ffc881226c0 R08: 0000000020000100 R09: 0000000000000100
> >> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> >> R13: ffffffffffffffff R14: 0000000000000000 R15: 0000000000000000
> >> Modules linked in:
> >> ---[ end trace 25e838f694c8a24f ]---
> >> RIP: 0010:__phys_addr+0xff/0x120 arch/x86/mm/physaddr.c:22
> >> Code: 3c 02 00 75 31 4c 8b 25 ff c3 ee 07 48 89 de bf ff ff ff 1f e8 a2 7a 46
> >> 00 49 01 dc 48 81 fb ff ff ff 1f 76 a7 e8 61 79 46 00 <0f> 0b e8 6a e9 89 00
> >> e9 7a ff ff ff e8 c0 e9 89 00 eb c8 0f 1f 40
> >> RSP: 0018:ffff8801c3387770 EFLAGS: 00010093
> >> RAX: ffff8801c323a080 RBX: 000000007ffffff4 RCX: ffffffff81385c1e
> >> RDX: 0000000000000000 RSI: ffffffff81385c2f RDI: 0000000000000007
> >> RBP: ffff8801c3387788 R08: ffff8801c323a080 R09: ffffed003b5c4fe8
> >> R10: ffffed003b5c4fe8 R11: ffff8801dae27f47 R12: 000000007ffffff4
> >> R13: 0000000000000001 R14: ffffffff882f8c80 R15: 0000000000004063
> >> FS:  000000000148d880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
> >> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> CR2: 0000000000619570 CR3: 00000001c4ab0000 CR4: 00000000001406f0
> >> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >>
> >>

Not sure syzbot takes attachements, but here is the fix.

Thanks,
Amir.

--0000000000004d95b40577e21249
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-ovl-fix-error-handling-in-ovl_verify_set_fh.patch"
Content-Disposition: attachment;
	filename="0001-ovl-fix-error-handling-in-ovl_verify_set_fh.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jn3cmll90>
X-Attachment-Id: f_jn3cmll90

RnJvbSA0OWM0YzIxYjM3Y2NiZGMzOTY4MGIwZGMwZjEwOTVjMTc1NWY1YjlhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDEwIE9jdCAyMDE4IDE4OjU3OjUwICswMzAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBmaXggZXJyb3IgaGFuZGxpbmcgaW4gb3ZsX3ZlcmlmeV9zZXRfZmgoKQoKV2UgaGl0IGEgQlVH
IG9uIGtmcmVlIG9mIGFuIEVSUl9QVFIoKS4uLgoKUmVwb3J0ZWQtYnk6IHN5emJvdCtmZjAzZmUw
NWM3MTdiODI1MDJkMEBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tCkZpeGVzOiA4Yjg4YTJlNjQw
MzYgKCJvdmw6IHZlcmlmeSB1cHBlciByb290IGRpciBtYXRjaGVzIGxvd2VyIHJvb3QgZGlyIikK
Q2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIHY0LjEzClNpZ25lZC1vZmYtYnk6IEFtaXIg
R29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+Ci0tLQogZnMvb3ZlcmxheWZzL25hbWVpLmMg
fCA0ICsrKy0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvbmFtZWkuYyBiL2ZzL292ZXJsYXlmcy9uYW1laS5j
CmluZGV4IDljMGNhNmE3YmVjZi4uZWZkMzcyMzEyZWYxIDEwMDY0NAotLS0gYS9mcy9vdmVybGF5
ZnMvbmFtZWkuYworKysgYi9mcy9vdmVybGF5ZnMvbmFtZWkuYwpAQCAtNDIyLDggKzQyMiwxMCBA
QCBpbnQgb3ZsX3ZlcmlmeV9zZXRfZmgoc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBjb25zdCBjaGFy
ICpuYW1lLAogCiAJZmggPSBvdmxfZW5jb2RlX3JlYWxfZmgocmVhbCwgaXNfdXBwZXIpOwogCWVy
ciA9IFBUUl9FUlIoZmgpOwotCWlmIChJU19FUlIoZmgpKQorCWlmIChJU19FUlIoZmgpKSB7CisJ
CWZoID0gTlVMTDsKIAkJZ290byBmYWlsOworCX0KIAogCWVyciA9IG92bF92ZXJpZnlfZmgoZGVu
dHJ5LCBuYW1lLCBmaCk7CiAJaWYgKHNldCAmJiBlcnIgPT0gLUVOT0RBVEEpCi0tIAoyLjE3LjEK
Cg==
--0000000000004d95b40577e21249--
