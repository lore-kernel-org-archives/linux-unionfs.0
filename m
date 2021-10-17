Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2E8C433EF
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 Oct 2021 20:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928BD60F23
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 Oct 2021 20:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242670AbhJQU4D (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 17 Oct 2021 16:56:03 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:37966 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbhJQU4C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 Oct 2021 16:56:02 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Oct 2021 16:56:02 EDT
Received: from kevinolos.kevinlocke.name (2600-6c67-5000-3d1b-cb5b-5541-f265-256d.res6.spectrum.com [IPv6:2600:6c67:5000:3d1b:cb5b:5541:f265:256d])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id A4E5827604E5;
        Sun, 17 Oct 2021 20:46:04 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id B81A1130062F; Sun, 17 Oct 2021 14:46:02 -0600 (MDT)
Date:   Sun, 17 Oct 2021 14:46:02 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [Regression] ovl: rename(2) EINVAL if lower doesn't support fileattrs
Message-ID: <YWyLigrybF6yzf6Y@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>
References: <20210910001820.174272-1-sashal@kernel.org>
 <20210910001820.174272-40-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910001820.174272-40-sashal@kernel.org>
X-Mutt-References: <20210910001820.174272-40-sashal@kernel.org>
X-Mutt-Fcc: =SENT-fcc
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi all,

With 5.15-rc5 or torvalds master (d999ade1cc86), attempting to rename
a file fails with -EINVAL on an overlayfs mount with a lower
filesystem that returns -EINVAL for ioctl(FS_IOC_GETFLAGS).  For
example, with ntfs-3g:

    mkdir lower upper work overlay
    dd if=/dev/zero of=ntfs.raw bs=1M count=2
    mkntfs -F ntfs.raw
    mount ntfs.raw lower
    touch lower/file.txt
    mount -t overlay -o "lowerdir=$PWD/lower,upperdir=$PWD/upper,workdir=$PWD/work" - overlay
    mv overlay/file.txt overlay/file2.txt

mv fails and (misleadingly) prints

    mv: cannot move 'overlay/file.txt' to a subdirectory of itself, 'overlay/file2.txt'

which strace(1) reveals to be due to rename(2) returning -22
(-EINVAL).  A bit of digging revealed that -EINVAL is coming from
vfs_fileattr_get() with the following stack:

ovl_real_fileattr_get.cold+0x9/0x12 [overlay]
ovl_copy_up_inode+0x1b5/0x280 [overlay]
ovl_copy_up_one+0xaf1/0xee0 [overlay]
ovl_copy_up_flags+0xab/0xf0 [overlay]
ovl_rename+0x149/0x850 [overlay]
? privileged_wrt_inode_uidgid+0x47/0x60
? generic_permission+0x90/0x200
? ovl_permission+0x70/0x120 [overlay]
vfs_rename+0x619/0x9d0
do_renameat2+0x3c0/0x570
__x64_sys_renameat2+0x4b/0x60
do_syscall_64+0x3b/0xc0
entry_SYSCALL_64_after_hwframe+0x44/0xae

This issue does not occur on 5.14.  I've bisected the regression to
72db82115d2b.

Thanks,
Kevin
