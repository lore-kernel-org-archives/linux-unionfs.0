Return-Path: <SRS0=sf8C=55=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB9FC2BA19
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Apr 2020 12:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250C5206DA
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Apr 2020 12:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="flsy3bWG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgDMMTo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 08:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729455AbgDMMTn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Apr 2020 08:19:43 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CFEC03BC87;
        Mon, 13 Apr 2020 05:14:30 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so9109015ioj.1;
        Mon, 13 Apr 2020 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pX60CIZDxTJDVxtmLuIDhxnCYtVvlBGG1nwF3uPB17c=;
        b=flsy3bWGzRZU6MzfPzBxzboSCDFWdZzz7s9N6LL1RFoporjfmV0Vf0H27fRKAhpSo1
         UlK0KMkD/oq8v2KA0pK2kTBDhlJqVCnQPVsKe36mvAeemEEZo2dMnugq3WW7wMoviM+B
         iv2E/OBJO6dLeT4cgtXeYtCoiAdS38GYMPUObJy/kmfbJG7Th3WLSRM6CmMJOcZ3Mqxj
         FA0fEDm2hSL1kYOrDI57okpoSsE2TjOC6LtVUHQKp0tHda8kv9bhbuaYeI0Kqshi6bnh
         Fc0G13+TutQzKwxKcNRwNnAa15bt4RuVZV3onnFdSDv3YKV4Dmw/ZP6A47rmnHAQIDzD
         7x2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pX60CIZDxTJDVxtmLuIDhxnCYtVvlBGG1nwF3uPB17c=;
        b=MEMktLtgX+o//n8i2w8Z7VURHAuu6ja0llJwzXm/LttVGdi/wTDinkeAR0TcrH4qk6
         IA/GWiDl7N2/wIrA4kCKiiPoUN2EXHAh8BrascD1lg3Zio/+r8eyvXJhpmW6gshedfx4
         c8mR2A0d8wF87WdeyY6qB8Fde6G1OhwCw85UaANKLbiv1sE0cL38SHl6I2YeOoLV1SoG
         GI9dF1wL2M1mqpsOarDYHTBUZfZEhPugYABI0iHZNO+h88rG1ITEM4a9nzir/RraJ4as
         LHv9FBjHSFNYP1MQkJD2Pb4i3ttszZnRhcEYGxSHmNcoUPWBXHh8mFk12j2bQ8TuhnJs
         3rlg==
X-Gm-Message-State: AGi0PuYj83gBYbfgbwXx/7kmaRkkT7oMuzSk+ZgyYX6JNBfLGr68XG25
        zJXNDCns1vgoRLkX27Ib4xl+Bbc3bo8LlFi3Ops=
X-Google-Smtp-Source: APiQypK8ejY4GNjcEZTFDQ9m9vbH3DKpjUqNwtMHYKQb3L3Eut8B0R5eVefQiOvQK6Pf3dMviUxYTpjTw2Hug14rJfk=
X-Received: by 2002:a02:4b03:: with SMTP id q3mr15321203jaa.30.1586780069759;
 Mon, 13 Apr 2020 05:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200410012059.27210-1-cgxu519@mykernel.net> <20200410012059.27210-2-cgxu519@mykernel.net>
 <CAOQ4uxghdvj9QVJ3DQ3g1p0hbvz5mfMoxgoEAKyQAf4v78p2YA@mail.gmail.com> <17173093df3.f6003c6d6224.1796766948671904062@mykernel.net>
In-Reply-To: <17173093df3.f6003c6d6224.1796766948671904062@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 13 Apr 2020 15:14:18 +0300
Message-ID: <CAOQ4uxhKU8bgBEXXKZ91dzM4JFFKaM+DzxJ=+D6o9FDeDy4syQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlay/072: test for sharing inode with whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

>  > > +
>  > > +# Case1:
>  > > +# Setting whiteout_link_max=0 will not share inode
>  > > +# with whiteout files, it means each whiteout file
>  > > +# will has it's own inode.
>  > > +
>  > > +file_count=10
>  > > +link_max=0
>  > > +link_count=1
>  >
>  > Would be nicer to put all the below in a run_test_case() function
>  > with above as arguments.
>  >
>
> Something like below?
> ---------
> # Arguments:
> # $1: Maximum link count
> # $2: Testing file number
> # $3: Expected link count
> run_test_case()
> {
>         _scratch_mkfs
>         _set_fs_module_param $param_name ${1}
>         make_lower_files ${2}
>         _scratch_mount
>         make_whiteout_files
>         check_whiteout_files ${2} ${3}
>         $UMOUNT_PROG $SCRATCH_MNT
> }
>
> link_max=1
> file_count=10
> link_count=1
> run_test_case $link_max $file_count $link_count
> ---------
>

Yes. That's better.

>  > > +_scratch_mkfs
>  > > +_set_fs_module_param $param_name $link_max
>  > > +make_lower_files
>  > > +_scratch_mount
>  > > +make_whiteout_files
>  > > +check_whiteout_files
>  > > +$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
>  >
>  > Better:
>  > $UMOUNT_PROG $SCRATCH_MNT
>  >
>  > Even better:
>  > _scratch_umount
>
> I haven't found the definition of _scratch_umount,
> have we implemented it?

typo. I meant _scratch_unmount

On top of $UMOUNT_PROG $SCRATCH_MNT
_scratch_unmount also unmount the base fs.

...

>  > First, that is  strange outcome of whiteout_link_max=2
>  > I would not expect it.
>  > Second, how can every whiteout be shared with tmpfile?
>  > There should be at most one tmpfile at all times, so the
>  > whiteouts that already reached whiteout_link_max should
>  > not be linked to any tmpfile.
>
> I think I misunderstood your comment in my kernel patch, so I changed
> the logic to keep all tmpfiles in workdir and cleanup them during next mount.
> I'll fix it in V3 kernel patch.
>

Ah, so its good you posted the test ;-)

>  >
>  > Please add to test_case() verification that work dir contains
>  > at most one tmpfile.
>  > But please make sure that the test is clever enough to check
>  > both work and index dirs for tmpfiles (names beginning with #).
>  >
>
> So should I check module params of index and nfs_export for checking
> tmpfile in index dir?
>

No need for that.

Verifying that both index and work dir contain no more than a single tmpfile
together is good enough and should be pretty simple too:

ls $workdir/work/#* $workdir/index/#*|wc -l

Thanks,
Amir.
