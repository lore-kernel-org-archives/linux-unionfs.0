Return-Path: <SRS0=mld1=7M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B41C433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 11:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FAA120659
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 11:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aNWUs6bg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgE3Lf3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 30 May 2020 07:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgE3Lf1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 May 2020 07:35:27 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD3FC03E969
        for <linux-unionfs@vger.kernel.org>; Sat, 30 May 2020 04:35:27 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id o5so2099178iow.8
        for <linux-unionfs@vger.kernel.org>; Sat, 30 May 2020 04:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5BPboaioTp7RGgkYCm7ZramTNzvbuhT+mnc0HeGveLk=;
        b=aNWUs6bgU/KIseXdIS0Zu5M5JhX56cBnGK0y5Qt+It3qFFFLZQzYEs+tNDvrZTtxDo
         inBsAmUkS3gyKqeFnceUYjm1KMD19stJ1zcmS8t9JuAOTMX1CLFvOIJychLkcCnrXtCr
         9T37vLUbWgaDd3rOizp58qiT22B3AmZ5m0kdRNcFqXVTdwLIot4dfjrPdC64HuxLcMUu
         0OoRJ0R9PEA2tT71Hap5ZCBK0OkaYLl5AsHHEQ6jdnAMdHJw1JrBHAnlDTRZKDW/3fb6
         2rzBfGkE180CaSISwbITT3d3/yhL0gVl4O0QystZKoBuTr8TfUfz9nlSxhG1RUWE3oK5
         zWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5BPboaioTp7RGgkYCm7ZramTNzvbuhT+mnc0HeGveLk=;
        b=Q0LxgcU/EolmWp+Hj7PfTtNu4GVxyB6+TAVKV4YRlVxC4MCvRkA+woQ04mwe9pbOIX
         CyK/lC1x7dq+kvhq7ANXnuDHC/lu/qQ+z6xLSxu5wGPADYm14oylzDdMbBYzPUDeHaMN
         VeLNTk0hRLnA2wHuDpLTaL/L/UTC3zg7kXyyzE7oJZuzn9gPi9CT9BYqJCgSpNZ+eH0A
         rltzUwVTeM17DYSUZO6UHqy9zwNUOr1+hPfg+owrf0h7KnsF+yXRT5/3flbASxPuoGm0
         Gw8urzd9R79NL/WMF1pxn4/+qTvm7tKPdSvaknUQu9r3WGFZZPCT6pGsmhpyfnOt00Ge
         TYag==
X-Gm-Message-State: AOAM531mMl3AUXLerxzdFmvEI7bUaBHbU6YExI+JmmYgCiTmQy0KuBK2
        ug0jJHepnKJTsfu1bGDK5WTTf/AX718FyXvsKpERfUc6
X-Google-Smtp-Source: ABdhPJzdceupu+bbZsLjk3kITUyooYKij10y5OCwJ2Xh0rpMhcHqT8SfD7On+n0vyz3BakrnqeIcvxAzYDAmetIouoU=
X-Received: by 2002:a02:c004:: with SMTP id y4mr11565414jai.81.1590838525918;
 Sat, 30 May 2020 04:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200527041711.60219-1-yangerkun@huawei.com> <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <20200527194925.GD140950@redhat.com> <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
 <20200528173512.GA167257@redhat.com> <CAOQ4uxhnsc8AHfeQJ-eHFEjyONRF5bXBvRd-D29Nao4Bz8EM0g@mail.gmail.com>
 <20200529141623.GA196987@redhat.com> <CAOQ4uxhie2s+yvF1jpPnh6-+a-r8kz589Y5znAX_jmeWqo+SCQ@mail.gmail.com>
 <20200529190058.GB196987@redhat.com>
In-Reply-To: <20200529190058.GB196987@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 30 May 2020 14:35:14 +0300
Message-ID: <CAOQ4uxhkgx_1s0BrjNtDU+uHrVunG9FnQGUGr+DpoKsx2iaUBA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 29, 2020 at 10:01 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, May 29, 2020 at 06:46:43PM +0300, Amir Goldstein wrote:
> > > > > @@ -1023,7 +1020,7 @@ struct dentry *ovl_lookup(struct inode *
> > > > >          *
> > > > >          * Always lookup index of non-dir non-metacopy and non-upper.
> > > > >          */
> > > > > -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> > > > > +       if (ctr && (!upperdentry || (!d.is_dir && !uppermetacopy)))
> > > > >                 origin = stack[0].dentry;
> > > > >
> > > >
> > > > I think this should be:
> > > >
> > > >           * Always lookup index of non-dir and non-upper.
> > > >           */
> > > >           if (!origin && ctr && (!upperdentry || !d.is_dir))
> > > >                  origin = stack[0].dentry;
> > > >
> > > > uppermetacopy is guaranteed to either have origin already set or
> > > > exit with an an error for ovl_verify_origin().
> > >
> > > Only if index is enabled and upper had origin xattr.
> > >
> > > (!d.is_dir && ofs->config.index && origin_path)
> > >
> > > So if index is disabled or uppermetacopy did not have "origin" xattr,
> > > we will not have origin set by the time we come out of the loop.
> > >
> >
> > True. But if index is disabled, setting origin is moot. origin is only
> > ever used here to lookup the index.
>
> Well, while looking up for index, we are checking for presence of
> index dir (and not checking whether index is currently enabled or
> not). So if somebody mounts overlayfs with index=on and later remounts
> with index=off, we can still start looking up the index even if it
> is not enabled. Is it intentional? If not, to simplify it, should
> we lookup index only if it is enabled.
>
>         if (origin && ofs->config.index &&
>             (!d.is_dir || ovl_index_all(dentry->d_sb))) {
>                 index = ovl_lookup_index(ofs, upperdentry, origin, true);
>

What do you mean by remount? actual -o remount cannot
change any overlay config variables.
For umount/mount,  ofs->indexdir doesn't mean that there is an
index dir, it means that index dir is in use because index is enabled.
See:

        if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
...
                err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
...
        if (!ofs->indexdir) {
                ofs->config.index = false;

Most of the code checks for ofs->indexdir.
The test for ofs->config.index is also correct, but inconsistent, although
I see that we also use ofs->config.index in other places in ovl_lookup().

>
> >
> > About "origin" xattr. If it is not set in upper that lower fs probably does
> > not have file handle support. In that case, index cannot be enabled
> > anyway.
>
> What about the case of multiple lower layers. IIUC, we will only
> ensure that top most lower layer has file handle support and not
> worry about rest of the layers. This will break the case of setting
> origin for !upperdentry. This will lookup index and fail if lower
> layer does not support file handle.
>
> So may be while enabling index, we should make sure all lower
> layers support file handles otherwise fail?
>

Enabling index requires that all layers support file handles:

                pr_warn("fs on '%s' does not support file handles,
falling back to index=off,nfs_export=off.\n",
                        name);
        }

> >
> > > I see for non-metacopy regular files, if upper did not have origin
> > > xattr, that means origin_path will by NULL. That means ctr will be
> > > 0 and that means we will not set "origin" for non-metacopy regular
> > > files in such case. So question is, should we set "origin" for
> > > metacopy upper files in such a case.
> > >
> > > We did not have origin xattr, but we looked up lower layers for
> > > upper metacopy. In theory, stack[0].dentry is origin for upper
> > > metacopy files. Should we use it? Current logic does not and that's
> > > why this additiona check (!d.is_dir && !uppermetacopy).
> > >
> >
> > I agree with your analysis, but this is a very theoretical discussion.
> > Unless I am missing something, I think we have written a very complex
> > condition for a corner case that doesn't seem to be valid or interesting.
>
> I agree. I want to simplify it too. Just trying to make sure that
> I don't end up breaking some valid configuration.
>
> >
> > Basically, for non-dir, if there is no "origin" xattr, then there should be no
> > index, because the metacopy feature was added way long after we
> > started storing "origin" on copy up. That's not the case for directories.
> >
> > There is one corner case where it may be relevant -
> > overlay layers with metacopy that were created on fs with no file handle
> > support (or no uuid) that are migrated to a filesystem with file handle
> > support (and metacopy xattr are preserved in migration).
> > In that case, index may be enabled while upper metacopy exists
> > without "origin".
> >
> > What happens if we do not set origin and do not lookup index in that case?
> > We can get two overlay inodes, both from different metacopy upper inodes
> > redirected to the same lower inode, that have the same st_ino, but differnt
> > metadata.
>
> We do not set origin on upper for broken hardlinks. So we will report
> inode number from upper. I tried. it.

Good point. I figured we had to have some protection in place.

>
> I tried following.
>
> - touch foo.txt
> - ln foo.txt foo-link.txt
> - mount with metacopy=on
> - chwon test:test foo.txt
> - umount
> - Goto upper/ and remove origin xattr from foo.txt. But there should not
>   be one because we do not create ORIGIN for broken hardlinks if index is
>   not enabled.
> - mount overlay with index=on
> - Do stat on foo.txt and foo-link.txt. foo.txt reports inode number from
>   upper and foo-link.txt reports inode number from lower.
> - chown test:test foo-link.txt
> - stat foo-link.txt still reports inode number from lower.
>
> Anyway, at this point of time, how about following.
>
> - For non-upper dentry, always set origin.
> - For upperdentry, there are 3 cases.
>         - directories
>         - regular files
>         - regular metacopy files
>
>   For directories and regular metacopy files only use verified origin.
>   That means upper has origin xattr and it matches patch based looked
>   up dentry. If we did not verify because either ORIGIN xattr is not
>   there, or because index is not enabled or because ovl_verify_lower()
>   is not set, then don't use path based looked up dentry as origin.
>
>   For the case of regular file upper dentry, use unverified origin.
>   It implies that ORGIN xattr is there. As there is no path based
>   lookup origin for upper regular files.
>
> I am attaching a simple patch. Please let me know what do you think
> of it.
>
> >
> > > >
> > > > HOWEVER, if we set origin to lower, which turns out to be a lower
> > > > metacopy, we then skip this layer to the next one, but origin remains
> > > > set on the skipped layer dentry, which we had already dput().
> > > > Ay ay ay!
> > >
> > > We only skip the intermediate metacopy entries in lower. So top most
> > > lower metacopy will still be retained. For example, if there are 3
> > > lower layers where top two are metacopy and one data, then we will
> > > only skip middle one. And middle one should not be origin for upper.
> > >
> > >                 /*
> > >                  * Do not store intermediate metacopy dentries in chain,
> > >                  * except top most lower metacopy dentry
> > >                  */
> > >                 if (d.metacopy && ctr) {
> > >                         dput(this);
> > >                         continue;
> > >                 }
> > >
> > > For the first lower, ctr will be 0 and we will always store it in
> > > stack. So if it is metacopy dentry, it will still be stored at
> > > stack[0].
> > >
> > > Do you still see the problem?
> >
> > No. it's fine. My eyes missed the ctr condition.
> > I still think since you are changing this code.
> > It will be much easier to follow if both simple continue statement
> > are at the top of the loop.
>
> Ok, will do.
>
> Here is the patch to simplify the condition or origin. I will add some
> changelog and comments in code in v2 of patch if you like the patch.
>
> Thanks
> Vivek
>
>
> ---
>  fs/overlayfs/namei.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> Index: redhat-linux/fs/overlayfs/namei.c
> ===================================================================
> --- redhat-linux.orig/fs/overlayfs/namei.c      2020-05-29 14:24:45.997113946 -0400
> +++ redhat-linux/fs/overlayfs/namei.c   2020-05-29 14:46:46.692113946 -0400
> @@ -1005,6 +1005,7 @@ struct dentry *ovl_lookup(struct inode *
>                 }
>                 stack = origin_path;
>                 ctr = 1;
> +               origin = origin_path->dentry;
>                 origin_path = NULL;
>         }
>
> @@ -1021,9 +1022,9 @@ struct dentry *ovl_lookup(struct inode *
>          * index. This case should be handled in same way as a non-dir upper
>          * without ORIGIN is handled.
>          *
> -        * Always lookup index of non-dir non-metacopy and non-upper.
> +        * Always lookup index of non-upper.
>          */
> -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> +       if (!origin && ctr && !upperdentry)
>                 origin = stack[0].dentry;
>

As I wrote in review, the condition could be further simplified to
(!upperdentry).

Thanks for digging up the truth,
Amir.
