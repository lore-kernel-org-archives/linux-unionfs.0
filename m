Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A78C433DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 08:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F16BD23159
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 08:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbhATIBf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 03:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbhATH7p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Jan 2021 02:59:45 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17040C061757
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jan 2021 23:59:05 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id p128so5451956vkf.12
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jan 2021 23:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=raG85U5m6BVpkFn9tnlYSwbmBuD+wqMz8bt05EHQnpE=;
        b=COBq+q3DyHX/wjdBbdPiY06GVMPcsbaUsOQZTyJ7qWCOT9Qwlsa14PlxON1EmmP3dn
         ZyLBJZlg9mscFGi0pxRYe1PkgnxzZ7cc4PGSDkCygYvQXkYEPB+iqlRQKVsFYRij4TSP
         0se7PqcCswNtOkSxGRxAGUJHRKavvDfakuICQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=raG85U5m6BVpkFn9tnlYSwbmBuD+wqMz8bt05EHQnpE=;
        b=FoQvDDb0kGc5lTDU6YB/XE6ChMlVj9XW78JBBrJfnGW4+M4etrSs/bjyftI9jVj4P+
         RThSYGJ9nIKWT504iZ4gPpbv7hpj6prGWAbTJ30YNau8FKIu/5RZlObh/Hffd81li93a
         4udItb8fqxLqqsPPjHqt4cjUY0Pn0PXwTs6/+taeODbzrUhiZM4GCge3lWHTi6WeRgEB
         BMQFGH9dAw/E269VDdZIfvKF+hE4/Ixw2jck/H6VwpNwa30C25kFZTbBEJm1D9ePbDXe
         XDokjepFERx9tCbmCEb8eKgLBEbGaG73/LveAHm7u90Si99JE3vxoG3LuLbZSLyZN4eX
         rYVg==
X-Gm-Message-State: AOAM530wiqktRsZEu+pM2zgU72JQ35RmL2nDkSUDsp2m4rgqoQamGZRl
        NlyI/KSfm0xc8H95l5XTxN6x7DSUn0tvUwGlT+kScA==
X-Google-Smtp-Source: ABdhPJxTrW09RNX/58RsaWlPlSBaSO57A7eNZ40/KxN4vYPs/WQG40kBkXd8dat0tMmqg4Q+Tp0YtsfcCmv0wTVCO0Q=
X-Received: by 2002:a1f:410c:: with SMTP id o12mr5782747vka.19.1611129544253;
 Tue, 19 Jan 2021 23:59:04 -0800 (PST)
MIME-Version: 1.0
References: <20210119162204.2081137-1-mszeredi@redhat.com> <20210119162204.2081137-3-mszeredi@redhat.com>
 <8735yw8k7a.fsf@x220.int.ebiederm.org>
In-Reply-To: <8735yw8k7a.fsf@x220.int.ebiederm.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 20 Jan 2021 08:58:53 +0100
Message-ID: <CAJfpegt=qKzyu76b_vNF5_Be2-1dovZ6t06=haVgtC8sq1qsbA@mail.gmail.com>
Subject: Re: [PATCH 2/2] security.capability: fix conversions on getxattr
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Serge E . Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jan 20, 2021 at 2:39 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Miklos Szeredi <mszeredi@redhat.com> writes:
>
> > If a capability is stored on disk in v2 format cap_inode_getsecurity() will
> > currently return in v2 format unconditionally.
> >
> > This is wrong: v2 cap should be equivalent to a v3 cap with zero rootid,
> > and so the same conversions performed on it.
> >
> > If the rootid cannot be mapped v3 is returned unconverted.  Fix this so
> > that both v2 and v3 return -EOVERFLOW if the rootid (or the owner of the fs
> > user namespace in case of v2) cannot be mapped in the current user
> > namespace.
>
> This looks like a good cleanup.
>
> I do wonder how well this works with stacking.  In particular
> ovl_xattr_set appears to call vfs_getxattr without overriding the creds.
> What the purpose of that is I haven't quite figured out.  It looks like
> it is just a probe to see if an xattr is present so maybe it is ok.

Yeah, it's checking in the removexattr case whether copy-up is needed
or not (i.e. if trying to remove a non-existent xattr, then no need to
copy up).

But for consistency it should also be wrapped in override creds.
Adding fix to this series.

I'll also audit for any remaining omissions.  One known and documented
case is vfs_ioctl(FS_IOC_{[SG]ETFLAGS,FS[SG]ETXATTR}), but that
shouldn't be affected by user namespaces.

Thanks,
Miklos
