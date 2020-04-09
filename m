Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D57C2BB86
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 11:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1429720B1F
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 11:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5x+dcwi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDILVS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 07:21:18 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34370 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgDILVS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 07:21:18 -0400
Received: by mail-io1-f65.google.com with SMTP id f3so3471916ioj.1
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Apr 2020 04:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2rhTU9sZJ4y+cAYnctjzp+lD5Cdih8TjDQcIKUJalgg=;
        b=N5x+dcwi2IIFFypDlS7CH48p6Get0AfSibTNLmthZmmfIAd4+I8AThEBRpdoY5K1JU
         gxQZwzW3ucRGzj25mgpiYiA2+rnQ5dTDZFzM2YmS+wrf3liw4zOD1W3mXza5PPHXZ/TV
         LO8XCj/MhzT//716j+XFSbMPRAEdFTNK+s5EqFfKACSelZnm9jnHDbqNtvWk9qWjZSH/
         d+M7ApHNzDQeZyNF+nf968HryIihfvQj4pZUuBUIsZx9gKhH2Dj9lczKO4VO+KLnlkR1
         6oUJpEv6rETi7HM61S/MrGkzXeal9kO+kIkCnGRBI3hJcE8Mf6op8P2v5mEApQZuAO5A
         S4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2rhTU9sZJ4y+cAYnctjzp+lD5Cdih8TjDQcIKUJalgg=;
        b=imT31vui635MttuJ4kfPFgg59wmYGnsZ40Zs/6nz4GO83YN/nuNNXItmCuYNG1s5l7
         ea0CLQ2gEBsQkBe9nCWXGzs6qNCBnNSt3JhVd/iOtus/e3cEHscthg9xsHWgblTH2c1M
         ztXlwpT/f8soiOOO+toRW4fRXzD9X7LNCSHMQH0pg+VwYSX8gK8IdaaRWQwBJq6Pa6j4
         40/bnihNk+rf06rBtQUJ4lprn7QhpVO41+sikFrOjhUJ+yxthEe+8m2QFB1ykI8dzEZe
         l1WR5JFRwr+wy1r0GnufTA7sFrv4Zz8VyKb5YRcwAKLqO3JcO5hl//d1T8hpeDdYe1If
         xKYA==
X-Gm-Message-State: AGi0PuY/pmYq9uITILck6MvB8AvO5TW03mw8EsQQMVStPRBfpWIKI30a
        QmFheyhV1awnYvRqR0G7DUC+b+3JFCIlICfgARmc7Ql9
X-Google-Smtp-Source: APiQypLx4+cA6UyG3ObCqglDAua0vvDAHk0NFye2QbqleweHcJcsYFPf6xjxspRTJO7x3m1LCHphQSFWSphEDSH7O3o=
X-Received: by 2002:a02:4b03:: with SMTP id q3mr2113914jaa.30.1586431277799;
 Thu, 09 Apr 2020 04:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200403064444.31062-1-cgxu519@mykernel.net> <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
 <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
 <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com>
 <17153f590e5.13f80af2342991.2831629093514707476@mykernel.net>
 <CAOQ4uxjhfOXaHMaXY+J67winJzFMDVfiHfF4m=yed7XNcPvFUw@mail.gmail.com>
 <171578e6477.12630feab161.147743050045149370@mykernel.net>
 <CAOQ4uxhU-KC2Yiewso_rDa3HhafzBaVWk9i8Sra4W0Y_EEiShA@mail.gmail.com> <1715deb04cf.11a7e625f2245.4913788754434070520@mykernel.net>
In-Reply-To: <1715deb04cf.11a7e625f2245.4913788754434070520@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 9 Apr 2020 14:21:06 +0300
Message-ID: <CAOQ4uxgQZf+RYsHAKY2=298nmRpBv5-YQDzuOqcXXOFumK058g@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

>  > > nfs_export and metacopy are incompatible.
>  > > I tested "workdir" branch(latest commit is commit c1fe7dcb3db8ed8e84986eec07e0b302ee3b83de)
>  > > in your git tree and found three more fails.
>  >
>  > I figured that might me it.
>  > Please share more configuration details of your setup.
>  > How is metacopy enabled on your system?
>
> In order to test nfs_export, I disabled metacopy and enabled nfs_export in kernel config.

Ah right. There is this logic in ovl_parse_opt() where an explicit
metacopy or redirect_dir mount options win a conflict against the kernel config
default, but there is no such logic fir metacopy and index, because it
was harder to implement.

For the purpose of these tests, they just need to explicitly disable
metacopy in mount options. I will send a fix.

>
>  > How are you running xfstests? Can you share the config file?
>
> in xfstests-dev directory, run ./check -overlay overlay/*

FYI, -g overlay/auto will skip the "known issues" (i.e. mmap test)
and -g overlay/quick will skip the long stress test (overlay/019)

I also recommend running https://github.com/amir73il/unionmount-testsuite
if you want better test coverage.

...
>  >
>  > >
>  > > ----------------------------------
>  > >
>  > > overlay/029 1s ... - output mismatch (see /home/cgxu/git/xfstests-dev/results//overlay/029.out.bad)
>  > >     --- tests/overlay/029.out   2019-11-07 09:05:18.876796433 +0800
>  > >     +++ /home/cgxu/git/xfstests-dev/results//overlay/029.out.bad        2020-04-08 09:55:07.462699895 +0800
>  > >     @@ -1,5 +1,9 @@
>  > >      QA output created by 029
>  > >      foo
>  > >     -bar
>  > >     -foo
>  > >     -bar
>  > >     +mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle.
>  >
>  > The reason for this error should be in dmesg.
>
> I checked test log/case and the logic in the source code,
> I think the test failed at ovl_get_indexdir() -> ovl_verify_origin() during mount and this behaviour is just by design.
> so we should skip this test case when nfs_export is enabled.
>

OK. I was able to reproduce, but no need to skip the test
it is easy to fix it. I will post a fix.

>
>  >
>  > >     +cat: /tmp/8751/mnt/bar: No such file or directory
>  > >     ...
>  > >     (Run 'diff -u /home/cgxu/git/xfstests-dev/tests/overlay/029.out /home/cgxu/git/xfstests-dev/results//overlay/029.out.bad'  to see the entire diff)
>  > >
>  > > overlay/070     [failed, exit status 1]- output mismatch (see /home/cgxu/git/xfstests-dev/results//overlay/070.out.bad)
>  > >     --- tests/overlay/070.out   2020-04-07 09:16:59.102568756 +0800
>  > >     +++ /home/cgxu/git/xfstests-dev/results//overlay/070.out.bad        2020-04-08 09:55:38.580311600 +0800
>  > >     @@ -1,2 +1,26 @@
>  > >      QA output created by 070
>  > >     -Silence is golden
>  > >     +umount: /mnt/scratch: target is busy.
>  >
>  > This failure has do to with somthing that happened before the test.
>  > Its trails should be in dmesg.
>  >
>  > >     +rm: cannot remove '/mnt/scratch/ovl-mnt': Device or resource busy
>  > >     +losetup: /mnt/scratch/ovl-lower/img: failed to set up loop device: No such file or directory
>  > >     +cp: target '/mnt/scratch/ovl-lower/lowertestdir/blkdev' is not a directory
>  > >     +cp: target '/mnt/scratch/ovl-upper/uppertestdir/blkdev' is not a directory
>  > >     ...
>  > >     (Run 'diff -u /home/cgxu/git/xfstests-dev/tests/overlay/070.out /home/cgxu/git/xfstests-dev/results//overlay/070.out.bad'  to see the entire diff)
>  > >
>  > > overlay/071     - output mismatch (see /home/cgxu/git/xfstests-dev/results//overlay/071.out.bad)
>  > >     --- tests/overlay/071.out   2020-04-07 09:16:59.102568756 +0800
>  > >     +++ /home/cgxu/git/xfstests-dev/results//overlay/071.out.bad        2020-04-08 09:55:39.899295141 +0800
>  > >     @@ -1,2 +1,6 @@
>  > >      QA output created by 071
>  > >     +_overlay_check_fs: overlayfs on /mnt/scratch/ovl-mnt,/ovl-upper.2,/ovl-work.2 is inconsistent
>  > >     +(see /home/cgxu/git/xfstests-dev/results//overlay/071.full for details)
>  > >     +_overlay_check_fs: overlayfs on /mnt/scratch/ovl-mnt,/ovl-upper.2,/ovl-work.2 is inconsistent
>  > >     +(see /home/cgxu/git/xfstests-dev/results//overlay/071.full for details)
>  > >      Silence is golden
>  > >
>  >
>  > What do the full log details say?
>  > again, its probably a result of some previous failure.
>
> It sill failed when I just ran one test case.
> I haven't got enough time to analyse test logic and full log, so I put all logs in attachment.
> Please let me know if other logs are needed.

Thanks for taking the time to report all those failures.
You must be one of few developers to actually use fsck.overlayfs...

You need this fix for fsck.overlayfs:
https://github.com/hisilicon/overlayfs-progs/pull/1

Sorry, I forgot I was carrying this patch on my setup.

Zhangyi,

Any chance of merging my fix?

Thanks,
Amir.
