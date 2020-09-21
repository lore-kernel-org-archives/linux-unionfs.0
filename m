Return-Path: <SRS0=ehig=C6=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4B1C43464
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Sep 2020 08:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92112076E
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Sep 2020 08:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QNGfLFn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgIUISF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgIUISF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Sep 2020 04:18:05 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B68C061755;
        Mon, 21 Sep 2020 01:18:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s88so12835584ilb.6;
        Mon, 21 Sep 2020 01:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=13RFQrLQn1X3n8vFx/1eC2ToC/lcvEsZYR2SMtGurTg=;
        b=QNGfLFn+qV6fUjQII3vL2USVzKJV03IGcVKCvWZa5gn6/02plNWhIpYb0D9EkpMs/t
         J+VY9JbjQKonHL4xzaUVPoFymuiH5v+KmbVD7Pu6Z5pK7S8LB6F7rDgJ+/kCt40+/OTt
         3Hnlk4YzM/KNWidTTNgp9j+ll0hbBuqe9jTl2Zks2laAR4HeRRZ4glzNam6oJf9aokp/
         aQmKtONyRxL0HHJ5f7dTDK9mGslouBohFYs1BDUSZkdznKpbLCcB384BOrQXI6X0dBMx
         ExP16KSDapfFdI1Ov28Z5REey4Mgsb+wKR+YScq6cs45GCqLnuzyVxIztwzQ9pkZjYod
         aiMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=13RFQrLQn1X3n8vFx/1eC2ToC/lcvEsZYR2SMtGurTg=;
        b=gOjkt8BkcWHAdfhBVmgXE5VAeOXE2tzouu3ikFYVhI5a0vL0tPRHRLksS4vuGIGUHm
         CWvqB4Vi9lWSIBmY3AL2p6yQi4BDWUwk6ET19V8Z1nDO9NZiVXORKRTfynXOvXSNgEq1
         I/302FVRnBEay5Lgs1+s4fhRDftR/62wrQzj2v/hYvgeoK58jCOke2/C44cPrQb3/hto
         ZEandaFNbK8Nv8TWhUcpm+oHGha0OoSxQo3t91Oin5nMbYcqQAGiNcC4UiGohPJTclAh
         6CufAhHdvGxxnO8f/dj4M+L0RVQ8ncpM3jIfBOfExnAVhzgZp3qOibUqHVJKPgJCWIOP
         imTA==
X-Gm-Message-State: AOAM530rypNaHsg4EmcdJc90d9xeUek7NVz2AuceAVMz9HJnagAqVakW
        spHfC2sIQLii+aMgaiG1o8SGc7ixddfim/1g6R7JC11dTfs=
X-Google-Smtp-Source: ABdhPJz3EI8Hdi/E2cCbEbD/Kg5YbNkx1oBrhPrl2oyiCzKPY4u/af8KYdN3usIBhU6FlBb182jlSlmqgH1LyDb4Kqg=
X-Received: by 2002:a92:d0c7:: with SMTP id y7mr3327262ila.250.1600676284682;
 Mon, 21 Sep 2020 01:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200921072127.373125-1-yangx.jy@cn.fujitsu.com>
In-Reply-To: <20200921072127.373125-1-yangx.jy@cn.fujitsu.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 21 Sep 2020 11:17:54 +0300
Message-ID: <CAOQ4uxitZDVjbvBnb95UHWD6CzaBeoJ8deqR6nbmgRRJ3P2=UA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Support FS_IOC_[SG]ETFLAGS and FS_IOC_FS[SG]ETXATTR
 ioctls on directories
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 21, 2020 at 10:41 AM Xiao Yang <yangx.jy@cn.fujitsu.com> wrote:
>
> Factor out ovl_ioctl() and ovl_compat_ioctl() and take use of them for
> directories.
>
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---

This change is buggy. I had already posted it and self NACKed myself [1].

You can find an hopefully non-buggy version of it on my ovl-shutdown [2] branch.

As long as you are changing ovl_ioctl(), please also take the second
commit on that
branch to replace the open coded capability check with the
vfs_ioc_setflags_prepare()
generic helper.

Thanks,
Amir.


[1] https://lore.kernel.org/linux-unionfs/CAOQ4uxhRgL2sMok7xsAZN6cZXSfoPxx=O8ADE=72+Ta3hGoLbw@mail.gmail.com/
[2] https://github.com/amir73il/linux/commits/ovl-shutdown
