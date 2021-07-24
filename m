Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B383AC4338F
	for <linux-unionfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87BF660720
	for <linux-unionfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhGXGzr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhGXGzr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 24 Jul 2021 02:55:47 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9483AC061575;
        Sat, 24 Jul 2021 00:36:18 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id j21so5248786ioo.6;
        Sat, 24 Jul 2021 00:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hxof7NWhRTN6RxBAzvdBd/VZVFmS77YjkfQAkOZin+c=;
        b=ErhKil24dTxaHLxEYUyIdguwf7HqrEFZ8NdTUrz15hWbzV5epVuZEqebuaR7GhOLfk
         fA/7s02k1d9O8GByKIteqPuyV4vTr8Kqn0mHRslWgQgDRip45cK2nsEHDuRbXJrtK1TZ
         Zrm1P9D13IvyTvOPFIqiWSJGwLLpenSocsyxo+cezJUB69EXTCmgHzZWygEbi1GLgZYS
         bdedMt73BaDGFSVp5Y+bUko/UE+jv08VvYOZMqduVgoR/Ko2dIH7M9OSdOyLco1bpDTq
         IvLVYk1G4KhlURnjk4lFbSmdck6aBsABrKpR/48PfojlGIT749nZAUk3SkbNJvGsPKEk
         mrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hxof7NWhRTN6RxBAzvdBd/VZVFmS77YjkfQAkOZin+c=;
        b=ApGLCxEutV6BQgiq2y8u1RksE3PCioD/2b5iVqZ8FkZKhNaz56Ggngu1ytBLlYMvD0
         g+hKa/QdyyPeub7AsnX8Dvrk9DunmsY9+PwMN/1jNVrPOsU25aHsP9rILyTh/4Dvyl9j
         xCW/A6xWN9zZJpfQAjjDZIMDgA7dVy+4Cytsu13kbjnuRXi9zf53nqHF8wlr5RpEWrta
         xPkkjoNLC8Rj3aC+pQpgg3y9Qxy+HJTicQumxsZWP2T4Vb5tGw27IVRaSTQQfZAsbKRP
         DjENFU4ghQ61f6Q4hkNIoykk/a77Ku7XBJIi9+zR0mj/iF+R5MZ+DXqXdXYYUlb1U6B/
         m7iw==
X-Gm-Message-State: AOAM533kcKI1fsYeCkEguwWcYpC/QWsI/ckyqDefMdSJUbt46hTIOCf8
        Vk6pqUiPzx0Sn5dJKS+Aby1Lgl20yqF4BjVStI8=
X-Google-Smtp-Source: ABdhPJyapu/TNWx3CU+Ka6ZA4pTPfIkL60nya/pR6MA9SkE1j1f+iQx/mOoplEXB9BvAHiOHWNjcVXT/UlxHsTtKljY=
X-Received: by 2002:a05:6602:3304:: with SMTP id b4mr6800288ioz.186.1627112177921;
 Sat, 24 Jul 2021 00:36:17 -0700 (PDT)
MIME-Version: 1.0
References: <737687ee-3449-aa3d-ee29-bd75ca0a18a9@canonical.com>
In-Reply-To: <737687ee-3449-aa3d-ee29-bd75ca0a18a9@canonical.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 24 Jul 2021 10:36:05 +0300
Message-ID: <CAOQ4uxgbqyyhQ+78j0L+GxkEJ8rOW43X9ann_kMs1098WkNe8Q@mail.gmail.com>
Subject: Re: ovl: uninitialized pointer read in ovl_lookup_real_one
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jul 24, 2021 at 1:26 AM Colin Ian King <colin.king@canonical.com> wrote:
>
> Hi,
>
> Static analysis with Coverity has detected an uninitialized pointer read
> in function ovl_lookup_real_one in fs/overlayfs/export.c
>
> The issue was introduced with the following commit:
>
> commit 3985b70a3e3f58109dc6ae347eafe6e8610be41e
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Thu Dec 28 18:36:16 2017 +0200
>
>     ovl: decode connected upper dir file handles
>
> The analysis is as follows:
>
> 365static struct dentry *ovl_lookup_real_one(struct dentry *connected,
> 366                                          struct dentry *real,
> 367                                          const struct ovl_layer *layer)
> 368{
> 369        struct inode *dir = d_inode(connected);
> 370        struct dentry *this, *parent = NULL;
>
>    1. var_decl: Declaring variable name without initializer.
>
> 371        struct name_snapshot name;
> 372        int err;
> 373
> 374        /*
> 375         * Lookup child overlay dentry by real name. The dir mutex
> protects us
> 376         * from racing with overlay rename. If the overlay dentry
> that is above
> 377         * real has already been moved to a parent that is not under the
> 378         * connected overlay dir, we return -ECHILD and restart the
> lookup of
> 379         * connected real path from the top.
> 380         */
> 381        inode_lock_nested(dir, I_MUTEX_PARENT);
> 382        err = -ECHILD;
> 383        parent = dget_parent(real);
>
>    2. Condition ovl_dentry_real_at(connected, layer->idx) != parent,
> taking true branch.
>
> 384        if (ovl_dentry_real_at(connected, layer->idx) != parent)
>
>    3. Jumping to label fail.
>
> 385                goto fail;
> 386
> 387        /*
> 388         * We also need to take a snapshot of real dentry name to
> protect us
> 389         * from racing with underlying layer rename. In this case, we
> don't
> 390         * care about returning ESTALE, only from dereferencing a
> free name
> 391         * pointer because we hold no lock on the real dentry.
> 392         */
> 393        take_dentry_name_snapshot(&name, real);
> 394        this = lookup_one_len(name.name.name, connected, name.name.len);
> 395        err = PTR_ERR(this);
> 396        if (IS_ERR(this)) {
> 397                goto fail;
> 398        } else if (!this || !this->d_inode) {
> 399                dput(this);
> 400                err = -ENOENT;
> 401                goto fail;
> 402        } else if (ovl_dentry_real_at(this, layer->idx) != real) {
> 403                dput(this);
> 404                err = -ESTALE;
> 405                goto fail;
> 406        }
> 407
> 408out:
>
>    Uninitialized pointer read
>    6. uninit_use_in_call: Using uninitialized value name.name.name when
> calling release_dentry_name_snapshot.
>
> 409        release_dentry_name_snapshot(&name);
> 410        dput(parent);
> 411        inode_unlock(dir);
> 412        return this;
> 413
> 414fail:
>
>    4. Condition ___ratelimit(&_rs, <anonymous>), taking false branch
> .
> 415        pr_warn_ratelimited("failed to lookup one by real (%pd2,
> layer=%d, connected=%pd2, err=%i)\n",
> 416                            real, layer->idx, connected, err);
> 417        this = ERR_PTR(err);
>
>    5. Jumping to label out.
>
> 418        goto out;
> 419}
>
> The error exit path on line 395 ends up with an uninitialized structure
> name being passed to function release_dentry_name_snapshot() on line 409
> and this accesses the pointer name.name.name, see /fs/dcache.c as follows:
>
> 303void release_dentry_name_snapshot(struct name_snapshot *name)
> 304{
>
>    1. read_value: Reading value name->name.name.
>    2. Condition !!(name->name.name != name->inline_name), taking true
> branch.
>
> 305        if (unlikely(name->name.name != name->inline_name)) {
> 306                struct external_name *p;
>
>    3. Condition 0 /* !!(!__builtin_types_compatible_p() &&
> !__builtin_types_compatible_p()) */, taking false branch.
>
>
> I suspect name should be initialized in line 371, e.g. name = { } and a
> null name check should be performed on line 409 before calling
> release_dentry_name_snapshot, but this seems a bit message as a fix.
>

Thanks for the report.
A simpler fix is to move take_dentry_name_snapshot() to top of the
function before goto fail.

Thanks,
Amir.

> Colin
