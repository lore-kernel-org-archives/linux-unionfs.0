From: Vincent Bernat <bernat@luffy.cx>
Subject: 9p/overlayfs: read error when reading an empty file
Date: Sat, 15 Aug 2015 09:37:57 +0200
Message-ID: <87oai9hui2.fsf@zoro.exoscale.ch>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bart.luffy.cx ([78.47.78.131]:47025 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbbHOHsH (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 15 Aug 2015 03:48:07 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

Hi!

I have found a regression which was introduced after 4.0 in
9p/overlayfs. This regression happens when the lower directory is a 9p
mount, the upperdir is an empty tmpfs and we try to read 0 bytes from an
empty file (something than gcc is doing when trying to read an include).

The following program can be used to trigger the problem:

#v+
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, const char **argv)
{
    assert(argc == 2);
    char buffer[256];
    int fd = open(argv[1], O_RDONLY|O_NOCTTY);
    assert(fd >= 0);
    assert(read(fd, buffer, 0) == 0);
    return 0;
}
#v-

read() returns -30720.

This works fine with a 4.0 kernel and breaks with a 4.1 kernel.

However, I am unable to tell if this is fixed in more recent kernels
because I run into another bug. In 4.2-rc6, I am unable to do a switch
root on the same setup (9p lower dir, tmpfs upper dir). I get this:

[    0.566541] BUG: unable to handle kernel paging request at 000000040020006c
[    0.570248] IP: [<ffffffffa004fe4b>] v9fs_fid_find+0x5b/0x90 [9p]
[    0.570248] PGD 64ee067 PUD 0
[    0.570248] Oops: 0000 [#1] SMP
[    0.570248] Modules linked in: overlay virtio_pci 9p fscache 9pnet_virtio virtio_ring virtio 9pnet
[    0.570248] CPU: 0 PID: 1 Comm: switch_root Not tainted 4.2.0-rc6-amd64 #1 Debian 4.2~rc6-1~exp1
[    0.570248] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[    0.570248] task: ffff88000710cc00 ti: ffff880007128000 task.ti: ffff880007128000
[    0.570248] RIP: 0010:[<ffffffffa004fe4b>]  [<ffffffffa004fe4b>] v9fs_fid_find+0x5b/0x90 [9p]
[    0.570248] RSP: 0018:ffff88000712ba70  EFLAGS: 00010246
[    0.570248] RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000400200048
[    0.570248] RDX: 0000000000000001 RSI: 00000000ffffffff RDI: ffff88000688feb0
[    0.570248] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[    0.570248] R10: 000000000001ca30 R11: f000000000000000 R12: ffff88000688fe58
[    0.570248] R13: ffff88000688feb0 R14: ffff88000641a748 R15: ffff88000688e618
[    0.570248] FS:  00007fcd46a88700(0000) GS:ffff880007c00000(0000) knlGS:0000000000000000
[    0.570248] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.570248] CR2: 000000040020006c CR3: 000000000649a000 CR4: 00000000000006f0
[    0.570248] Stack:
[    0.570248]  ffff880006473000 00000000ffffffff 0000000000000000 ffff88000641a340
[    0.570248]  00000000000000e0 ffffffffa004ffc6 0000000000000000 ffff88000688e618
[    0.570248]  ffff880000c02048 0000000000000000 ffff880000014b00 ffff880006446800
[    0.570248] Call Trace:
[    0.570248]  [<ffffffffa004ffc6>] ? v9fs_fid_lookup_with_uid+0xf6/0x2d0 [9p]
[    0.570248]  [<ffffffffa0050209>] ? v9fs_fid_lookup+0x69/0x70 [9p]
[    0.570248]  [<ffffffffa005021e>] ? v9fs_fid_clone+0xe/0x30 [9p]
[    0.570248]  [<ffffffffa004e773>] ? v9fs_file_open+0xb3/0x190 [9p]
[    0.570248]  [<ffffffffa004e6c0>] ? v9fs_vfs_readpage+0x20/0x20 [9p]
[    0.570248]  [<ffffffff811b4596>] ? do_dentry_open+0x1c6/0x2e0
[    0.570248]  [<ffffffff811c3243>] ? path_openat+0x1d3/0x14a0
[    0.570248]  [<ffffffff81173d27>] ? follow_page_pte+0x267/0x360
[    0.570248]  [<ffffffff811c5e05>] ? do_filp_open+0x75/0xd0
[    0.570248]  [<ffffffff811bc736>] ? do_open_execat+0x66/0x150
[    0.570248]  [<ffffffff811bc84a>] ? open_exec+0x2a/0x50
[    0.570248]  [<ffffffff812069de>] ? load_script+0x1de/0x230
[    0.570248]  [<ffffffff811bc0ee>] ? copy_strings.isra.21+0x27e/0x2d0
[    0.570248]  [<ffffffff811bc3a3>] ? search_binary_handler+0x93/0x1b0
[    0.570248]  [<ffffffff811bd884>] ? do_execveat_common.isra.32+0x544/0x6c0
[    0.570248]  [<ffffffff811cbf9a>] ? dput+0x2a/0x220
[    0.570248]  [<ffffffff811bdc85>] ? SyS_execve+0x35/0x40
[    0.570248]  [<ffffffff8154c465>] ? stub_execve+0x5/0x5
[    0.570248]  [<ffffffff8154c132>] ? system_call_fast_compare_end+0xc/0x6b
[    0.570248] Code: 89 ef e8 39 bf 4f e1 49 8b 44 24 78 48 8d 48 c0 48 85 c0 b8 00 00 00 00 48 0f 44 c8 eb 04 48 83 e9 40 48 85 c9 74 12 85 ed 75 0e <3b> 59 24 74 09 48 8b 49 40 48 85 c9 75 e5 4c 89 ef c6 07 00 0f
[    0.570248] RIP  [<ffffffffa004fe4b>] v9fs_fid_find+0x5b/0x90 [9p]
[    0.570248]  RSP <ffff88000712ba70>
[    0.570248] CR2: 000000040020006c
[    0.690182] ---[ end trace 40caffb61d0461c6 ]---
[    0.693741] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    0.693741]
[    0.696018] Kernel Offset: disabled

Trying to bisect this one, I end up into another bug when mounting a 9p
filesystem:

# mount -t 9p configshare /tmp/config -o trans=virtio,version=9p2000.u,access=0,rw
mount: mounting configshare on /tmp/config failed: Invalid argument

However, this one has been fixed between v4.1 and v4.2-rc6. It just
makes git bisecting difficult.

I am using a shell script to setup all that:
 https://github.com/vincentbernat/eudyptula-boot

The gist is something like that:
  mkdir /tmp/target
  mkdir /tmp/target/ro
  mkdir /tmp/target/overlay
  mkdir /tmp/target/rw
  mount -n -t 9p rootshare /tmp/target/ro -o trans=virtio,version=9p2000.u,ro
  mount -n -t tmpfs tmpfs  /tmp/target/rw -o rw
  mkdir /tmp/target/rw/workdir
  mkdir /tmp/target/rw/upperdir
  mount -n -t $1 overlayfs /tmp/target/overlay \
     -o lowerdir=/tmp/target/ro,upperdir=/tmp/target/rw/upperdir,workdir=/tmp/target/rw/workdir,noatime 
  mkdir /tmp/target/overlay/tmp/config
  mount --bind /tmp/config /tmp/target/overlay/tmp/config
  
  cp /init /tmp/target/overlay/tmp
  exec switch_root /tmp/target/overlay /tmp/init

I am currently in the process to do a git bisect between 4.0 and 4.1 to
find the commit that have introduced the first bug, but any hint is
welcome.
-- 
Use variable names that mean something.
            - The Elements of Programming Style (Kernighan & Plauger)
