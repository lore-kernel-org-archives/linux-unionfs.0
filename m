Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD156C4361B
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Dec 2020 23:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69A3C23716
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Dec 2020 23:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgLPXB6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgLPXB6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Dec 2020 18:01:58 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7ADC061794
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Dec 2020 15:01:17 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id d8so25115350otq.6
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Dec 2020 15:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GP76KkTAIEEVNNvAubY4uUQr4Am/J3ySunFeXltjJYg=;
        b=vc5vCHiN098TxetITC9ugohWXRDPLA3M/HgGD5M3YBtbwTw9Oj2naWn4E927CaaOIe
         N5abnnNc4W1AvRGNWGvBmlxkmm7hOIrzfRicmIxMeO4qd6q/dbiVXpHPhYvtt9Ck+3j8
         aHPdraahtUJLOswQw6UGD5aSMmDFXEpLyADI6RZOvttVHKp/mvGOC/S/mkYzcFxKKkuZ
         GeO4McUm59lObyIuYE+EeKvM8TXX/AU35mymrJU7KF/SBRCijHGUwVg61F8uF2klLbIT
         MCTUc9fjZa7TenO7zLpVZBwfSYiXfNozYM/RJJXrMqKwvbkVRPyANL/nBaNFzG+vFxLx
         VKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GP76KkTAIEEVNNvAubY4uUQr4Am/J3ySunFeXltjJYg=;
        b=GWM5LPO6PCTaEScqRwiqZGGMugu285UPPXNMeJsh+j0zrXwBR9gN3dBFrEqSJ24uuz
         iVioPSaMKfOIwzvIViXpnWJfR42LnhVALlN1Lev591t+9Waitu0Zur0NwIGOag16gQSH
         XoYJz3GV8KmLiZr+OozKrUqvp1mmCtQr99fRKMtTEabPglPL9Udu9e0iq1cbW0I8VNQ3
         NQtKPUqUMiqTXzlBdtzsbL/i3Ml1wP6mI620PC/RQRAtPyDzDo7PzdAiSDxjty3idpQ4
         /Ju+PilpHcH9MNIGRD5JIX1VeB1u6WASYZ0G7TkbzG8KjQPeKmNcPqSVfSAI21MNqjiA
         zIbw==
X-Gm-Message-State: AOAM532jm9Rfh2sLA0GBv2l0ePcRzkU38blIyAfgDhjepIh92Jf/QfZu
        x2ahQOsavt/H1JwHC0XthiGKC+geAPjmoZanHiQ/2sXPn2dxvw==
X-Google-Smtp-Source: ABdhPJw3jp0sNLE64IeuFOL2sB/ovMAJaOBjUu3nsTKyteqLc0yaR57fp51C6RsIdPDhZF3Tv1nK0f6WyGLLqSMtF88=
X-Received: by 2002:a9d:5549:: with SMTP id h9mr26451116oti.230.1608159675462;
 Wed, 16 Dec 2020 15:01:15 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com> <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
In-Reply-To: <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
From:   Michael Labriola <michael.d.labriola@gmail.com>
Date:   Wed, 16 Dec 2020 18:01:04 -0500
Message-ID: <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: multipart/mixed; boundary="00000000000032d0f205b69cda78"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--00000000000032d0f205b69cda78
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 16, 2020 at 2:49 PM Michael Labriola
<michael.d.labriola@gmail.com> wrote:
>
> On Wed, Dec 16, 2020 at 1:05 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Dec 15, 2020 at 9:29 PM Michael Labriola
> > <michael.d.labriola@gmail.com> wrote:
> > >
> > > On Tue, Dec 15, 2020 at 11:31 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On Tue, Dec 15, 2020 at 5:33 PM Michael D Labriola
> > > > <michael.d.labriola@gmail.com> wrote:
> > > > >
> > > > > On Mon, Dec 14, 2020 at 6:06 PM Michael D Labriola <michael.d.labriola@gmail.com> wrote:
> > > > > >
> > > > > > I'm sporatically getting "no data available" as a reason to fail to
> > > > > > open files on an overlay mount.  Most obvious is during ln of backup
> > > > > > file during apt install.  Only seems to happen on copy_up from lower
> > > >
> > > > How do you know that? Do you have some more tracing info?
> > >
> > > I haven't done any tracing, perhaps I overstated.  The problem I'm
> > > seeing only happens when overlayfs goes to create a copy of a lower
> > > layer file in the upper layer.  When the problem occurs, it's always
> > > on a file that exists on lower but not upper, and is about to be
> > > modified.
> > >
> > > >
> > > > > > layer.  Lower layer is squashfs (I've seen it happen with both the
> > > > > > default zlib and also zstd compression), upper is EXT4.
> > > > > >
> > > > > > I've only bumped into this problem recently with 5.9+ kernels.  I'm
> > > > > > gonna go see if I can reproduce in some older kernels I still have
> > > > > > installed.
> > > > >
> > > > > Rebooting into 5.4 made the problem go away and I can apt upgrade
> > > > > w/out any problems.  Rebooting an affected virtual machine into 5.8
> > > > > also fixed the problem, so it looks to be something introduced in 5.9.
> > > >
> > > > There are no overlayfs changes v5.8..v5.9 nor squashfs changes.
> > > > Are you sure that your reproducer is reliable enough for the bisection?
> > > > If it is, please try to bisect the offending commit because I have no idea
> > > > where it may be.
> > >
> > > I'm having a hard time reproducing the problem.  It's only happening
> > > frequently enough for me to be pretty sure it's a bug.  I've been
> > > using an overlay of squashfs/EXT4 on my development laptop for over a
> > > year, using the squashfs image to fork off disposable virtual machines
> > > for testing.  It's worked flawlessly up until I started testing w/
> > > 5.9... but I couldn't correlate my problems to anything specific until
> > > just recently.
> > >
> > > More than once now, my host system or a virtual machine has randomly
> > > failed to process an apt update.  Either a backup hardlink creation
> > > fails or some other processing command fails, always with an error
> > > message of "No data available", which makes no sense to me.  Booting
> > > back into my 5.4 or 5.8 kernel and performing the upgrade, then back
> > > into my 5.9 kernel alleviates the problem until it happens again on
> > > some other package.
> > >
> > > I have also seen "No data available" pop up in seemingly random
> > > places.  For example, yesterday postfix refused to send mail, and when
> > > I went to restart the service I got this:
> > >
> > > postfix/bounce[24836]: fatal: open lock file pid/unix.bounce: cannot
> > > open file: No data available
> > >
> > > Today, in 5.9.14, I did an apt upgrade which didn't fail creating
> > > backup files, but instead failed doing a postinstall task like this:
> > >
> > > Setting up sudo (1.8.21p2-3ubuntu1.3) ...
> > > chown: changing ownership of '/etc/sudoers': No data available
> > > dpkg: error processing package sudo (--configure):
> > >  installed sudo package post-installation script subprocess returned
> > > error exit status 1
> > >
> > > Rebooting the vm resulted in the same problem.  Booting into 5.8.18,
> > > apt upgrade succeeded.  Then I rebooted back into 5.9.
> > >
> > > >
> > > > >
> > > > > I suppose I should try 5.10 and see if this problem has already been
> > > > > fixed.
> > > > >
> > > >
> > > > Wouldn't hurt.
> > >
> > > Trying that shortly.  Also trying to figure out how to force the
> > > problem to happen...  I'll never get to the bottom of it at this rate.
> > > I was really hoping somebody on the list would recognize the
> > > problem...  :-/  Just my luck.
> >
> > The problem rings a bell, but I would expect it had something to
> > do with the change:
> > a888db310195 ovl: fix regression with re-formatted lower squashfs
> >
> > From v5.8.0 that was also applied to stable v5.4.y, so there is no
> > match to your report.
> >
> > 'No data available' means ENODATA error from getxattr()
> > which is not expected to be returned from operations like chmod() and
> > link() as you reported that is why the message makes no sense.
> > I did not find any internal vfs_getxattr() call in overlayfs code where
> > ENODATA can be exposed to the caller.
> >
> > I did find that ENODATA could be exposed from lookup via a call to
> > ovl_verify_origin(), but that implies that the index feature is enabled
> > and is expected to print "overlayfs: failed to verify..." to kmsg.
> > We should probably replace the use visible lookup error with EIO,
> > but that in itself won't help users to understand the problem.
> >
> > Do you use an existing upper (ext4) dir with a lower squashfs image that
> > is not the original image used when first mounting overlay with that upper dir
> > AND enable the index=on feature?
>
> 99% sure the answer to that is No and No.  I've been reusing an existing
> EXT4 filesystem, but creating fresh new upper dirs prior to first mount
> once in a while when I create a new squashfs image for the lower layer.  I
> suppose it is possible that I goofed at some point and left cruft in
> upper...  but I doubt it.  And I haven't used index=on or any other special
> options, as far as I know.
>
> > I still don't see how that would be a regression of kernel v5.8 and certainly
> > not v5.9.
>
> Me either...  maybe it's a freak accident?  Otherwise undetected corruption
> of the upper EXT4 filesystem?  I guess that seems unlikely, because it all
> of a sudden started effecting multiple virtual machines and my host
> system...
>
> > Do you use any non default overlay config/mount options?
>
> Nope.
>
> >
> > Please share the output of '/proc/self/mountinfo' with mounted overlay
>
> 26 31 253:0 / /mnt/root-true rw,relatime shared:4 - ext4 /dev/root rw
> 27 31 253:1 / /mnt/sqsh_layerdev ro,relatime shared:2 - ext4
> /dev/sqsh_layerdev ro
> 28 31 7:0 / /mnt/sqsh_layer-aldarion-new-zstd ro,relatime shared:3 -
> squashfs /dev/sqsh_layer-aldarion-new-zstd ro
> 31 1 0:24 / / rw,relatime shared:1 - overlay rootfs
> rw,lowerdir=/sqsh_layer-aldarion-new-zstd,upperdir=/tmproot/upper/upper,workdir=/tmproot/upper/work
> 32 31 0:23 / /sys rw,nosuid,nodev,noexec,relatime shared:5 - sysfs sysfs rw
> 33 31 0:27 / /proc rw,nosuid,nodev,noexec,relatime shared:13 - proc proc rw
> 34 31 0:5 / /dev rw,nosuid shared:14 - devtmpfs devtmpfs
> rw,size=3879828k,nr_inodes=969957,mode=755
> 35 32 0:7 / /sys/kernel/security rw,nosuid,nodev,noexec,relatime
> shared:6 - securityfs securityfs rw
> 37 32 0:20 / /sys/fs/selinux rw,relatime shared:7 - selinuxfs selinuxfs rw
> 36 34 0:28 / /dev/shm rw,nosuid,nodev shared:15 - tmpfs tmpfs rw
> 38 34 0:29 / /dev/pts rw,nosuid,noexec,relatime shared:16 - devpts
> devpts rw,gid=5,mode=620,ptmxmode=000
> 39 31 0:30 / /run rw,nosuid,nodev shared:17 - tmpfs tmpfs rw,mode=755
> 40 39 0:31 / /run/lock rw,nosuid,nodev,noexec,relatime shared:18 -
> tmpfs tmpfs rw,size=5120k
> 41 32 0:32 / /sys/fs/cgroup ro,nosuid,nodev,noexec shared:8 - tmpfs
> tmpfs ro,mode=755
> 42 41 0:33 / /sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime
> shared:9 - cgroup2 cgroup rw,nsdelegate
> 43 41 0:34 / /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime
> shared:10 - cgroup cgroup rw,xattr,name=systemd
> 44 32 0:35 / /sys/fs/pstore rw,nosuid,nodev,noexec,relatime shared:11
> - pstore pstore rw
> 45 32 0:36 / /sys/firmware/efi/efivars rw,nosuid,nodev,noexec,relatime
> shared:12 - efivarfs efivarfs rw
> 46 41 0:37 / /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime
> shared:19 - cgroup cgroup rw,cpuset
> 47 41 0:38 / /sys/fs/cgroup/net_cls,net_prio
> rw,nosuid,nodev,noexec,relatime shared:20 - cgroup cgroup
> rw,net_cls,net_prio
> 48 41 0:39 / /sys/fs/cgroup/cpu,cpuacct
> rw,nosuid,nodev,noexec,relatime shared:21 - cgroup cgroup
> rw,cpu,cpuacct
> 49 41 0:40 / /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime
> shared:22 - cgroup cgroup rw,devices
> 50 33 0:41 / /proc/sys/fs/binfmt_misc rw,relatime shared:23 - autofs
> systemd-1 rw,fd=27,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=6074
> 51 34 0:19 / /dev/mqueue rw,relatime shared:24 - mqueue mqueue rw
> 52 32 0:6 / /sys/kernel/debug rw,relatime shared:25 - debugfs debugfs rw
> 53 34 0:42 / /dev/hugepages rw,relatime shared:26 - hugetlbfs
> hugetlbfs rw,pagesize=2M
> 54 39 0:43 / /run/rpc_pipefs rw,relatime shared:27 - rpc_pipefs sunrpc rw
> 86 32 0:21 / /sys/kernel/config rw,relatime shared:28 - configfs configfs rw
> 90 31 259:1 / /boot rw,relatime shared:29 - vfat /dev/nvme0n1p1
> rw,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,errors=remount-ro
> 92 31 253:2 / /scrap rw,noatime shared:30 - ext4 /dev/mapper/vg99-scrap rw
> 467 39 0:50 / /run/user/121 rw,nosuid,nodev,relatime shared:316 -
> tmpfs tmpfs rw,size=778124k,mode=700,uid=121,gid=125
> 644 39 0:52 / /run/user/1200 rw,nosuid,nodev,relatime shared:447 -
> tmpfs tmpfs rw,size=778124k,mode=700,uid=1200,gid=1200
> 660 644 0:53 / /run/user/1200/gvfs rw,nosuid,nodev,relatime shared:459
> - fuse.gvfsd-fuse gvfsd-fuse rw,user_id=1200,group_id=1200
> 676 32 0:54 / /sys/fs/fuse/connections rw,relatime shared:471 -
> fusectl fusectl rw
> 382 39 0:49 / /run/user/0 rw,nosuid,nodev,relatime shared:239 - tmpfs
> tmpfs rw,size=778124k,mode=700
>
> > and 'grep Y /sys/module/overlay/parameters/*'
>
> /sys/module/overlay/parameters/redirect_always_follow:Y
> /sys/module/overlay/parameters/xino_auto:Y
>
> >
> > Do you see any "overlayfs:" logs in kmsg?
>
> [    4.828299] overlayfs: "xino" feature enabled using 32 upper inode bits.
>
> >
> > If you do not need nfs export, you could try to create squashfs image with
> > -no-exports as a possible workaround.
>
> If the problem persists, I will try that.  I'm not exporting anything
> from the overlay.

Ok, I can reproduce the problem 100% of the time using the attached
squashfs image in 5.9 or 5.10.  In 5.8.18 and 5.4.83, everything works
just fine.

 mkdir -p t tt ttt
 mount borky2.sqsh t
 mount -t tmpfs tmp tt
 mkdir -p tt/upper/{upper,work}
 mount -t overlay -o \
    lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
[ 1685.825956] overlayfs: "xino" feature enabled using 2 upper inode bits.

 echo hello there > ttt/FOO
zsh: no data available: ttt/FOO

 echo hello there > ttt/BAR
for some reason, that file is editable

 touch ttt/*
touch: cannot touch 'ttt/BAZ': No data available
touch: cannot touch 'ttt/FOO': No data available
touch: cannot touch 'ttt/FOO-symlink': No data available

Things look completely broken now that I'm looking this closely at a
fresh overlay... I'm honestly surprised my system was usable at all.
I guess most of the files on my lower layer had already been
upgraded prior to me starting to use the 5.9 kernel.

I also tried creating a squashfs file w/ -no-exports...  exact same results.

In case it helps, here are the relevant kernel config items:

CONFIG_OVERLAY_FS=y
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
# CONFIG_OVERLAY_FS_INDEX is not set
CONFIG_OVERLAY_FS_XINO_AUTO=y
# CONFIG_OVERLAY_FS_METACOPY is not set

CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZ4=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_ZSTD=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3


-- 
Michael D Labriola
21 Rip Van Winkle Cir
Warwick, RI 02886
401-316-9844 (cell)

--00000000000032d0f205b69cda78
Content-Type: application/octet-stream; name="borky2.sqsh"
Content-Disposition: attachment; filename="borky2.sqsh"
Content-Transfer-Encoding: base64
Content-ID: <f_kis0nhps0>
X-Attachment-Id: f_kis0nhps0

aHNxcwUAAAD1f9pfAAACAAEAAAABABEAwAABAAQAAACTAAAAAAAAAEwBAAAAAAAARAEAAAAAAAD/
/////////2wAAAAAAAAAxgAAAAAAAAAWAQAAAAAAADYBAAAAAAAAQkFSCkJBWgpGT08KWAB42uNk
WMLIAAQn6m/FgxlQwMKACpiQ2P+BgAmq7yxQHxOaPhaweoj8EaA8M5I8B1SemeE/WP46UB7EZwSL
MTC4+fszMrwFSz0ESrEiWR8OxGxADADG6xYEPAB42mNhgABGKM0EhE6OQRAmN4ipm5FYlJKTmZdt
AVQEkY6KADOYGNz8/SsYmIGQC8TULa7MBSkEAGduDDcQgGAAAAAAAAAADAAAAQAAAAAEAQAAAAAA
ABYAeNpjYIAACygdAaUroPRkKA0AG4ABnB4BAAAAAAAABIAAAAAAPgEAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
--00000000000032d0f205b69cda78--
