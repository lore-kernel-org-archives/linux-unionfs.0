Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3A4C433E0
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 14:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B1F26519C
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 14:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCIOaJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 09:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCIO3y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Mar 2021 09:29:54 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB79AC06174A
        for <linux-unionfs@vger.kernel.org>; Tue,  9 Mar 2021 06:29:53 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id b5so12314733ilq.10
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Mar 2021 06:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sFQge4/pqmqzQiDaHjVLooJJCDaoIhW5QhmUReEBMXQ=;
        b=BsUDGqPkW0aIQt+EogFYdmUZKjOsEYk51yhCzRZtb074s6POsjh2X59mYj4a1EL3OT
         GXTu5pyseMR+B9d2EKYtLN1Gpu1w+7O8Bb2jyLTE5D5UpMqgdfxgHeTz9U9n8HXnjWtU
         XTlov7Y0u6cJT5ioEHilk5ma9Gb3JXDs6I+wtOoagYfO8yBWZKo9zQF+FsziGx1RFQrZ
         VWzJZxoP9mjc7b0EYWHPteXRk+wFWV/etDhizWMBt0AQvUsZ8AJvGN05mXvgvFfqnEni
         AlSm5aGRhPvdKJE+5qp2g4PMcoaPFJj3or7slBTG8v0fKgGKSAa6mg2fOb7OdntIID2o
         h9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sFQge4/pqmqzQiDaHjVLooJJCDaoIhW5QhmUReEBMXQ=;
        b=VUpha3pus0k/hjvNhnSKduG+t4+NixY9gs+vfFgChrUuRjFv3H9z3hAUpwd20FK0L9
         DX7k2fc9rHCV4vvJEn8VrbBj034tm+/C63A4KTQtkmh+FMW/EIv/A8PsxXSd6WR2waI8
         iJKVNoI3hxTHTKax/u0sa1asfcBZo7zQXyBqkWuN/ZEphzof9dmnH07F6QiAi9dWFFqu
         S5x9rtgE7z2HOrU6znPignRBzBntl2FwDxnw72d5iwd4R8SKT3nz41aDp3miFHJvBiPg
         xlwH6ZmfOQJayy3MMP+mXmkqO4apsvEFJ01jGYpt4oLnY6+c+f92xQcqp4fcDO1dUgiw
         /rWg==
X-Gm-Message-State: AOAM5313vjoQGc6hKhDzQzndFdxh01aFSFJrzcnD4JudXajHD3H7oSka
        G3amoCLaxrEMV3T72KHnc/GLM4HlkugYsq3s7u/oaoQspkQ=
X-Google-Smtp-Source: ABdhPJybB/MSWaRp7VSOHegLQbqglNDzNuhjDNyOgMTXaCKKz05mUiKqxj3I89diAVqllBqOPzUI0aKQqgXaf2UyUGE=
X-Received: by 2002:a92:da48:: with SMTP id p8mr23618753ilq.137.1615300193338;
 Tue, 09 Mar 2021 06:29:53 -0800 (PST)
MIME-Version: 1.0
References: <CAOQ4uxj4zNHU49Q6JeUrw4dvgRBumzhtvGXpuG4WDEi5G7uyxw@mail.gmail.com>
 <b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name>
 <CAOQ4uxhGSbEPPwZswXHq+k1YF=+ntDfukxnfGsJ3+RaGjgNDnQ@mail.gmail.com>
 <YEa4Jd0VE6w4T7/v@kevinlocke.name> <CAOQ4uxjBb_whXA5eNqkwDNj2VSS-F+0uACF7tpqFTrM8fYETQg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjBb_whXA5eNqkwDNj2VSS-F+0uACF7tpqFTrM8fYETQg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 9 Mar 2021 16:29:42 +0200
Message-ID: <CAOQ4uxjvGLtiyj5upsYOjnqiGnij+ar8k6v=zv0ceS9k44UMRQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: add xino to "changes to underlying fs" docs
To:     Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Cc:     Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 9, 2021 at 9:24 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Mar 9, 2021 at 1:50 AM Kevin Locke <kevin@kevinlocke.name> wrote:
> >
> > Hi Amir,
> >
> > On Mon, 2021-03-08 at 19:41 +0200, Amir Goldstein wrote:
> > > On Mon, Mar 8, 2021 at 5:23 PM Kevin Locke <kevin@kevinlocke.name> wrote:
> > >> Add "xino" to the list of features which cause undefined behavior for
> > >> offline changes to the lower tree in the "Changes to underlying
> > >> filesystems" section of the documentation to make users aware of
> > >> potential issues if the lower tree is modified and xino was enabled.
> > >>
> > >> This omission was noticed by Amir Goldstein, who mentioned that xino is
> > >> one of the "forbidden" features for making offline changes to the lower
> > >> tree and that it wasn't currently documented.
> > >
> > > [...]
> > > When looking again, I actually don't see a reason to include "xino"
> > > in this check at all (not xino=on nor xino=auto):
> > >
> > >  if (!ofs->config.index && !ofs->config.metacopy && !ofs->config.xino &&
> > >      uuid_is_null(uuid))
> > >          return false;
> > >
> > > The reason that "index" and "metacopy" are in this check is because
> > > they *need* to follow the lower inode of a non-dir upper in order to
> > > operate correctly. The same is not true for "xino".
> > >
> > > Moreover, "xino" will happily be enabled also when lower fs does not
> > > support file handles at all. It will operate sub-optimally, but it will live up
> > > to the promise to provide a unified inode namespace and uniform st_dev.
> >
> > Good observation!  I think you are right.  After a bit of testing, I did
> > not notice any issues after making offline changes to lower with xino
> > enabled.
> >
>
> He, that's not what I meant.
> I wouldn't expect that you *observe* any issues, because the issues
> with following the wrong object are quite rare and you need to make
> changes to lower squashfs to notice them, see:
> https://lore.kernel.org/lkml/20191106234301.283006-1-colin.king@canonical.com/
>
> But as a matter of fact, I was wrong and I misled you. Sorry.
>
> I read the code backwards.
>
> It's not true that we can allow lower modification with "xino=on/auto" -
> quite the opposite - we may need to disallow lower modifications also
> with "xino=off".
>
> Let me explain.
> The following table documents expected behavior with different
> features and layer setups:
> https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#inode-properties
>
> As you can see, the matrix is quite complex.
> The problem lies with the documented behavior of "Persistent st_ino of !dir"
> for the case of "Layers not on same fs, xino=off".
>
> It claims that st_ino will be persistent, but in fact it is only true
> if lower fs
> supports file handles AND has a unique [*] UUID amongst the lower layers.
> The claim that st_ino is persistent for !dir in case of "ino overflow" is also
> incorrect.
>
> [*] The special case of NULL UUID (e.g. squashfs) was recently changed
>      and depends on whether the opt-in features are enabled...
>
> In any case, the documented behavior for Persistent st_ino (!dir) is
> incorrect for the case of (e.g.) lower squashfs with -no-exports.
> IWO, in this setup, st_ino of a lower file will change following copy up
> and mount cycle.
>
> I do not want to add all this story to documentation - the matrix is
> complex enough to follow as it is.
>

This came out too complicated. Let me try again -

The documentation in the section:
https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#overlay-objects
speaks about overlayfs objects having non-unique and non-persistent st_ino.
It then goes on to say that "xino" can be used to make overlayfs "compliant",
but in fact never speaks of persistent st_ino until the comparison table,
where the documented values are incorrect.

So I decided to try and promote "xino" from a feature that "makes inode
numbers unique" to a feature that "makes inode numbers unique and
if possible, also persistent" by adding the following text to the section:

"...
The "xino" feature can be enabled with the "-o xino=on" overlay mount option.
If all underlying filesystems support NFS file handles, the value of st_ino
for overlay filesystem objects is not only unique, but also persistent over
the lifetime of the filesystem.  The "-o xino=auto" overlay mount option
enables the "xino" feature only if the persistent st_ino requirement is met.
..."

And with this I pured new meaning into xino=auto, which lost its original
meaning after commit:
926e94d79baf ("ovl: enable xino automatically in more cases")

The code change is to fall back from xino=auto to xino=off in cases
where the lower layer has no file handle support or bad uuid.

I'll post the patch for review soon.

Thanks,
Amir.
