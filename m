Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AECBC433B4
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 May 2021 14:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A1626135C
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 May 2021 14:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhEROoi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 May 2021 10:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbhEROoi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 May 2021 10:44:38 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05320C061756
        for <linux-unionfs@vger.kernel.org>; Tue, 18 May 2021 07:43:19 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id p17so1761547uaw.4
        for <linux-unionfs@vger.kernel.org>; Tue, 18 May 2021 07:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/NJS4BT8nKKIEzjadjztzmkHWrSH/ly6k2XtFbYYqtY=;
        b=ot0shic8SKoxbOBysgZfoTlIK7zf5cofWrytZCBs8KNPRXouMieUDdph30n4Mk66Yr
         f2ihwTpLMMxBk59OgnhUpTXXgiv4R0FdVX7mYDQMvDvxdOjpKiWVY1hxzkNuVoO46RcY
         7n86YLuOac4Gsp+FnEMpy/QslUc0goo7UpJns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/NJS4BT8nKKIEzjadjztzmkHWrSH/ly6k2XtFbYYqtY=;
        b=sckezwnGA88wjppBtOlcH6zEauacVYnr626SmriLJd8PJliDgNKbxgkrs8K+3nDVIH
         M38mIlfO+rwuVr2hJHcjBpVAk6IAIKeA2xISQPNRrUPfdP61OY5niKxkIt0dmJ2JphwR
         9n2uos2cLShkzaBqf3/6ADjw4K4uybgqLJjJyyRvP36Z+EV5y6rA1dtkQdSFnebJKTeo
         ZntGqNn6bUHKXxIil+VqrRYlqquJ4rm2S4mye5cUiGnTCfnYHyBMD+o1zER6ndJ3ZqZn
         YFVCFO4gHPp3qPuiBQ+i4mm73hKTw0Kexbl7EL/ylr3cdGeNIBYG1VIzGERkNtqhhYeu
         F9TA==
X-Gm-Message-State: AOAM5310k6zfOQF3x13q/zCnqwW1ZIuZNSme4VlrR0OJYYolOAgra56c
        /JnfT8yJq5qW0tfV6Bx9UAZDJwXhsYOSxeFkgcMKOw==
X-Google-Smtp-Source: ABdhPJxRpelP85C/V/PHHmqJWlYMcnftRkoxLwLCTQlms4Th/kPTXFGsttYFYFHW+einymu6Ua5sDiR4a+Wy7b1YGbQ=
X-Received: by 2002:ab0:2690:: with SMTP id t16mr6751886uao.9.1621348998165;
 Tue, 18 May 2021 07:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxguanxEis-82vLr7OKbxsLvk86M0Ehz2nN1dAq8brOxtw@mail.gmail.com>
In-Reply-To: <CAOQ4uxguanxEis-82vLr7OKbxsLvk86M0Ehz2nN1dAq8brOxtw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 18 May 2021 16:43:06 +0200
Message-ID: <CAJfpeguCwxXRM4XgQWHyPxUbbvUh-M6ei-tYa5Y0P56MJMW7OA@mail.gmail.com>
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

On Mon, 10 May 2021 at 18:32, Amir Goldstein <amir73il@gmail.com> wrote:
>

> > I see, right. I agree that is unfortunate especially for stuff like audit
> > or fanotify permission events so we should fix that.
> >
>
> Miklos,
>
> Do you recall what is the reason for using FMODE_NONOTIFY
> for realfile?

Commit d989903058a8 ("ovl: do not generate duplicate fsnotify events
for "fake" path").

> I can see that events won't be generated anyway for watchers of
> underlying file, because fsnotify_file() looks at the "fake" path
> (i.e. the overlay file path).
>
> I recently looked at a similar issue w.r.t file_remove_privs() when
> I was looking at passing mnt context to notify_change() [1].
>
> My thinking was that we can change d_real() to provide the real path:
>
> static inline struct path d_real_path(struct path *path,
>                                     const struct inode *inode)
> {
>         struct realpath = {};
>         if (!unlikely(dentry->d_flags & DCACHE_OP_REAL))
>                return *path;
>         dentry->d_op->d_real(path->dentry, inode, &realpath);
>         return realpath;
> }
>
> static inline struct dentry *d_real(struct dentry *dentry,
>                                     const struct inode *inode)
> {
>         struct realpath = {};
>         if (!unlikely(dentry->d_flags & DCACHE_OP_REAL))
>                return dentry;
>         dentry->d_op->d_real(path->dentry, inode, &realpath);
>         return realpath.dentry;
> }
>
>
> Another option, instead of getting the realpath, just detect the
> mismatch of file_inode(file) != d_inode(path->dentry) in
> fanotify_file() and pass FSNOTIFY_EVENT_DENTRY data type
> with d_real() dentry to backend instead of FSNOTIFY_EVENT_PATH.
>
> For inotify it should be enough and for fanotify it is enough for
> FAN_REPORT_FID and legacy fanotify can report FAN_NOFD,
> so at least permission events listeners can identify the situation and
> be able to block access to unknown paths.
>
> Am I overcomplicating this?
>
> Any magic solution that I am missing?

Agree, dentry events should still happen.

Path events: what happens if you bind mount, then detach (lazy
umount)?   Isn't that exactly the same as what overlayfs does on the
underlying mounts?

Thanks,
Miklos
