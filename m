From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular
 file using O_TMPFILE") breaks ubifs
Date: Tue, 28 Mar 2017 12:45:45 +0200
Message-ID: <20170328124545.3c4b87ff@gmail.com>
References: <20170328100107.25095af6@gmail.com>
        <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34204 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754921AbdC1Kqe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Mar 2017 06:46:34 -0400
In-Reply-To: <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, regressions@leemhuis.info, Ralph Sennhauser <ralph.sennhauser@gmail.com>

On Tue, 28 Mar 2017 05:27:03 -0400
Amir Goldstein <amir73il@gmail.com> wrote:

> On Tue, Mar 28, 2017 at 4:01 AM, Ralph Sennhauser
> <ralph.sennhauser@gmail.com> wrote:
> > Hi Amir
> >
> > Commit d8514d8edb5b ("ovl: copy up regular file using O_TMPFILE")
> > breaks squashfs with an ubifs overlay (both ubi volumes of the same
> > container).
> >  
> 
> Hi Ralph,
> 
> I am confused by the description above. Which are the 'both ubi
> volumes'?

The ubi container has two volumes, the first is a squashfs, the second
volume an ubifs. The latter is mounted as an overlay.
 
> 
> Can you provide exact command of overlayfs mount, preferably
> also a script to generate the lower/upper images and mount them
> to remove any mkfs option doubts from test setup.

Both I mount from the initramfs as follows (rom / overlay are empty in
the initramfs):

  mount -o rw,nosuid,nodev,noexec,noatime -t proc proc /proc || rescue_shell "proc"
  mount -o rw,nosuid,nodev,noexec,noatime -t sysfs sysfs /sys || rescue_shell "sys"
  mount -o rw,nosuid -t devtmpfs devtmpfs /dev || rescue_shell "dev"

  ubiattach -m $(get_mtd_from_root_arg) /dev/ubi_ctrl || rescue_shell "attach"
  ubiblock --create /dev/ubi0_0 || rescue_shell || "block"

  mount -o ro -t squashfs /dev/ubiblock0_0 /rom || rescue_shell "mount rootfs"
  mount -o rw,noatime -t ubifs /dev/ubi0_1 /overlay || rescue_shell "mount rootfs_data"

  mkdir -p /overlay/upper || rescue_shell "mkdir upper"
  mkdir -p /overlay/work || rescue_shell "mkdir work"

  mount -o rw,noatime,lowerdir=/rom,upperdir=/overlay/upper,workdir=/overlay/work \
          -t overlay overlay /newroot || rescue_shell "mount overlay"

  mount --move /rom /newroot/rom || rescue_shell "move rootfs"
  mount --move /overlay /newroot/overlay || rescue_shell "move rootfs_data"

  mount --move /dev /newroot/dev || rescue_shell "move dev"
  mount --move /sys /newroot/sys || rescue_shell "move sys"
  mount --move /proc /newroot/proc || rescue_shell "move proc"

  exec switch_root /newroot /sbin/init

I use OpenWrt as a basis, replacing the kernel with a vanilla one.

The options used to generate the file systems are:

Squashfs:  -p 128KiB -m 2048 -s 512 -O 2048
Ubifs: -m 2048 -e 124KiB -c 4096 -F

> 
> > Renaming a file results in an error "UBIFS error (ubi0:1 pid 1394):
> > ubifs_add_orphan: orphaned twice". This corrupts the the filesystem
> > and the next attempt to mount the overlay will fail.
> >  
> 
> Does that happen on any attempt to rename a file?
> A file that was only is lower I suppose?

That's how I trigger it, yes. Can reproduce it on any attempt.

> Can you provide a simple script with your test, setting up the
> lower/upper files and triggering the bug.

Any more you need than the above mount script? A call to "mv somefile
somefile.back && reboot" on a fresh install is all I do.

Thanks
Ralph

PS: Reverting 01ad3eb8a073 ("ovl: concurrent copy up of regular files")
as a dependency and the commit mentioned in Subject fix the issue for
me. Tested on v4.11-rc4 and next-20170327.
