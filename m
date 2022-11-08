Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC66C433FE
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Nov 2022 19:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiKHTWx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKHTWx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Nov 2022 14:22:53 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ACF78335
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Nov 2022 11:22:51 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id h16so9618551vkn.4
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Nov 2022 11:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=og7duJB5F/J2i0t90NvJysRPfRYMeJ1eNqlrL84If0o=;
        b=C6DqFFaQVisff1AsMxrjMDmHVy0PQ2Qx0+sMYXvFlz0Wk/clR5TQJ+xE4Nu/fXRLxa
         sASlEWgO/kFrrqFCdEKD5Q0XNl/I+BoRuJ1pqBmhlAdO57vSkI3Ma/hKpMHwozpTxM3Q
         Ensf+geHUfXlpRPw79xcg9xTp2PPbizkbf8ZEOUHTXTp//IuXlbsLSUCWwlkeKcaLaof
         bV+JM98lv/FZwdJvjVl0oXZYxHD6WMGU/ZwewG2f0aQaAJIr1Z9btzsPqWsWXA1ouC1c
         ihnIXqBrueTGKi6PJP0AkOSsygWgxXXLL0DdPDXhdBuNGq/YzG6puAhSrKimq3hYCnFK
         DDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=og7duJB5F/J2i0t90NvJysRPfRYMeJ1eNqlrL84If0o=;
        b=HumzC0j4sXIfLwXXWz8rrhre5ehQkNWnu5opDzuKQrYdOIUPjgPf+VS4OW4WW1mhGa
         Kvrdic6AAu9LeJu0IPfnuHzqcx09Sk1qDyJiNPwmvUPUKny6lRStx0OOpIQXMkRk5uJw
         LFt91ACDAc/DmekkF2nCKJc521uGkpgkYhCt45LOmdymhnkgaQ5Kr6Z3JB6j2QKvYAxL
         vEmJeMrzD3wmMBAeR7FMXfuPf2Ew2paTVWHo7Guoxc+QEVV4ILGuF7s7GIVZcxiijz0q
         YXahhR0XVtKeP8580f9yNOfQGN+TguBg1LaPwglZvSoXe2TydhwpMg3IwD6J9cd0AEg1
         kzVw==
X-Gm-Message-State: ACrzQf0tHfABxujJZ4thtQvy3b0tqmImZEliWEMbBh/S0pWYi5X3Tbj4
        I7Op3yzjkXzhNuVf7dFpjXKXygFTlgGKTLrA209x8WpagVo=
X-Google-Smtp-Source: AMsMyM5wipJO4MkMQd1PQNCL+aBs1N5mY1JjFj6V5P8QUuSRAzhYNOe3fyqO5w59ky0N8n+5X4zDFJTIA9FK78J5WIM=
X-Received: by 2002:a1f:a004:0:b0:398:3e25:d2a7 with SMTP id
 j4-20020a1fa004000000b003983e25d2a7mr30430960vke.36.1667935370506; Tue, 08
 Nov 2022 11:22:50 -0800 (PST)
MIME-Version: 1.0
References: <20221107042932.GB1843153@ubuntu> <CAOQ4uxipsS3Xf00fvY4fEBgJX8MZK2VW8sHANLA6h8qoEeAiCA@mail.gmail.com>
 <20221107070621.GA1860348@ubuntu> <CAOQ4uxg6ZsWKqgRBTxfXkfYP0xpf7CvpYsc7aj_1SgvDGYLjJA@mail.gmail.com>
 <20221108081408.GA16209@ubuntu> <CAOQ4uxi2aGUOCrPb55Q9LGVbqz4M9ZKOhNLnm8kKnsDQgdxYHQ@mail.gmail.com>
 <20221108123734.GA19150@ubuntu>
In-Reply-To: <20221108123734.GA19150@ubuntu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 8 Nov 2022 21:22:38 +0200
Message-ID: <CAOQ4uxhGCwXuaOVi3RLT5iPi+xB=TZG76k4Jx34TTd6OUvJrQg@mail.gmail.com>
Subject: Re: Re: Question about ESTALE error whene deleting upper directory file.
To:     "YoungJun.Park" <her0gyugyu@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 8, 2022 at 2:37 PM YoungJun.Park <her0gyugyu@gmail.com> wrote:
>
> On Tue, Nov 08, 2022 at 11:22:14AM +0200, Amir Goldstein wrote:
> > On Tue, Nov 8, 2022, 10:14 AM YoungJun.Park <her0gyugyu@gmail.com> wrote:
> >
> > > On Mon, Nov 07, 2022 at 10:49:57AM +0200, Amir Goldstein wrote:
> > > > On Mon, Nov 7, 2022 at 9:06 AM YoungJun.Park <her0gyugyu@gmail.com>
> > > wrote:
> > > > >
> > > > > On Mon, Nov 07, 2022 at 08:40:02AM +0200, Amir Goldstein wrote:
> > > > > > On Mon, Nov 7, 2022 at 6:38 AM YoungJun.Park <her0gyugyu@gmail.com>
> > > wrote:
> > > > > > >
> > > > > > > Here is my curious scenario.
> > > > > > >
> > > > > > > 1. create a file on overlayfs.
> > > > > > > 2. delete a file on upper directory.
> > > > > > > 3. can see file contents using read sys call. (may file operations
> > > all success)
> > > > > > > 4. cannot remove, rename. it return -ESTALE error (may inode
> > > operations fail)
> > > > > > >
> > > > > > > I understand this scenario onto the code level.
> > > > > > > But I don't understand this situation itself.
> > > > > > >
> > > > > > > I found a overlay kernel docs and it comments
> > > > > > > Changes to underlying filesystems section
> > > > > > >
> > > > > > > ...
> > > > > > > Changes to the underlying filesystems while part of a mounted
> > > overlay filesystem are not allowed.
> > > > > > > If the underlying filesystem is changed, the behavior of the
> > > overlay is undefined,
> > > > > > > though it will not result in a crash or deadlock.
> > > > > > > ....
> > > > > > >
> > > > > > > So here is my question (may it is suggestion)
> > > > > > >
> > > > > > > 1. underlying file system change is not allowed, then how about
> > > implementing shadow upper directory from user?
> > > > > > > 2. if read, write system call is allowed, how about changing
> > > remove, rename(and more I does not percept) operation success?
> > > > > > >
> > > > > >
> > > > > > What is your use case?
> > > > > > Why do you think this is worth spending time on?
> > > > > > If anything, we could implement revalidate to return ESTALE also
> > > from open
> > > > > > in such a case.
> > > > > > But again, why do you think that would matter?
> > > > > >
> > > > > > Thanks,
> > > > > > Amir.
> > > > >
> > > > > Thank you for replying.
> > > > > I develop antivirus scanner.
> > > > > When developing, I am confronted the situaion below.
> > > > >
> > > > > 1. make a docker container using overlayfs
> > > > > 2. our antivirus scanner detect on upperdir and remove it.
> > > > > 3. When I check container, the file contents can be read, buf file
> > > cannot be removed.(-ESTALE error)
> > > > >
> > > > > And as I think, the reason is upperdir is touchable. So it is better
> > > to hide upperdir.
> > > > > If it is hard to implement(or maybe there is a other reson that I don'
> > > know)
> > > > > it is better to make the situation is clear
> > > > > (file operation error, inode operations error or file operation
> > > success , inode operation success)
> > > > >
> > > >
> > > > Error on read is not an option because reading from an open and deleted
> > > > file is perfectly valid even without overlayfs.
> > > >
> > > > ESTALE error on open is doable and makes sense and I believe it may
> > > > be sufficient for your use case.
> > > >
> > > > I have an old branch that implements that behavior:
> > > > https://github.com/amir73il/linux/commits/ovl-revalidate
> > > >
> > > > You can try it out and see if that works for you.
> > > > If it does, I can post the patches.
> > > >
> > > > Note that the use case that you described does not need the last patch,
> > > > but if the anti-virus would have moved a lower file to quarantine
> > > > instead of deleting it, the last patch would also be useful for you.
> > > >
> > > > Thanks,
> > > > Amir.
> > >
> > > After applying the branch, I tested the scenario.
> > > But it does not work. file open is success on overlayfs filesystem.
> > >
> > > In my scnario, the dentry is not negative and just unhashed on upper.
> > >
> >
> > Yeh my bad.
> > I also noticed that after I sent you the link.
> > I think my patch also has a memleak somewhere I seen kmemleak reports
> > during testing.
> >
> > If we check dentry is unhashed we properly block open on my scenario.
> > > I write the patch and tested it working.
> > > (Maybe I does not catch your point, if you give a guide then I follow it)
> > >
> >
> > Please place the unhashed check inside ovl_revalidate_real() same as my
> > checks for negative upper and renamed lower dentry.
> >
> > The dentry should only be considered stale if the real dentry is unhashed
> > but ovl entry is hashed.
> >
> > The state of both ovl dentry and real dentry unhashed is possible and valid
> > I think, but it should not interfere with your use case where ovl dentry is
> > hashed and real upper is unhashed.
> >
> > I may be missing something so better if Miklos also takes a look at the
> > patch.
> >
> > Thanks,
> > Amir.
> >
> >
> > > Signed-off-by: YoungJun.park <her0gyugyu@gmail.com>
> > > ---
> > >  fs/overlayfs/file.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > > index 6512d147c223..629dbcc49070 100644
> > > --- a/fs/overlayfs/file.c
> > > +++ b/fs/overlayfs/file.c
> > > @@ -157,6 +157,10 @@ static int ovl_open(struct inode *inode, struct file
> > > *file)
> > >     file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
> > >
> > >     ovl_path_realdata(dentry, &realpath);
> > > +
> > > +    if (d_unhashed(realpath.dentry))
> > > +        return -ESTALE;
> > > +
> > >     realfile = ovl_open_realfile(file, &realpath);
> > >     if (IS_ERR(realfile))
> > >         return PTR_ERR(realfile);
> > > --
> > > 2.25.1
> > >
> > > And I have one more question.
> > > Why upper dir must be visible..?
> > > The reson I think making upper dir unvisible is like the below.
> > > 1. If making a upperdir is unvisible, then these kind of problem disappear.
> > > 2. upperdir visibility makes a passage to convey container's file to
> > > hostland.
> > > (in view of container using overlayfs)
> > > making unvisible remove this kind of problem.
> > > 3. Changing upper dir scenario makes undefined behavior. So, if removing
> > > the interface
> > > user can access, then we can make the undefined scenario itself.
> > >
> > > Thanks Amir.
> > > Best regards
> > >
>
> Thank you for kind guidance Amir.
> Before I will do next step, I want to recheck your point Amir :)
>
> 1.
> > Please place the unhashed check inside ovl_revalidate_real() same as my
> > checks for negative upper and renamed lower dentry.
>
> You mean I modify your commit? It is from your branch then
> How I fix it...? (Am I misunderstood somthing?)
> here is pseudo patch.

My branch is just a POC.
If you test it and say that it is useful for you I can post it
and add your use case as the motivation.

>
> invalidate dentry if dentry is unhashed
>
> Signed-off-by: YoungJun.park <her0gyugyu@gmail.com>
> ---
>  fs/overlayfs/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 6a4f2b87f1a3..411d3ed8aec1 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -129,8 +129,8 @@ static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak,
>  {
>     int ret = 1;
>
> -   /* Invalidate dentry if real was deleted/renamed since we found it */
> -   if (ovl_dentry_is_dead(d) || (hash && hash != d->d_name.hash_len)) {
> +   /* Invalidate dentry if real was deleted/renamed/unhashed since we found it */
> +   if (ovl_dentry_is_dead(d) || (hash && hash != d->d_name.hash_len) || d_unhashed(d)) {
>         ret = 0;
>     } else if (weak) {
>         if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE)
> --
> 2.25.1
>

That won't be enough and is also not accurate.
I pushed another patch to branch ovl-revalidate and also
tested that your use case works as expected when
deleting either upper or lower non-dir files.

The patch adds this functionality unconditionally for non-dir,
but it may be required to use some mount option to enable it.
It is up to Miklos to decide.

> 2.
>
> > The dentry should only be considered stale if the real dentry is unhashed
> > but ovl entry is hashed.
> >
> > The state of both ovl dentry and real dentry unhashed is possible and valid
> > I think, but it should not interfere with your use case where ovl dentry is
> > hashed and real upper is unhashed.
> >
> > I may be missing something so better if Miklos also takes a look at the
> > patch.
> >
>
> You mean, if I modify the code you said, then the patch I sent works properly? (file open fail)
> If you mean it, then I post my patch :)
>

Please test the patch that I pushed to branch ovl-revalidate.

> And the last question, I really curious "hide upperdir from user" idea. If it is meaningful
> I want to try to implement it, If it isn't then could you explain why this idea is not meaningful..?
>

It is not meaningful, it is not relevant.
There is no way to hide a directory.
You can bind mount an empty dir over it in one mount namespace
but in other mount namespaces or other bind mounts that dir will be visible.

Thanks,
Amir.
