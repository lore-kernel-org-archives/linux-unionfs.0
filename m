Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A339C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Jan 2021 04:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A74205CA
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Jan 2021 04:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbhA0E41 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731765AbhAZFTB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Jan 2021 00:19:01 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA3CC061788
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Jan 2021 21:18:41 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id u17so31447028iow.1
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Jan 2021 21:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ohYv/1DCriRoslae5qul3GB6tTLFOCExUM5bB7qowgA=;
        b=Jl/eD5UKnZIZvJPZPQdrlHC2tjgcf/Lu3a50o2OOjd/5kF+Jt+STVN3u9f4Ml59H3Y
         YNbcGW5x2sfQTNHNvw/E7+8W1mo7qh5FwlX3czuCf3K6Q1YTIQtw5TAMp75Ku1nA939D
         8tnMvoqlREAGQVGETnI06Zr6wPMweEOvg8YZUdc2DYs27TBNwkYMArdKjWBJOU7zXuuO
         SbTzVWakB0isvzlZ6K9zVqSTCSka62PhV7jH+o9774p3kvMiC8P8d/Vr2bHuUX4e/drQ
         TkH1LkogEmOXYHDAqiUSPYXJKAMjIZJCYQ98H/IQ0hMQRJLIPtjiZ0QqjozafPg4EYPh
         SfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ohYv/1DCriRoslae5qul3GB6tTLFOCExUM5bB7qowgA=;
        b=GwZTvNDVxHie5N1qv7iAlytcLM4oJ7jHsmykh1y3dbHUBveJdLFUyecl5g91j9+smy
         RxqDv5hT6pkFZMXxCYo/9ptIYkByasrGypnzBTbEoIr/0NDKkFCZrHznkPtEXilxQWJj
         lnIVkzwmy7j+JRoD+lUHkVR63fhUzpsyxDRmwfPh10MAndQfJNwmk99JHTO13yD53OYX
         S/H0yPvEY82ewGEE4ovxNTH4/j+OAe2VyPifsnGjmH08puypoawZbzi8ZUIzt1lZTqvq
         /K8AsMtD52waRw5LOPcL3AoHjxm4C7LPNA2MqHq/xHflpo/CEQcQVVyHNHkz1Y6h2byf
         /S0Q==
X-Gm-Message-State: AOAM531U2jGPa5Fv/rNs3RD6/p0MI8IpgHOI9gvdVP4xFGAa1ZyFbCuj
        6+T1qX1W9yT5jZ+qqrCFFA5pcZt4dWjGSjBahThDZjlVsjU=
X-Google-Smtp-Source: ABdhPJy7a2wUna5sskK068WnAetU6iM+Rwx4WNHPMapqfHVjW6ehkKHfQnavtrHjtpXNGSGYbXRUErYk7VGXPzfMDQw=
X-Received: by 2002:a92:d3c7:: with SMTP id c7mr3245764ilh.137.1611638321125;
 Mon, 25 Jan 2021 21:18:41 -0800 (PST)
MIME-Version: 1.0
References: <20210125194848.GA12389@ircssh-2.c.rugged-nimbus-611.internal>
In-Reply-To: <20210125194848.GA12389@ircssh-2.c.rugged-nimbus-611.internal>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 26 Jan 2021 07:18:29 +0200
Message-ID: <CAOQ4uxiX4Q=i1ig_P9gvBgryazLEGfdpULbwGR+C2hjKi74Jog@mail.gmail.com>
Subject: Re: Lazy Loading Layers (Userfaultfd for filesystems?)
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Alessio Balsini <balsini@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jan 25, 2021 at 9:54 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> One of the projects I'm playing with for containers is lazy-loading of layers.
> We've found that less than 10% of the files on a layer actually get used, which
> is an unfortunate waste. It also means in some cases downloading ~100s of MB, or
> ~1s of GB of files before starting a container workload. This is unfortunate.
>
> It would be nice if there was a way to start a container workload, and have
> it so that if it tries to access and unpopulated (not yet downloaded) part
> of the filesystem block while trying to be accessed. This is trivial to do
> if the "lowest" layer is FUSE, where one can just stall in userspace on
> loads. Unfortunately, AFAIK, there's not a good way to swap out the FUSE
> filesystem with the "real" filesystem once it's done fully populating,
> and you have to pay for the full FUSE cost on each read / write.

Unless you used FUSE_PASSTHROUGH:

https://lore.kernel.org/linux-fsdevel/20210125153057.3623715-1-balsini@android.com/

Only in current v12 patchset, a passthrough capable FUSE is declared
non-stackable by setting s_max_depth = FILESYSTEM_MAX_STACK_DEPTH.
This wasn't done deliberately in order to deny stacking of overlay of top
of passthrough capable fuse, but in order to deny stacking passthrough fuse on
top of each other.

I mentioned in one of the reviews that this limitation could become
a problem if someone where to do exactly what you are trying to do.
It should not be a problem to relax this limitation, it just did not feel fair
to demand that for initial version of passthrough fuse, before there was an
actual use case. I am sure you will be able to lift that limitation if it stands
in your way.


>
> I've tossed around:
> 1. Mutable lowerdirs and having something like this:
>
> layer0 --> Writeable space
> layer1 --> Real XFS filesystem
> layer2 --> FUSE FS
>
> and if there is a "miss" on layer 1, it will then look it up on
> layer 2 while layer 1 is being populated. Then the FUSE FS can block.

Interesting.
How would you verify that mutating the lowerdir doesn't result in
"undefined behavior"?
It would be nice if for some images, you could fetch a "metacopy" image from
some "meta" image repository, to use as layer1. It that a possibility
for your use case?
At least if the only mutation allowed on layer1 was a data copy up, it would
be pretty easy to show that overlayfs behavior will be well defined.
When FUSE knows that data in Real fs file has been populated, it can remove the
metacopy xattr and invalidate the fuse dentry, causing ovl dentry
invalidate and then
re-lookup will constructs the ovl dentry without the FUSE layer.

> This is neat, but it requires the FUSE FS to always be up, and incurs
> a userspace bounce on every miss.
>

You may be able to shutdown the FUSE fs eventually. At the end of the
population process, issue a "layer shutdown" ioctl to overlayfs, that will
mark the layer as shutdown. ovl_revalidate() will invalidate any ovl dentry
with a shut down layer in its lower stack and ovl_lookup()/ovl_path_next()
will skip lower stack dentries in shut down layers.

When there are no more open files from fuse and no more ovl dentries
with fuse layer in their lower stack, the fuse layer mnt refcount should
drop to 2(?) and it should be possible to carefully release the root ovl
dentry lower stack entry and finally the layer itself.
A refcount on the layer will probably be to correct pattern to use.

> It also means things like metadata only copies don't work.
>

Why?
I can see there are some feature limitation due to FUSE having no UUID,
but this should be solvable too.

> Does anyone have a suggestion of a mechanism to handle this? I've looked into
> swapping out layers on the fly, and what it would take to add a mechanism like
> userfaultfd to overlayfs, but I was wondering if anything like this was already
> built, or if someone has thought it through more than me.
>

I've seen many projects that try to do similar things but not using overlayfs:
Android Incremental FS, ExtFUSE, libprojfs.

If I were to tackle this task, I would choose to enhance FUSE_PASSTHROUGH
to be able to passthrough for more than just read/write, to the point
that it could
eventually satisfy the requirements of all those projects above,
something that I
have discussed with Alessio in the past.

When that happens, you might as well call passthrough FUSE "Userfaultfd for
filesystems" if you wish ;-)

Thanks,
Amir.
