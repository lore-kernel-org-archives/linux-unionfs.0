Return-Path: <SRS0=4+cZ=5Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB8FC2D0EA
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Apr 2020 05:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E011020692
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Apr 2020 05:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6oDCBFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgDHF1m (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 01:27:42 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:38166 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgDHF1m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Apr 2020 01:27:42 -0400
Received: by mail-il1-f196.google.com with SMTP id n13so5602652ilm.5
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Apr 2020 22:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GCVlkZ+tQSPs00TxmPHBEljWnWGt7/hRJ5SYhRuc61s=;
        b=O6oDCBFhu1oOa9gnQxJIFbNpmY+UxK3pE70cyHu4Xjr1bP8uVBT7B6v+NKTDAHerzB
         ZpAIkExmYNNBiubCeWOB4jpUAFr5ggHGMC7Kx76s9pfIA7Mn7q/oBrqXO8miedbxwbOF
         RIjYP+pjBQbGAbuKI76K/pEWO6y1cU/cKXKijmqYnsuPVDaxIE/Ulh1npnA1i0BJNeN9
         lQXn9WelQE+AWxXyNotyg/wEBZeJGqjROTFFvwGfnIBsCSCl6ITXkCYt4I9AjFBpM6F9
         H/0L5bmFA7CoKwBgJcJ6rffxG4NYmtlCuHr8hrCRUYob5D80mzlAzZbUijUNW4XnlVfN
         UkSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GCVlkZ+tQSPs00TxmPHBEljWnWGt7/hRJ5SYhRuc61s=;
        b=NU8b908lySFXAhJQJVWD+COGZLthQfrnXTg7ITuiz6iFOXgrslKbwF4YkyU+V3vKX2
         9pgGf8/rK14r3pXl06l8sAwnEYQFKcz2TLYhvVOnjvCc6E1PxLaa4XaGN9iA6JFm+16g
         ID7tXo4lS/1F7ps7mDq2p0P/JFU3XZxtRWsIGq8mGq7WCyf0EAHm7ps4vpozHT41gj0T
         h7zhQkfYtxWyPlvPo3ldpIOeCX5SJapcZAxmBrYfgyqGT1IiBFrjsudnV5nk0qZQHaC+
         iXJHnsNjzFx1iCErnIBe6g/VI6JmHmKok3ZoiqExhgk3J/uTMVpdhUmDXjIYB+hp02K5
         dLIQ==
X-Gm-Message-State: AGi0Pubg0lg9uh1XGU8MaGYCIgMOvkZl1RYwms/g4qWKslkEBSxNpnuA
        +slqcf9zdvVijZcugwWq5ZAngojaIrqVssaZUjw=
X-Google-Smtp-Source: APiQypJopD14F/s3PgEkLFLUOMr4cA6fylksV81Y5rdKHEigpSCnjJ9wLR3+itv/Wb5DxZZYpldUrXCSUeaJoflHjmc=
X-Received: by 2002:a05:6e02:5ae:: with SMTP id k14mr6301715ils.9.1586323660749;
 Tue, 07 Apr 2020 22:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200403064444.31062-1-cgxu519@mykernel.net> <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
 <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
 <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com>
 <17153f590e5.13f80af2342991.2831629093514707476@mykernel.net>
 <CAOQ4uxjhfOXaHMaXY+J67winJzFMDVfiHfF4m=yed7XNcPvFUw@mail.gmail.com> <171578e6477.12630feab161.147743050045149370@mykernel.net>
In-Reply-To: <171578e6477.12630feab161.147743050045149370@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Apr 2020 08:27:29 +0300
Message-ID: <CAOQ4uxhU-KC2Yiewso_rDa3HhafzBaVWk9i8Sra4W0Y_EEiShA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 8, 2020 at 5:11 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-08 01:12:59 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > >  > did nfs_export tests fail with my recent branch (c1fe7dcb3db8)?
>  > >  > because I had a bug that caused nfs_export tests to fail.
>  > >  >
>  > >  >
>  > >  > ...
>  > >  >
>  > >
>  > > Actually, it is "not run" not fail. I'm not very familiar how to run=
 with nfs_export,
>  > > is it needing some special options?
>  > >
>  > > test log below:
>  > >
>  > > overlay/068     [not run] overlay feature 'nfs_export' cannot be ena=
bled on /mnt/scratch
>  > > overlay/069     [not run] overlay feature 'nfs_export' cannot be ena=
bled on /mnt/scratch
>  > > overlay/070     [not run] overlay feature 'nfs_export' cannot be ena=
bled on /mnt/scratch
>  > > overlay/071     [not run] overlay feature 'nfs_export' cannot be ena=
bled on /mnt/scratch
>  > >
>  > > overlay/050 4s ... [not run] overlay feature 'nfs_export' cannot be =
enabled on /mnt/scratch
>  > > overlay/051 3s ... [not run] overlay feature 'nfs_export' cannot be =
enabled on /mnt/scratch
>  > > overlay/052 1s ... [not run] overlay feature 'nfs_export' cannot be =
enabled on /mnt/scratch
>  > > overlay/053 2s ... [not run] overlay feature 'nfs_export' cannot be =
enabled on /mnt/scratch
>  > > overlay/054 1s ... [not run] overlay feature 'nfs_export' cannot be =
enabled on /mnt/scratch
>  > > overlay/055 1s ... [not run] overlay feature 'nfs_export' cannot be =
enabled on /mnt/scratch
>  > >
>  > >
>  >
>  > It depends which filesystem you have as lower/upper or
>  > which mount options you used for the xfstests setup.
>  > dmesg should give you a clue for why nfs_export could not be
>  > enabled on overlayfs.
>  >
>
> nfs_export and metacopy are incompatible.
> I tested "workdir" branch(latest commit is commit c1fe7dcb3db8ed8e84986ee=
c07e0b302ee3b83de)
> in your git tree and found three more fails.

I figured that might me it.
Please share more configuration details of your setup.
How is metacopy enabled on your system?
How are you running xfstests? Can you share the config file?
Details of the underlying filesystems.

>
> ----------------------------------
>
> overlay/029 1s ... - output mismatch (see /home/cgxu/git/xfstests-dev/res=
ults//overlay/029.out.bad)
>     --- tests/overlay/029.out   2019-11-07 09:05:18.876796433 +0800
>     +++ /home/cgxu/git/xfstests-dev/results//overlay/029.out.bad        2=
020-04-08 09:55:07.462699895 +0800
>     @@ -1,5 +1,9 @@
>      QA output created by 029
>      foo
>     -bar
>     -foo
>     -bar
>     +mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle=
.

The reason for this error should be in dmesg.

>     +cat: /tmp/8751/mnt/bar: No such file or directory
>     ...
>     (Run 'diff -u /home/cgxu/git/xfstests-dev/tests/overlay/029.out /home=
/cgxu/git/xfstests-dev/results//overlay/029.out.bad'  to see the entire dif=
f)
>
> overlay/070     [failed, exit status 1]- output mismatch (see /home/cgxu/=
git/xfstests-dev/results//overlay/070.out.bad)
>     --- tests/overlay/070.out   2020-04-07 09:16:59.102568756 +0800
>     +++ /home/cgxu/git/xfstests-dev/results//overlay/070.out.bad        2=
020-04-08 09:55:38.580311600 +0800
>     @@ -1,2 +1,26 @@
>      QA output created by 070
>     -Silence is golden
>     +umount: /mnt/scratch: target is busy.

This failure has do to with somthing that happened before the test.
Its trails should be in dmesg.

>     +rm: cannot remove '/mnt/scratch/ovl-mnt': Device or resource busy
>     +losetup: /mnt/scratch/ovl-lower/img: failed to set up loop device: N=
o such file or directory
>     +cp: target '/mnt/scratch/ovl-lower/lowertestdir/blkdev' is not a dir=
ectory
>     +cp: target '/mnt/scratch/ovl-upper/uppertestdir/blkdev' is not a dir=
ectory
>     ...
>     (Run 'diff -u /home/cgxu/git/xfstests-dev/tests/overlay/070.out /home=
/cgxu/git/xfstests-dev/results//overlay/070.out.bad'  to see the entire dif=
f)
>
> overlay/071     - output mismatch (see /home/cgxu/git/xfstests-dev/result=
s//overlay/071.out.bad)
>     --- tests/overlay/071.out   2020-04-07 09:16:59.102568756 +0800
>     +++ /home/cgxu/git/xfstests-dev/results//overlay/071.out.bad        2=
020-04-08 09:55:39.899295141 +0800
>     @@ -1,2 +1,6 @@
>      QA output created by 071
>     +_overlay_check_fs: overlayfs on /mnt/scratch/ovl-mnt,/ovl-upper.2,/o=
vl-work.2 is inconsistent
>     +(see /home/cgxu/git/xfstests-dev/results//overlay/071.full for detai=
ls)
>     +_overlay_check_fs: overlayfs on /mnt/scratch/ovl-mnt,/ovl-upper.2,/o=
vl-work.2 is inconsistent
>     +(see /home/cgxu/git/xfstests-dev/results//overlay/071.full for detai=
ls)
>      Silence is golden
>

What do the full log details say?
again, its probably a result of some previous failure.

FWIW, I ran:
kvm-xfstests -c overlay/large -g overlay/quick -m metacopy=3Don

And there were no errors. The nfs_exports tests did [not run]

Thanks,
Amir.
