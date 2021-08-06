Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B165C4338F
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Aug 2021 08:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D44604DB
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Aug 2021 08:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244508AbhHFI2N (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 04:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbhHFI2I (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Aug 2021 04:28:08 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3FFC061372
        for <linux-unionfs@vger.kernel.org>; Fri,  6 Aug 2021 01:22:33 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id d20so2076656vso.8
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Aug 2021 01:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K/7VZdsD0kvuXLXJN0Hxz/V1UWqWN2j9QnpBmRsIinU=;
        b=j7PbhC3w+UIrt4Z4VMtrxMZLYbBm2D/n5snIzK50TkfmeP+1txpOo1oL1WKoe9lFpu
         Te4zFR/fANLwAx2rBj4K83LiuJkxppIfVTQfBj9gn2XkOXqEGrh8vkf5/YbhaznaTSa0
         7g6y/q9w/GG71WiXd4VLSc00irkaVaX1p/ukQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K/7VZdsD0kvuXLXJN0Hxz/V1UWqWN2j9QnpBmRsIinU=;
        b=pYH6PGez7YqjzV3ria2RibaFcWEBQSPV/FJvJyeV+ol/9KDMdvXt+TTXzw9Ufjf3L2
         0HSG2RRQe60dAanGJ3Um1G3FzXyhKwDb3uXjE9ReZJUBl0J9ZkEL5isZQ+rWtRXumCkO
         Ne7Hy5RFTn7Z51fqNHfIwo8a3YQmsz51+68XczIioqG2Dzbe5wmjG3Bc9ay//TnTvzi2
         xw5kMguW/xLl6sLFDj0Q6qTXj0K3xHj5CyC8Oj9WHdZgxTR+dcPRSfgVbW0lsJ+F3e/Y
         FnQqdo1dFrqLM3UyhS5bvOM0a7c9JiUvB1M5MPrGupyPjJioN38xV4moQkP+tsxKE4mw
         pEEg==
X-Gm-Message-State: AOAM530ttpPme7IC5X7maQVW1A7470Zhtzyycs6QZHKJH9GMLCPgCKdm
        aq0e7nFm1HPq0dHhQjeVKkfrTa5L/pI6Lhj9JY7DcA==
X-Google-Smtp-Source: ABdhPJwPAml5ZEmZwjKSwjiJlKadiTx+81kSdiJB8ki3ka/cQSkYdRdLaMQoklBOewL90Bvr1F26iiFyqVu68brWQL0=
X-Received: by 2002:a05:6102:34d9:: with SMTP id a25mr8076699vst.0.1628238152502;
 Fri, 06 Aug 2021 01:22:32 -0700 (PDT)
MIME-Version: 1.0
References: <737687ee-3449-aa3d-ee29-bd75ca0a18a9@canonical.com> <CAOQ4uxgbqyyhQ+78j0L+GxkEJ8rOW43X9ann_kMs1098WkNe8Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgbqyyhQ+78j0L+GxkEJ8rOW43X9ann_kMs1098WkNe8Q@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 6 Aug 2021 10:22:21 +0200
Message-ID: <CAJfpegs5gBiB1YoYoDS6VDwKYrFbXHX6f1fsHPmA_yjH0+kfpA@mail.gmail.com>
Subject: Re: ovl: uninitialized pointer read in ovl_lookup_real_one
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Colin Ian King <colin.king@canonical.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 24 Jul 2021 at 09:36, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Jul 24, 2021 at 1:26 AM Colin Ian King <colin.king@canonical.com> wrote:
> >
> > Hi,
> >
> > Static analysis with Coverity has detected an uninitialized pointer read
> > in function ovl_lookup_real_one in fs/overlayfs/export.c
> >
> > The issue was introduced with the following commit:
> >
> > commit 3985b70a3e3f58109dc6ae347eafe6e8610be41e
> > Author: Amir Goldstein <amir73il@gmail.com>
> > Date:   Thu Dec 28 18:36:16 2017 +0200
> >
> >     ovl: decode connected upper dir file handles
> >
> > The analysis is as follows:
> >
> > 365static struct dentry *ovl_lookup_real_one(struct dentry *connected,
> > 366                                          struct dentry *real,
> > 367                                          const struct ovl_layer *layer)
> > 368{
> > 369        struct inode *dir = d_inode(connected);
> > 370        struct dentry *this, *parent = NULL;
> >
> >    1. var_decl: Declaring variable name without initializer.
> >
> > 371        struct name_snapshot name;
> > 372        int err;
> > 373
> > 374        /*
> > 375         * Lookup child overlay dentry by real name. The dir mutex
> > protects us
> > 376         * from racing with overlay rename. If the overlay dentry
> > that is above
> > 377         * real has already been moved to a parent that is not under the
> > 378         * connected overlay dir, we return -ECHILD and restart the
> > lookup of
> > 379         * connected real path from the top.
> > 380         */
> > 381        inode_lock_nested(dir, I_MUTEX_PARENT);
> > 382        err = -ECHILD;
> > 383        parent = dget_parent(real);
> >
> >    2. Condition ovl_dentry_real_at(connected, layer->idx) != parent,
> > taking true branch.
> >
> > 384        if (ovl_dentry_real_at(connected, layer->idx) != parent)
> >
> >    3. Jumping to label fail.
> >
> > 385                goto fail;
> > 386
> > 387        /*
> > 388         * We also need to take a snapshot of real dentry name to
> > protect us
> > 389         * from racing with underlying layer rename. In this case, we
> > don't
> > 390         * care about returning ESTALE, only from dereferencing a
> > free name
> > 391         * pointer because we hold no lock on the real dentry.
> > 392         */
> > 393        take_dentry_name_snapshot(&name, real);
> > 394        this = lookup_one_len(name.name.name, connected, name.name.len);
> > 395        err = PTR_ERR(this);
> > 396        if (IS_ERR(this)) {
> > 397                goto fail;
> > 398        } else if (!this || !this->d_inode) {
> > 399                dput(this);
> > 400                err = -ENOENT;
> > 401                goto fail;
> > 402        } else if (ovl_dentry_real_at(this, layer->idx) != real) {
> > 403                dput(this);
> > 404                err = -ESTALE;
> > 405                goto fail;
> > 406        }
> > 407
> > 408out:
> >
> >    Uninitialized pointer read
> >    6. uninit_use_in_call: Using uninitialized value name.name.name when
> > calling release_dentry_name_snapshot.
> >
> > 409        release_dentry_name_snapshot(&name);
> > 410        dput(parent);
> > 411        inode_unlock(dir);
> > 412        return this;
> > 413
> > 414fail:
> >
> >    4. Condition ___ratelimit(&_rs, <anonymous>), taking false branch
> > .
> > 415        pr_warn_ratelimited("failed to lookup one by real (%pd2,
> > layer=%d, connected=%pd2, err=%i)\n",
> > 416                            real, layer->idx, connected, err);
> > 417        this = ERR_PTR(err);
> >
> >    5. Jumping to label out.
> >
> > 418        goto out;
> > 419}
> >
> > The error exit path on line 395 ends up with an uninitialized structure
> > name being passed to function release_dentry_name_snapshot() on line 409
> > and this accesses the pointer name.name.name, see /fs/dcache.c as follows:
> >
> > 303void release_dentry_name_snapshot(struct name_snapshot *name)
> > 304{
> >
> >    1. read_value: Reading value name->name.name.
> >    2. Condition !!(name->name.name != name->inline_name), taking true
> > branch.
> >
> > 305        if (unlikely(name->name.name != name->inline_name)) {
> > 306                struct external_name *p;
> >
> >    3. Condition 0 /* !!(!__builtin_types_compatible_p() &&
> > !__builtin_types_compatible_p()) */, taking false branch.
> >
> >
> > I suspect name should be initialized in line 371, e.g. name = { } and a
> > null name check should be performed on line 409 before calling
> > release_dentry_name_snapshot, but this seems a bit message as a fix.
> >
>
> Thanks for the report.
> A simpler fix is to move take_dentry_name_snapshot() to top of the
> function before goto fail.

Even simpler:  move the release_dentry_name_snapshot to just after lookup.

Commit 89741437981a ("ovl: fix uninitialized pointer read in
ovl_lookup_real_one()") pushed to #overlayfs-next.

Thanks,
Miklos
