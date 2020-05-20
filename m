Return-Path: <SRS0=Uqc0=7C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745ECC433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 14:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 419B3207D4
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 14:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="nni5UtWO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgETOoh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 May 2020 10:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETOog (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 May 2020 10:44:36 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4B5C061A0E
        for <linux-unionfs@vger.kernel.org>; Wed, 20 May 2020 07:44:36 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b91so3327293edf.3
        for <linux-unionfs@vger.kernel.org>; Wed, 20 May 2020 07:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G2RbWvLiXe9sVyUL0b59h5rSzbGnT/pgUGP94RK88yA=;
        b=nni5UtWOmr+jt+WJbyZM1H3aZBaW4CTaE+gdf6LdDjhtJzEHlBXwee1W0ughn3MANB
         tTUQFhWY2zsuc5020igss1RIUKE3n3CR8LuAUHcw3hGF4yLAOKo88FyDU17vp2yg+jve
         ba87KRXmkLIHlYA2Mu14fNMuLCxOekfKyrnrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G2RbWvLiXe9sVyUL0b59h5rSzbGnT/pgUGP94RK88yA=;
        b=jEptGJQ9fx8Lv4I/bcWeOKcwFwsQOnzGup3VBUl2JiWYKWWxaSBJDyJj4CBzmKVZ82
         Gx47UNRWydSWMiJ2JycLjQaToWnp91zCG9MaNs4AY8gBo9DSJRJPS5QCWwKUaTtS2VIk
         CejLci/9J/i/AyQ7sFtRH6r5vg3Vv6FJEzGT9+l7gdF4RMR7ka2iJvyDUVnWBhc1du2Q
         u09hvklEz0Tc2DiWDUE2iLpZzbaKvN0Ld6pxqVBqhKtnAE7VYJw5vQE7R8SUBl6KwDc5
         a1fDNbbDHv67PHMp68saI75E/zgSvddH/+4a4gZKz876+EEzqxL0KrqmAXqR13i3Z25+
         jgjw==
X-Gm-Message-State: AOAM530QqffmuRhqILdc6wEZxldICUp346WyiFZL7McIUEVgpNHF1Y7B
        L2bMraetm2SP4rncMd9dU3CopHq5h0Jf5nqtOi0YZw==
X-Google-Smtp-Source: ABdhPJyYjPG+UkocITZMndR/unzcV0V0m5BBK2rTLSt7l1fu52Yea+WAOV32vFfbCVv28bMGvJdb1OqMfKk+CQ7N7/g=
X-Received: by 2002:a05:6402:3076:: with SMTP id bs22mr3828559edb.161.1589985875160;
 Wed, 20 May 2020 07:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200515072047.31454-1-cgxu519@mykernel.net> <e994d56ff1357013a85bde7be2e901476f743b83.camel@themaw.net>
 <CAOQ4uxjT8DouPmf1mk1x24X8FcN5peYAqwdr362P4gcW+x15dw@mail.gmail.com>
 <CAJfpegtpi1SVJRbQb8zM0t66WnrjKsPEGEN3qZKRzrZePP06dA@mail.gmail.com>
 <05e92557-055c-0dea-4fe4-0194606b6c77@mykernel.net> <CAJfpegtyZw=6zqWQWm-fN0KpGEp9stcfvnbA7eh6E-7XHxaG=Q@mail.gmail.com>
 <7fcb778f-ba80-8095-4d48-20682f5242a9@mykernel.net>
In-Reply-To: <7fcb778f-ba80-8095-4d48-20682f5242a9@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 20 May 2020 16:44:23 +0200
Message-ID: <CAJfpegu1XVB5ABGMzNpyomgWqu+gtd2RCoDpuqGcEYJ7tmWdew@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/9] Suppress negative dentry
To:     cgxu <cgxu519@mykernel.net>
Cc:     Amir Goldstein <amir73il@gmail.com>, Ian Kent <raven@themaw.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 19, 2020 at 11:24 AM cgxu <cgxu519@mykernel.net> wrote:
>
> On 5/19/20 4:21 PM, Miklos Szeredi wrote:
> > On Tue, May 19, 2020 at 7:02 AM cgxu <cgxu519@mykernel.net> wrote:
> >
> >> If we don't consider that only drop negative dentry of our lookup,
> >> it is possible to do like below, isn't it?
> > Yes, the code looks good, though I'd consider using d_lock on dentry
> > instead if i_lock on parent, something like this:
> >
> > if (d_is_negative(dentry) && dentry->d_lockref.count == 1) {
> >      spin_lock(&dentry->d_lock);
> >      /* Recheck condition under lock */
> >      if (d_is_negative(dentry) && dentry->d_lockref.count == 1)
> >          __d_drop(dentry)
> >      spin_unlock(&dentry->d_lock);
>
> And after this we will still treat 'dentry' as negative dentry and dput it
> regardless of the second check result of d_is_negative(dentry), right?

I'd restructure it in the same way as lookup_positive_unlocked()...

> > }
> >
> > But as Amir noted, we do need to take into account the case where
> > lower layers are shared by multiple overlays, in which case dropping
> > the negative dentries could result in a performance regression.
> > Have you looked at that case, and the effect of this patch on negative
> > dentry lookup performance?
>
> The container which is affected by this feature is just take advantage
> of previous another container but we could not guarantee that always
> happening. I think there no way for best of both worlds, consider that
> some malicious containers continuously make negative dentries by
> searching non-exist files, so that page cache of clean data, clean
> inodes/dentries will be freed by memory reclaim. All of those
> behaviors will impact the performance of other container instances.
>
> On the other hand, if this feature significantly affects particular
> container,
> doesn't that mean the container is noisy neighbor and should be restricted
> in some way?

Not necessarily.   Negative dentries can be useful and in case of
layers shared between two containers having negative dentries cached
in the lower layer can in theory positively affect performance.   I
don't have data to back this up, nor the opposite.  You should run
some numbers for container startup times with and without this patch.

Thanks,
Milklos
