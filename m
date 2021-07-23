Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5C6C432BE
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Jul 2021 22:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36ABA60F23
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Jul 2021 22:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhGWVqH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 23 Jul 2021 17:46:07 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:41282
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231742AbhGWVqH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Jul 2021 17:46:07 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id E1BE33F322;
        Fri, 23 Jul 2021 22:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627079199;
        bh=E7967veUNT4BFpbHxKgzpjAHpzsSarN5QX8vpu3CUMg=;
        h=From:Subject:To:Cc:Message-ID:Date:MIME-Version:Content-Type;
        b=CkU/e9L9gGdwGx5fP6u5NENBcR6QFti4ZVGSr+vGEcfglJIaSGUFwSARLnDe6OpsK
         VK0GTI3k79ItiMpTnAOPAAMfeWCtDxm9M+4TuWob4y2r4KJ54RWaenLL5rstxnMb4q
         KybjyH824Cewj0OTYdC31siDBOTZAPQYY6iwUyG+760sMUCQmIhBRdCRPFiJDJQ9JG
         QEfLdZxsg7Wel27NN2H0UjJA+W8yh6dy/Nc1iB0pvQ3QCzHaGEWp8+B/Xy74AQ8+Be
         lpRa6FKGC59XgDfJf5BJjB3ZO4h7n/C/nmPLyzyXMfxIzW+XLzcGugp1Lmxd5id2f/
         Xp2Ln59629H8A==
From:   Colin Ian King <colin.king@canonical.com>
Subject: ovl: uninitialized pointer read in ovl_lookup_real_one
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <737687ee-3449-aa3d-ee29-bd75ca0a18a9@canonical.com>
Date:   Fri, 23 Jul 2021 23:26:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,

Static analysis with Coverity has detected an uninitialized pointer read
in function ovl_lookup_real_one in fs/overlayfs/export.c

The issue was introduced with the following commit:

commit 3985b70a3e3f58109dc6ae347eafe6e8610be41e
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Thu Dec 28 18:36:16 2017 +0200

    ovl: decode connected upper dir file handles

The analysis is as follows:

365static struct dentry *ovl_lookup_real_one(struct dentry *connected,
366                                          struct dentry *real,
367                                          const struct ovl_layer *layer)
368{
369        struct inode *dir = d_inode(connected);
370        struct dentry *this, *parent = NULL;

   1. var_decl: Declaring variable name without initializer.

371        struct name_snapshot name;
372        int err;
373
374        /*
375         * Lookup child overlay dentry by real name. The dir mutex
protects us
376         * from racing with overlay rename. If the overlay dentry
that is above
377         * real has already been moved to a parent that is not under the
378         * connected overlay dir, we return -ECHILD and restart the
lookup of
379         * connected real path from the top.
380         */
381        inode_lock_nested(dir, I_MUTEX_PARENT);
382        err = -ECHILD;
383        parent = dget_parent(real);

   2. Condition ovl_dentry_real_at(connected, layer->idx) != parent,
taking true branch.

384        if (ovl_dentry_real_at(connected, layer->idx) != parent)

   3. Jumping to label fail.

385                goto fail;
386
387        /*
388         * We also need to take a snapshot of real dentry name to
protect us
389         * from racing with underlying layer rename. In this case, we
don't
390         * care about returning ESTALE, only from dereferencing a
free name
391         * pointer because we hold no lock on the real dentry.
392         */
393        take_dentry_name_snapshot(&name, real);
394        this = lookup_one_len(name.name.name, connected, name.name.len);
395        err = PTR_ERR(this);
396        if (IS_ERR(this)) {
397                goto fail;
398        } else if (!this || !this->d_inode) {
399                dput(this);
400                err = -ENOENT;
401                goto fail;
402        } else if (ovl_dentry_real_at(this, layer->idx) != real) {
403                dput(this);
404                err = -ESTALE;
405                goto fail;
406        }
407
408out:

   Uninitialized pointer read
   6. uninit_use_in_call: Using uninitialized value name.name.name when
calling release_dentry_name_snapshot.

409        release_dentry_name_snapshot(&name);
410        dput(parent);
411        inode_unlock(dir);
412        return this;
413
414fail:

   4. Condition ___ratelimit(&_rs, <anonymous>), taking false branch
.
415        pr_warn_ratelimited("failed to lookup one by real (%pd2,
layer=%d, connected=%pd2, err=%i)\n",
416                            real, layer->idx, connected, err);
417        this = ERR_PTR(err);

   5. Jumping to label out.

418        goto out;
419}

The error exit path on line 395 ends up with an uninitialized structure
name being passed to function release_dentry_name_snapshot() on line 409
and this accesses the pointer name.name.name, see /fs/dcache.c as follows:

303void release_dentry_name_snapshot(struct name_snapshot *name)
304{

   1. read_value: Reading value name->name.name.
   2. Condition !!(name->name.name != name->inline_name), taking true
branch.

305        if (unlikely(name->name.name != name->inline_name)) {
306                struct external_name *p;

   3. Condition 0 /* !!(!__builtin_types_compatible_p() &&
!__builtin_types_compatible_p()) */, taking false branch.


I suspect name should be initialized in line 371, e.g. name = { } and a
null name check should be performed on line 409 before calling
release_dentry_name_snapshot, but this seems a bit message as a fix.

Colin
