Return-Path: <SRS0=4+cZ=5Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2860C2D0EC
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Apr 2020 02:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5548B20748
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Apr 2020 02:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="KzjUI5yG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgDHCLt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 22:11:49 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25359 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbgDHCLs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Apr 2020 22:11:48 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586311884; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=IbQP2S2qQOBRG9tn9Zjg2Io56QZ0xXxAGPPe3eTFz+K5cYw+AzFq5RwCCQxc5nqxs5HRZYMk2Pdf4lP3VASv16qTpuVkXvMv6rYA/nU3TbnrcxS8fOaXYCdAVZGg6zgLR31UVD/oFwQ22ZVfRChck6W+Kjo3Js5jDL3/HtavXs8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586311884; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=J0k/FXUypYdXrsEQzC3e7mw1/KyKFSjXpZem1zIqOGA=; 
        b=AMNkodymnujGm0ZkvNxHLD1XVxJfZz0fLDFQLzc1Pe9+Bb9gyMpZt5a/n6J4vaf3uo1Ud0TESABfQRckLV6bn7fGLGOOX1iRX+yPDobN/MqVELdXK9Kr9tmAMeyz5/oacz5LYLKgvW3Lx5WRVsLHUJxjwT/MPzA5ouM0blgqtnE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586311884;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=J0k/FXUypYdXrsEQzC3e7mw1/KyKFSjXpZem1zIqOGA=;
        b=KzjUI5yGUuqFYP/FyNwKbumWJD32CYdVvEgX9g3dIw2TBv4N4XBOpiIFKs/JhJwo
        W+MG0oobfsNAKO/5LX+vNxlG7ujJTFmsTGPXKaYHA33xJ42ztI/dxZ45VIYW9MBpUaq
        ITHS7V+iiNIFBZyahR3z3DSrveaKodcBZqDUXIwQ=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586311881851134.71864885697494; Wed, 8 Apr 2020 10:11:21 +0800 (CST)
Date:   Wed, 08 Apr 2020 10:11:21 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Hou Tao" <houtao1@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <171578e6477.12630feab161.147743050045149370@mykernel.net>
In-Reply-To: <CAOQ4uxjhfOXaHMaXY+J67winJzFMDVfiHfF4m=yed7XNcPvFUw@mail.gmail.com>
References: <20200403064444.31062-1-cgxu519@mykernel.net> <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
 <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
 <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com> <17153f590e5.13f80af2342991.2831629093514707476@mykernel.net> <CAOQ4uxjhfOXaHMaXY+J67winJzFMDVfiHfF4m=yed7XNcPvFUw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-08 01:12:59 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > did nfs_export tests fail with my recent branch (c1fe7dcb3db8)?
 > >  > because I had a bug that caused nfs_export tests to fail.
 > >  >
 > >  >
 > >  > ...
 > >  >
 > >
 > > Actually, it is "not run" not fail. I'm not very familiar how to run w=
ith nfs_export,
 > > is it needing some special options?
 > >
 > > test log below:
 > >
 > > overlay/068     [not run] overlay feature 'nfs_export' cannot be enabl=
ed on /mnt/scratch
 > > overlay/069     [not run] overlay feature 'nfs_export' cannot be enabl=
ed on /mnt/scratch
 > > overlay/070     [not run] overlay feature 'nfs_export' cannot be enabl=
ed on /mnt/scratch
 > > overlay/071     [not run] overlay feature 'nfs_export' cannot be enabl=
ed on /mnt/scratch
 > >
 > > overlay/050 4s ... [not run] overlay feature 'nfs_export' cannot be en=
abled on /mnt/scratch
 > > overlay/051 3s ... [not run] overlay feature 'nfs_export' cannot be en=
abled on /mnt/scratch
 > > overlay/052 1s ... [not run] overlay feature 'nfs_export' cannot be en=
abled on /mnt/scratch
 > > overlay/053 2s ... [not run] overlay feature 'nfs_export' cannot be en=
abled on /mnt/scratch
 > > overlay/054 1s ... [not run] overlay feature 'nfs_export' cannot be en=
abled on /mnt/scratch
 > > overlay/055 1s ... [not run] overlay feature 'nfs_export' cannot be en=
abled on /mnt/scratch
 > >
 > >
 >=20
 > It depends which filesystem you have as lower/upper or
 > which mount options you used for the xfstests setup.
 > dmesg should give you a clue for why nfs_export could not be
 > enabled on overlayfs.
 >=20

nfs_export and metacopy are incompatible.=20
I tested "workdir" branch(latest commit is commit c1fe7dcb3db8ed8e84986eec0=
7e0b302ee3b83de)
in your git tree and found three more fails.

----------------------------------

overlay/029 1s ... - output mismatch (see /home/cgxu/git/xfstests-dev/resul=
ts//overlay/029.out.bad)
    --- tests/overlay/029.out   2019-11-07 09:05:18.876796433 +0800
    +++ /home/cgxu/git/xfstests-dev/results//overlay/029.out.bad        202=
0-04-08 09:55:07.462699895 +0800
    @@ -1,5 +1,9 @@
     QA output created by 029
     foo
    -bar
    -foo
    -bar
    +mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle.
    +cat: /tmp/8751/mnt/bar: No such file or directory
    ...
    (Run 'diff -u /home/cgxu/git/xfstests-dev/tests/overlay/029.out /home/c=
gxu/git/xfstests-dev/results//overlay/029.out.bad'  to see the entire diff)

overlay/070     [failed, exit status 1]- output mismatch (see /home/cgxu/gi=
t/xfstests-dev/results//overlay/070.out.bad)
    --- tests/overlay/070.out   2020-04-07 09:16:59.102568756 +0800
    +++ /home/cgxu/git/xfstests-dev/results//overlay/070.out.bad        202=
0-04-08 09:55:38.580311600 +0800
    @@ -1,2 +1,26 @@
     QA output created by 070
    -Silence is golden
    +umount: /mnt/scratch: target is busy.
    +rm: cannot remove '/mnt/scratch/ovl-mnt': Device or resource busy
    +losetup: /mnt/scratch/ovl-lower/img: failed to set up loop device: No =
such file or directory
    +cp: target '/mnt/scratch/ovl-lower/lowertestdir/blkdev' is not a direc=
tory
    +cp: target '/mnt/scratch/ovl-upper/uppertestdir/blkdev' is not a direc=
tory
    ...
    (Run 'diff -u /home/cgxu/git/xfstests-dev/tests/overlay/070.out /home/c=
gxu/git/xfstests-dev/results//overlay/070.out.bad'  to see the entire diff)

overlay/071     - output mismatch (see /home/cgxu/git/xfstests-dev/results/=
/overlay/071.out.bad)
    --- tests/overlay/071.out   2020-04-07 09:16:59.102568756 +0800
    +++ /home/cgxu/git/xfstests-dev/results//overlay/071.out.bad        202=
0-04-08 09:55:39.899295141 +0800
    @@ -1,2 +1,6 @@
     QA output created by 071
    +_overlay_check_fs: overlayfs on /mnt/scratch/ovl-mnt,/ovl-upper.2,/ovl=
-work.2 is inconsistent
    +(see /home/cgxu/git/xfstests-dev/results//overlay/071.full for details=
)
    +_overlay_check_fs: overlayfs on /mnt/scratch/ovl-mnt,/ovl-upper.2,/ovl=
-work.2 is inconsistent
    +(see /home/cgxu/git/xfstests-dev/results//overlay/071.full for details=
)
     Silence is golden


Thanks,
cgxu.




