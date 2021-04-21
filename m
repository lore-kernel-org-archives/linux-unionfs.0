Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C42C433ED
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 11:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FC461424
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 11:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhDULPV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 07:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbhDULPU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 07:15:20 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD582C06174A
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Apr 2021 04:14:47 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id d25so14327834vsp.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Apr 2021 04:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IgSjMLFpAUDBSSrXqS4wTee8azrDjMc8jlpMtxPvMHQ=;
        b=H8ky9uWnXXFZ+Lf4+jUyBfcc2hOFgs8yUcd7Tu0rcLQO9pA78XWWKDvXiUnu7Ip3Mq
         1dOEEuODqWnG+oKDWxXOGnaGaLbP/Dp5ZTWuI06iuJ6fGYznOMwKAMpH48XSniD++rdj
         MB+/QTwv1bbn0OdpHcvbpevfKryeSHEF7D2Tw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IgSjMLFpAUDBSSrXqS4wTee8azrDjMc8jlpMtxPvMHQ=;
        b=DeGtJ+6p5gyj+pJCgDAxnXPGERQENgTAS5db+hTUBUQ7XFPyZX6PwacitZHoRAxWL9
         GCr+hH+hT7PfpM3Tc+uEPN2Ds2ywj/PGOqA4pgBkBbSEbQFRB8v8EhiQL+si42YnkHNe
         VJtsGtOzbNqbx3iBi9F1Z/6zNuJiEMsuU6z0fFfc7+QCSGAtSf9rfJOGRJMv0o/VK20p
         2yJnD8Knn6PI4WdUyjNOkM8tRur/Q67I2T83XmP6hyatqYF7hfjDL3ewqZRqu6/nofV9
         Aj5HWjW5nZvjMtN2Px3N0Y4L55OdZgkp3U/+27MOsxHOxQBRDMmzoFJcBs+M33/Q6toV
         mFOA==
X-Gm-Message-State: AOAM530XIpf4mRr8omtnL6YeBBO1lVmMAnOeVELN65IJJ35hHinTQMtl
        7FGXc6wFKxxXWLZxNAKEU4dfdfw/9OTg+dxaVUfR3A==
X-Google-Smtp-Source: ABdhPJyawrfoJKS5gKaAnoYe6WnwV05SWHt0JlO2nkqzSvvlrn4if1yh9Z/Dxsr5NL94YmeTvoAsKIN0BRVtIOdGzWI=
X-Received: by 2002:a67:b005:: with SMTP id z5mr24449261vse.47.1619003687017;
 Wed, 21 Apr 2021 04:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210420020738.201670-1-cgxu519@mykernel.net> <CAJfpegvfGAynZ1kz287eJHVRc6+81FzUwSq_V9E36qXCB7WtYQ@mail.gmail.com>
 <481e8c92-3084-f0bc-56ec-86099abfdc55@amd.com>
In-Reply-To: <481e8c92-3084-f0bc-56ec-86099abfdc55@amd.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 21 Apr 2021 13:14:36 +0200
Message-ID: <CAJfpegvMcitbZ=APBE7Eu4te1LR+thwH=iYrWMvqn80mFFvmLQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: restore vma->vm_file to old file
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 21, 2021 at 1:03 PM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> Am 21.04.21 um 11:47 schrieb Miklos Szeredi:
> > On Tue, Apr 20, 2021 at 4:08 AM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
> >> In the error case of ->mmap() we should also restore vma->vm_file
> >> to old file in order to keep correct file reference in error path.
> >>
> >> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> >> ---
> >>   fs/overlayfs/file.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> >> index 6e454a294046..046a7adb02c5 100644
> >> --- a/fs/overlayfs/file.c
> >> +++ b/fs/overlayfs/file.c
> >> @@ -439,6 +439,7 @@ static int ovl_mmap(struct file *file, struct vm_a=
rea_struct *vma)
> >>          if (ret) {
> >>                  /* Drop reference count from new vm_file value */
> >>                  fput(realfile);
> >> +               vma->vm_file =3D file;
> > That's interesting: commit 1527f926fd04 ("mm: mmap: fix fput in error
> > path v2") which went into 5.11-rc1 seems to have broke the refcounting
> > in overlayfs in the name of cleaning up a workaround.   Wondering if
> > there's any other damage done by this "fix"?
>
> Can you give wider context? In other words why did the patch broke the
> reference counting in overlayfs?

In the error case overlayfs would put the reference on realfile (which
is vma->vm_file at that point) and mmap_region() would put the
reference to the original file (which was vma->vm_file before being
overridden).

After your commit mmap_region() puts the ref on the override vm_file,
but not on the original file.

>
> > Changing refcounting rules in core kernel is no easy matter, a full
> > audit of ->mmap instances (>200) should have been done beforehand.
>
> Which is pretty much what was done, see the follow up commit:
>
> commit 295992fb815e791d14b18ef7cdbbaf1a76211a31 (able/vma_file)
> Author: Christian K=C3=B6nig <christian.koenig@amd.com>
> Date:   Mon Sep 14 15:09:33 2020 +0200
>
>      mm: introduce vma_set_file function v5
>
>      Add the new vma_set_file() function to allow changing
>      vma->vm_file with the necessary refcount dance.
>
> It just looks like I missed the case in overlayfs while doing this.

Yes.  And apparently a number of other cases where vm_file is assigned...

Thanks,
Miklos
