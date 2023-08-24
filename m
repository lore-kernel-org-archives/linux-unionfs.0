Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAE7C3DA6F
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Aug 2023 09:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbjHXJ5k (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 05:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240788AbjHXJ5M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Aug 2023 05:57:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C641984
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Aug 2023 02:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692870982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t5D35/YF3j7SfLjzJ7e+wcourvHn1X1zuwevF/AdMdg=;
        b=hXjPK7Fp9m48YCYgpWybzYvzX30mSSVVEEvWXqhCY18ir++x7HTYOup84CMr5vG8eUoKQR
        BQ6wkbfthBiK0rkaoLmmQsSd2aIC7SOnkqPykjf5zLmDG3tDOOk72RqA5X99bHVGEEd8WZ
        lGbEmiI9GehfwRnLL2Uz0yepP8z3XOQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-zqahxSQvOeaf-XoHIhdkoQ-1; Thu, 24 Aug 2023 05:56:21 -0400
X-MC-Unique: zqahxSQvOeaf-XoHIhdkoQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-791432e4245so593286939f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Aug 2023 02:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692870980; x=1693475780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t5D35/YF3j7SfLjzJ7e+wcourvHn1X1zuwevF/AdMdg=;
        b=YyVlJ5fMwISJy8+v+6aZMwUD4VaLffA4mSTY0z+8Blxp5tCETBR1MqwDR4ULbI8qaT
         ny8ygCgr0aqgIAdqGLkbedxRlLJIOx4B0itvT7SUqPqnJ3kCWoOCFf9rnk+Q7NLm57TV
         aJnH0nUq+rIeIE5qeIXO6h56LAhl1/PSNwU0DESDtfYy9J8p+yxHXvNujwJ4O6fyjFCc
         8ed30xzSV0erV18MzK+iBNtXQQVWSrUtPXXyjDuMXhGCJNaGAmOsN4TrdDb05IQ2Yn9B
         TAOFGWBhPDiheYZoTDhHT53VQG1M88JrtOfwDX/QouqXIbz8lER2hwt82x0im4hWSAYv
         IvGg==
X-Gm-Message-State: AOJu0YynZX6oSeHbyAPKb4uHjcDTtlljh4prZZv6igTrHtCpLfBhIpTL
        cWX5ybwZ16NFxxI3GBTI2/rS/dudlN+CETXdktL1DJwLTQbfO1ryuJ9bf/RDF2WprLwGW3qTp3R
        /K0tV1ZGXLNVSP1D4+LE7mTrgmSu0ZqTaPV984Nscnj3ijth1tTO3
X-Received: by 2002:a05:6e02:1646:b0:349:a4f8:8815 with SMTP id v6-20020a056e02164600b00349a4f88815mr6588430ilu.2.1692870980006;
        Thu, 24 Aug 2023 02:56:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfiJaHsSxpudY2pZH3RywkIdgGD7gUoFnZv3CbzfZrGqPpl0ztEjvCTfyCb1yptTRshgc0XwYoCCvP1uULjQc=
X-Received: by 2002:a05:6e02:1646:b0:349:a4f8:8815 with SMTP id
 v6-20020a056e02164600b00349a4f88815mr6588415ilu.2.1692870979721; Thu, 24 Aug
 2023 02:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
 <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
 <CAOQ4uxhYH1SH5TbYfARDkep5p+xspUX2gq1HgMyLnv7J4=1emg@mail.gmail.com>
 <CAJfpegsv3fHwutkEq7S8PV9fYWC07BRUE8GMEpsnK1XkE2hb5w@mail.gmail.com> <CAOQ4uxhZySm0rNamtv3GNu8TFOZ66TdSzPVwwda16MQfWNKAQQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhZySm0rNamtv3GNu8TFOZ66TdSzPVwwda16MQfWNKAQQ@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 24 Aug 2023 11:56:08 +0200
Message-ID: <CAL7ro1EJy-Mx=y=CLfnjgFxwey5jjH0qXbMyAKx0OyqAG-wcZw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 23, 2023 at 5:50=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Wed, Aug 23, 2023 at 5:52=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Wed, 23 Aug 2023 at 16:43, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > If we do this, then both overlay.whiteout and overlay.xattr_whiteouts
> > > xattrs will be xattrs that the overlayfs driver never sets.
> > > It's a precedent, but as long as it is properly documented and encode=
d
> > > in fstests, I will be fine with it. Not sure about Miklos.
> >
> > Firstly I need to properly understand the proposal.  At this point I'm
> > not sure what overlay.whiteout is supposed to mean.   Does it mean the
> > same as a whiteout (chrdev(0,0))?  Or does it mean that overlayfs
> > should not treat it as a whiteout, but instead transform that into a
> > chrdev(0,0) for the top overlay to interpret as a whiteout?  Or
> > something else?
> >
>
> My proposal does not involve any transformation.
> It is "just" to support another format for a whiteout.
> Transforming a REG or FIFO real object to CHR ovl object
> will be a pain IMO and I don't see why it is needed.
>
> Let me try again from the top:
> 1. ovl_path_is_whiteout() checks if either ovl_is_whiteout() (chardev(0,0=
))
>     or regular file with "overlay.whiteout" xattr, so ovl_lookup()
> will result in
>     a negative dentry if either whiteout format is found at topmost layer
> 2. To optimize unneeded getxattr, "overlay.whiteout" xattr could be check=
ed
>     only in case the parent dir has xattr "overlay.xattr_whiteouts"
> 3. mkfs.composefs is responsible of creating the non-chardev whiteouts
>     as well as the marking the dirs that contains them with
>     "overlay.xattr_whiteouts" - overlayfs itself never does that
> 4. ovl_calc_d_ino() (from readdir on a merge dir) returns true if the
>     the iterated dir has "overlay.xattr_whiteouts" xattr
> 5. That will cause ovl_cache_update_ino() to lookup the
>     *overlay dentry* that will be negative (as per rule 1 above)
>     if either whiteout format is found at topmost layer and that
>     will cause the readdir dirent to be marked is_whiteout and
>     filtered out of readdir results
>
> * The trick for readdir is that the the per dirent DT_CHR optimization
>   is traded off for a per parent dir optimization, but even the worst cas=
e
>   where all directories have xattr_whiteouts, readdir is not more
>   expensive than readdir with xino enabled, which is the default for
>   several Linux distros
>
> Hope this is more clear?

Ok, so I implemented this, both using the transforming-to-whiteout and
the alternative-whiteout approach.

Here is the transform-to-whiteout approach:
  https://github.com/alexlarsson/linux/tree/ovl-nesting-transform

In it, if you have a lower dir with these files/xattrs:
 * lowerdir/foo - directory
     trusted.overlay.whiteouts
 * lowerdir/foo/hide_file - regular file
     trusted.overlay.whiteout

Then you will get an overlay no-userxattr mount like this:
 * lowerdir/foo - directory
 * lowerdir/foo/hide_file - chardev(0,0) file

This can be used as a lower in any overlayfs mount you want, userxattr or n=
o.

Here is the alternative-whiteout approach:
 https://github.com/alexlarsson/linux/tree/ovl-nesting-alternative

In it, if you have a lower dir with these files/xattrs:
 * lowerdir/foo - directory
     trusted.overlay.overlay.whiteouts
     user.overlay.whiteouts
  * lowerdir/foo/hide_file - regular file
     trusted.overlay.overlay.whiteout
     user.overlay.whiteout

Then you will get an overlay no-userxattr mount like this:
 * lowerdir/foo - directory
     trusted.overlay.whiteouts
     user.overlay.whiteouts
  * lowerdir/foo/hide_file - regular file
     trusted.overlay.whiteout
     user.overlay.whiteout

This can be used as a lower in any overlayfs mount you want, userxattr or n=
o.

I prefer the transform-to-whiteout approach for a two reasons:

Given an existing image (say an OCI image) we can construct an
overlayfs mount that is not just functionally identical, but also
indistinguible from the expected one. I.e. if the original OCI image
had a chardev(0,0) we will still have one in the mount.

When creating multiple lower dirs (e.g. from a multi-layered OCI
image) you have to carry forward xattrs on directories from the lower
layers to the upper, otherwise a merged directory from a higher layer
will overwrite the "overlay.whiteouts" xattr. This makes an otherwise
local operation (just escape the files in this layer) to a global one
that depends on all layers.

In terms of implementation complexity I think they are very similar.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

