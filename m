Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A434C433DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 07:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63FD2313A
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 07:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbhATHlD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 02:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729571AbhATHkb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Jan 2021 02:40:31 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348FCC0613D3
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jan 2021 23:39:51 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id l187so5445235vki.6
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jan 2021 23:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aUaAld+7PlVuBg6y2NQxllJPdU7rN5fhUZHbRArJm2Y=;
        b=ahvlTktyt5QECQ7ao3XTiHPAajLjWlC1X23RksKxj9quUyIyi6ILEaGj+Zez2VgIEk
         FxQFC+jSl1dmJmwQSp8sO/qEnB5YwxKwK5rAJQL7HsFgpP3rkvOEM6/pDSzuVwyo1f1y
         N27jXlR6oEBpfbksqHzmNNRDHk2ZprG03G5b0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aUaAld+7PlVuBg6y2NQxllJPdU7rN5fhUZHbRArJm2Y=;
        b=IFqBh4hvzmlJLAreoCY+bEshvIkFnRRg2jJZFkDcC+vkUJ3TtBz7t8bczYUR7V6808
         HUX4szBDsr0dOqOtxUjOGOQvfdOMusIpe++Kzm1VvyOGTpREMXU8oygVcMDEcKmNSgGp
         ZhjmXBbBNEj7im/kmj4ovFF9s7IhdA0QGjLvij+KltnSB1VvIJtsMcNYb0Tx1P9tO6QX
         /gagStgkdZdXjaMBA9xuXx6seHremGAxnQ6Qy/gRLtgIP8o7JbMu2orR+irBNmNx6yyd
         sKIJd9u/z8xkOkqRWfO7ndWA1ySvH8OaZjsZVjD9W3cHcv6DLc93dE1FUGlFSTFr4+x+
         KUtw==
X-Gm-Message-State: AOAM532M4SdmA7HT5oQ/gRwk8DqJu9xDxPSTE7zp95XV7Apy2qgK5Dsf
        o0K8B2TQ1Kq0b6Lg6COJns4zFhkCC0SzOPL6Ko/E0A==
X-Google-Smtp-Source: ABdhPJxShMDCebz+BhaZwQUtaF/FMwTNyrAirvhIZqreLahBtuMVI+fIoCzbuAkc9Jh3F6ZuZLnKT+5lMhMhECOWtS8=
X-Received: by 2002:a1f:410c:: with SMTP id o12mr5750549vka.19.1611128390259;
 Tue, 19 Jan 2021 23:39:50 -0800 (PST)
MIME-Version: 1.0
References: <20210119162204.2081137-1-mszeredi@redhat.com> <87y2go8wg9.fsf@x220.int.ebiederm.org>
In-Reply-To: <87y2go8wg9.fsf@x220.int.ebiederm.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 20 Jan 2021 08:39:39 +0100
Message-ID: <CAJfpegvY1ckAfR0c-RtzeBSaR8_dM2CV1MD_xJr=A6+MkSXi9A@mail.gmail.com>
Subject: Re: [PATCH 0/2] capability conversion fixes
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <code@tyhicks.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jan 19, 2021 at 10:15 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Miklos Szeredi <mszeredi@redhat.com> writes:
>
> > It turns out overlayfs is actually okay wrt. mutliple conversions, because
> > it uses the right context for lower operations.  I.e. before calling
> > vfs_{set,get}xattr() on underlying fs, it overrides creds with that of the
> > mounter, so the current user ns will now match that of
> > overlay_sb->s_user_ns, meaning that the caps will be converted to just the
> > right format for the next layer
> >
> > OTOH ecryptfs, which is the only other one affected by commit 7c03e2cda4a5
> > ("vfs: move cap_convert_nscap() call into vfs_setxattr()") needs to be
> > fixed up, since it doesn't do the cap override thing that overlayfs does.
> >
> > I don't have an ecryptfs setup, so untested, but it's a fairly trivial
> > change.
> >
> > My other observation was that cap_inode_getsecurity() messes up conversion
> > of caps in more than one case.  This is independent of the overlayfs user
> > ns enablement but affects it as well.
> >
> > Maybe we can revisit the infrastructure improvements we discussed, but I
> > think these fixes are more appropriate for the current cycle.
>
> I mostly agree.  Fixing the bugs in a back-portable way is important.
>
> However we need to sort out the infrastructure, and implementation.
>
> As far as I can tell it is only the fact that overlayfs does not support
> the new mount api aka fs_context that allows this fix to work and be
> correct.
>
> I believe the new mount api would allow specifying a different userns
> thatn curent_user_ns for the overlay filesystem and that would break
> this.

This is a valid concern.   I'll add a WARN_ON() to make sure that
whenever this changes it doesn't go unnoticed.

Fixing it would also be easy:  just update creds->user_ns field to
that of sb->s_user_ns in ovl_fill_super().   For now I'll go with the
WARNING though, since this cannot be tested.

Thanks,
Miklos
