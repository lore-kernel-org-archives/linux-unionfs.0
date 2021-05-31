Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A550EC47083
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 May 2021 17:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D5D61042
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 May 2021 17:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhEaRKi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 31 May 2021 13:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbhEaRJX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 May 2021 13:09:23 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A1EC00366E
        for <linux-unionfs@vger.kernel.org>; Mon, 31 May 2021 08:19:00 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id w28so6765864uae.4
        for <linux-unionfs@vger.kernel.org>; Mon, 31 May 2021 08:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fNltilBZCxZe9ndZGv3YEuGsfBN+sRawj2EzksEgeWg=;
        b=KtjapTzMxSmJ0WXwmWapiKFOcWTFlGwfhXEEp6OgWjsPmSxlrlB+37CiGQFvAtOuk7
         0G2/wUKmx8LvClvh7s3AjghvYB0G7Nz0P49Bk+2JAtiX68mF2sI7GvO3+/JN/wwSPOcg
         hUvopZUSZBgQwt2FE63QBp2EiYSCqzfvDrax4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fNltilBZCxZe9ndZGv3YEuGsfBN+sRawj2EzksEgeWg=;
        b=siQvTeUi6TNv86vLdLPJBjONTOdL8M1Z5jfvmdgKT7tlIxLs8tJj9Kfkp/V3z6W6XZ
         z7VxRqRX+F5br+aaaWYT1/7ZVBHt/uCok2ZsyQB/afu7skQOLCVirtKaRMgJ6UwhhSMF
         7Bd8svAYzT0UVVR9Q1llPbkuZ5/5aCfDyQZH0V4rmi3NXYCewf8NpBycT1MN3nqAvQRM
         Ozr0N6So8AqOY7naVOWGYVgP9TInSp+D7PbNUK/d6xpzJiVpcVoGSffWiL9BQP5+gsoi
         BYcK4iuds07Iv/LLBF/EXvGULCwI2ih9oXTkvCUhf/6TVAIXTm5YBezIHmm79AKdQKpl
         Xdaw==
X-Gm-Message-State: AOAM532CVXsdZMay39Wf0c0rEh7Ki8VioUsy5s2IKnuFBWj3yRvWq906
        dDUjfMJvOBlm+SFfrevjYMYkAXZkGiWicBMe/7ZpNw==
X-Google-Smtp-Source: ABdhPJwvrtkSbwkPFvA5i7e9osfmP6TxOlHnWxpQ+VqKpH3TnfW6CJQMRstNcRR3WyvrX274nBxxejvuFFqaH+rMBsg=
X-Received: by 2002:a1f:6dc6:: with SMTP id i189mr13672386vkc.19.1622474339475;
 Mon, 31 May 2021 08:18:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxguanxEis-82vLr7OKbxsLvk86M0Ehz2nN1dAq8brOxtw@mail.gmail.com>
 <CAJfpeguCwxXRM4XgQWHyPxUbbvUh-M6ei-tYa5Y0P56MJMW7OA@mail.gmail.com> <CAOQ4uxhsxmzWp+YMRBA3xFDzJ1ov--n=f+VAnBsJZ_4DyHoYXw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhsxmzWp+YMRBA3xFDzJ1ov--n=f+VAnBsJZ_4DyHoYXw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 31 May 2021 17:18:48 +0200
Message-ID: <CAJfpegsqqwMgtDKESNVXvtYU=fsu2pZ_nE8UdXQSLudKqK8Xmw@mail.gmail.com>
Subject: Re: fsnotify events for overlayfs real file
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 18 May 2021 at 19:56, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, May 18, 2021 at 5:43 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, 10 May 2021 at 18:32, Amir Goldstein <amir73il@gmail.com> wrote:

> > > My thinking was that we can change d_real() to provide the real path:
> > >
> > > static inline struct path d_real_path(struct path *path,
> > >                                     const struct inode *inode)
> > > {
> > >         struct realpath = {};
> > >         if (!unlikely(dentry->d_flags & DCACHE_OP_REAL))
> > >                return *path;
> > >         dentry->d_op->d_real(path->dentry, inode, &realpath);
> > >         return realpath;
> > > }

Real paths are internal, we can't pass them (as fd in permission
events) to userspace.

> > >
> > >
> > > Another option, instead of getting the realpath, just detect the
> > > mismatch of file_inode(file) != d_inode(path->dentry) in
> > > fanotify_file() and pass FSNOTIFY_EVENT_DENTRY data type
> > > with d_real() dentry to backend instead of FSNOTIFY_EVENT_PATH.
> > >
> > > For inotify it should be enough and for fanotify it is enough for
> > > FAN_REPORT_FID and legacy fanotify can report FAN_NOFD,
> > > so at least permission events listeners can identify the situation and
> > > be able to block access to unknown paths.

That sounds like a good short term solution.


>
> Is there a reason for the fake path besides the displayed path in
> /proc/self/maps?

I'm not aware of any.

>
> Does it make sense to keep one realfile with fake path for mmaped
> files along side a realfile with private/detached path used for all the
> other operations?

This should work, but it would add more open files, so needs some good
justifications.

> While at it, we can also cache both upper and lower realfiles in case
> file was copied up after open.

Right, although this doesn't seem to be an issue (it's a rare corner
case that is being cared for).

Thanks,
Miklos
