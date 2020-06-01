Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4164C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A536520678
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:15:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqtXxqyj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgFAPP4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgFAPPz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 11:15:55 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA09C05BD43
        for <linux-unionfs@vger.kernel.org>; Mon,  1 Jun 2020 08:15:55 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d7so7295710ioq.5
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Jun 2020 08:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I3U+BfhKdtaUCuLe3g3F9fOrX094hfFR4NHDJEbPe7w=;
        b=HqtXxqyjiIaddM90nU7lsuUvbXI36Xzozdz2xIJXWOeQxHtv4/60INsEw7HlPYp50h
         zuSzZt0pXt5THM+XaIyniEUtTOakXTH/mDdGAx0JiSlJ+lMmGIDSYmq+OkzVYtQbsuye
         FOY1pcfWkHACanZ6+2QSHWWnMNFkODRKxPV8UJ39AWLG9aVh16PMwsWcjENXTzKWqbpO
         h6/aPO4KAej24iVjW3t801yAMSNRDj523ag3PAAAupoH60Cr/pM7W5M83l3zt/LbNJJQ
         3aLd4A1gbNuJuv1NHAuyzLHJcaNK3IsbvCwO/p0USgR3BmWRc4NoiB0JrMNz3GqZ58R0
         ITiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I3U+BfhKdtaUCuLe3g3F9fOrX094hfFR4NHDJEbPe7w=;
        b=HohAOCx7UuhDrbTX4pMwxntHGIyvsaxL3ohRmuJHf4Cf4KBB+IHAxEBeP2dMw3+uEp
         FkzPj21eEsqmocfSGSAXnNOOmiiA1/DTvpTu26BoJqKug3aoyyJrzSWuwpqVOllIdfYx
         9F/20irfFYJzs+xNIjDqkAtoAfSZBNWuClRfOs/XEDGUNIj1/I8pz5NCVi0K7s7r8QBg
         bca5oqJe0FARWoUbT/EJ04bn+NjSCV+g3MwKIdbWcf6a/kMm3NifYc8k8gRugGTahgjZ
         EeB0Swi7D4+hMj2LH/C1widVSx4JxMDBSXG0lqBQvRr6wInlHWko3mJvl6aqSIKHs73Z
         6FcQ==
X-Gm-Message-State: AOAM533TJa5qRmeFUrr9p8YtAvXj4Ug7tJhD1t9UXqFjywSIHTF+eMgk
        0xAw0uRGAGQaZzL5Bp5uqfU+ThbwBfsnvcIw/WE=
X-Google-Smtp-Source: ABdhPJybT5hTIZRqf/Y09V4pdN039AZeyThyz1xPMiV+wSCB2MkFG4eMB+/GT9c/qd63OnQnUjM2b/w0b6oQlReL2IY=
X-Received: by 2002:a05:6638:d96:: with SMTP id l22mr14020901jaj.120.1591024555114;
 Mon, 01 Jun 2020 08:15:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200529212952.214175-1-vgoyal@redhat.com> <20200529212952.214175-2-vgoyal@redhat.com>
 <CAOQ4uxj=MoKfo32tz8zmxf13gheDt+y1DZ3-oznY9YX=DhWiFg@mail.gmail.com> <20200601140446.GA3219@redhat.com>
In-Reply-To: <20200601140446.GA3219@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 1 Jun 2020 18:15:44 +0300
Message-ID: <CAOQ4uxj-r5kpOTRx9BV+hcS7sk0TGnWR0vGzSpEENLn_ZHeXWg@mail.gmail.com>
Subject: Re: [PATCH 1/3] overlayfs: Simplify setting of origin for index lookup
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 1, 2020 at 5:04 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sat, May 30, 2020 at 01:37:37PM +0300, Amir Goldstein wrote:
> > On Sat, May 30, 2020 at 12:30 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > overlayfs can keep index of copied up files and directories and it
> > > seems to serve two primary puroposes. For regular files, it avoids
> > > breaking lower hardlinks over copy up. For directories it seems to
> > > be used for various error checks.
> > >
> > > During ovl_lookup(), we lookup for index using lower dentry in many
> > > a cases. That lower dentry is called "origin" and following is a summary
> > > of current logic.
> > >
> > > If there is no upperdentry, always lookup for index using lower dentry.
> > > For regular files it helps avoiding breaking hard links over copyup
> > > and for directories it seems to be just error checks.
> > >
> > > If there is an upperdentry, then there are 3 possible cases.
> > >
> > > - For directories, lower dentry is found using two ways. One is regular
> > >   path based lookup in lower layers and second is using ORIGIN xattr
> > >   on upper dentry. First verify that path based lookup lower dentry
> > >   matches the one pointed by upper ORIGIN xattr. If yes, use this
> > >   verified origin for index lookup.
> > >
> > > - For regular files (non-metacopy), there is no path based lookup in
> > >   lower layers as lookup stops once we find upper dentry. So there
> > >   is no origin verification. If there is ORIGIN xattr present on upper,
> > >   use that to lookup index otherwise don't.
> > >
> > > - For regular metacopy files, again lower dentry is found using
> > >   path based lookup as well as ORIGIN xattr on upper. Path based lookup
> > >   is continued in this case to find lower data dentry for metacopy
> > >   upper. So like directories we only use verified origin. If ORIGIN
> > >   xattr is not present (Either because lower did not support file
> > >   handles or because this is hardlink copied up with index=off), then
> > >   don't use path lookup based lower dentry as origin. This is same
> > >   as regular non-metacopy file case.
> > >
> >
> > Very good summary.
> > You may add:
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >
> > But see one improvement below.
> > Also, please make sure to run unionmount setups:
> >
> > ./run --ov=10 --verify
> > ./run --ov=10 --meta --verify
> >
> > --verify will enable index and check st_dev;st_ino are not broken
> > on copy up. --ov=10 will cause lower hardlink copy up, because
> > after hardlink is creates by some test, upper is rotated to mid layer
> > and next modifying operation will trigger the hardlink copy up.
>
> Hi Amir,
>
> I ran above configurations and it passes with the patches.
>
> Thanks for these suggestions. I used to run only "./run --ov" so far.
> It will be nice to have some documentation about --meta, --verify in README.
>

Yeh, I never get to it.
But now I finally posted xfstest integration, so we can just add more
xfstests to run metacopy configurations on a full test cycle.

> >
> > > Suggested-by: Amir Goldstein <amir73il@gmail.com>
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  fs/overlayfs/namei.c | 29 +++++++++++++++++------------
> > >  1 file changed, 17 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > > index 0db23baf98e7..5d80d8cc0063 100644
> > > --- a/fs/overlayfs/namei.c
> > > +++ b/fs/overlayfs/namei.c
> > > @@ -1005,25 +1005,30 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> > >                 }
> > >                 stack = origin_path;
> > >                 ctr = 1;
> > > +               origin = origin_path->dentry;
> > >                 origin_path = NULL;
> > >         }
> > >
> > [...]
> > > -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> > > +       if (!origin && ctr && !upperdentry)
> > >                 origin = stack[0].dentry;
> > >
> >
> > No need to understand the long story to verify this change is correct.
> > This is true simply because the conditions to set stack = origin_path are:
> >
> >        if (!metacopy && !d.is_dir && upperdentry && !ctr && origin_path)
> >
> > And after getting there and setting ctr = 1, the complex conditions to
> > setting origin are met for certain:
> >
> >         if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> >
> > Therefore, it is logically equivalent (and makes much more sense)
> > to assign origin near stack = origin_path.
> >
> > Further, thanks to Vivek's explanation, it is now clear to me that after
> > setting origin above, all that is left to do here is:
> >
> >          /* Always lookup index of non-upper */
> >         if (!upperdentry)
> >                 origin = stack[0].dentry;
>
> This looks better. What about the case of non existing dentry with ctr=0.
> In that case we will set origin to NULL. It still works but it probably
> will be nice if we do.

Forgot about that.

>
>         /* Always lookup index of non-upper */
>         if (!upperdentry && ctr)
>                  origin = stack[0].dentry;
>
> Just making it explicit that we try to use lower as origin only if
> some lower dentry was found.
>

Looks good.
Sustaining my RVB

Thanks,
Amir.
