Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B16C433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EFA623109
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391912AbhAZNM6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392569AbhAZNMv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Jan 2021 08:12:51 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BFAC0611C2
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Jan 2021 05:12:11 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id e15so2741149wme.0
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Jan 2021 05:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hQqBS4sOm/wPuXCu5FWOqNrlIqmbomhvPyCWmO6nJwA=;
        b=prHej1J/4vB2Emvgo1vFRYfnRK6LBSyN+dhmZHiSImDX7zs7fRzD4mf1Us6upEiE6G
         FRtuUqmoAWES/PEP6j4be4aIGa0no8aJbRGmFJPtA6bGQ8iWzTnD/UT4r/Ba5qE13FUm
         4vOFOEe2bPDBGAxNNr1sx9WW1ha5NdKCkmSdk98A3uesN7Sy+etK7JFv7Q5rMzkmlL6L
         AZJYHho7DyeN1ridT0zbUm6DfX6MFCxZdzTtfnEteoxtv1G/GVA0pETEW3YsaPg5+HQE
         H9XVcm8Qpyod/krQOWIAzBQpRr6VTa/nSm6KKdBY/xtFuVF7nzC4GIFBZqZZ86WMWTku
         ci8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hQqBS4sOm/wPuXCu5FWOqNrlIqmbomhvPyCWmO6nJwA=;
        b=jRpFWfvoGSqau+OH4Yc+KbNkgI3Gr4EhoILL4mVx/uoVzTic6eK60+67KeS152XsMq
         DFXJaxU5MRUbkNuvIstH2ewuUxIWk8CYUY073GJEMl36/tgG0DgTIqUfZxTpskKGtcrj
         lRwiwnsxdXPMoGD+dU/AiRQv0sskHsehLQ6W4x6IC+eh5ZHNXKpN2KCly2yRLAG812DX
         P2VLAT0a+weASayuSiGDDPyQFSMOkQePsPA7fS3g9ZMUOg6ocs7AZENVwRiCJh2XBg5t
         0eDbIXWe7BLo7bDwn+BlmBRgEVjL9Ht8bGysrZA44hiEOJILdi/g67I6C/suANHrURNA
         qxVA==
X-Gm-Message-State: AOAM53216Wtxgsq7UokbTCaq+I4Fdotso3CRjMozJF4yjxZAzxjRMGU7
        OzLXRQblhDQ7BdQm+3+YZirYpB1DHDyK5g==
X-Google-Smtp-Source: ABdhPJxdrT9wVZFS2NTVqw/GPObdzTLMVn8TrPY5UYD6QO09nZSIxeQWnUtTW8EYcsSH+6xrtKwLzQ==
X-Received: by 2002:a1c:5454:: with SMTP id p20mr4576538wmi.128.1611666729971;
        Tue, 26 Jan 2021 05:12:09 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:813d:7e5d:50ae:31a])
        by smtp.gmail.com with ESMTPSA id 62sm3367139wmd.34.2021.01.26.05.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 05:12:09 -0800 (PST)
Date:   Tue, 26 Jan 2021 13:12:07 +0000
From:   Alessio Balsini <balsini@android.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Alessio Balsini <balsini@android.com>
Subject: Re: Lazy Loading Layers (Userfaultfd for filesystems?)
Message-ID: <YBAVJ/zFj6ade9V+@google.com>
References: <20210125194848.GA12389@ircssh-2.c.rugged-nimbus-611.internal>
 <CAOQ4uxiX4Q=i1ig_P9gvBgryazLEGfdpULbwGR+C2hjKi74Jog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiX4Q=i1ig_P9gvBgryazLEGfdpULbwGR+C2hjKi74Jog@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Thanks Amir for looping me in the discussion.

On Tue, Jan 26, 2021 at 07:18:29AM +0200, Amir Goldstein wrote:
> On Mon, Jan 25, 2021 at 9:54 PM Sargun Dhillon <sargun@sargun.me> wrote:
> >
> > One of the projects I'm playing with for containers is lazy-loading of layers.
> > We've found that less than 10% of the files on a layer actually get used, which
> > is an unfortunate waste. It also means in some cases downloading ~100s of MB, or
> > ~1s of GB of files before starting a container workload. This is unfortunate.
> >
> > It would be nice if there was a way to start a container workload, and have
> > it so that if it tries to access and unpopulated (not yet downloaded) part
> > of the filesystem block while trying to be accessed. This is trivial to do
> > if the "lowest" layer is FUSE, where one can just stall in userspace on
> > loads. Unfortunately, AFAIK, there's not a good way to swap out the FUSE
> > filesystem with the "real" filesystem once it's done fully populating,
> > and you have to pay for the full FUSE cost on each read / write.

Sargun's use case has some similarities with IncFS
(https://source.android.com/devices/architecture/kernel/incfs).
The main purpose of IncFS is not to save space, but to allow the user to
open apps as soon as possible, by making them accessible also if
partially downloaded. Without going out of topic with implementation
details, IncFS also needs to handle extra things like live data
(de)compression, and here's where it diverges from Sargun's idea.
The reason why I mention this is that the first IncFS prototypes were
based on FUSE, but because of the performance regression introduced by
the FUSE daemon round-trip we were forced to proceed with a separate
kernel module implementation.

> 
> Unless you used FUSE_PASSTHROUGH:
> 
> https://lore.kernel.org/linux-fsdevel/20210125153057.3623715-1-balsini@android.com/
> 
> Only in current v12 patchset, a passthrough capable FUSE is declared
> non-stackable by setting s_max_depth = FILESYSTEM_MAX_STACK_DEPTH.
> This wasn't done deliberately in order to deny stacking of overlay of top
> of passthrough capable fuse, but in order to deny stacking passthrough fuse on
> top of each other.
> 
> I mentioned in one of the reviews that this limitation could become
> a problem if someone where to do exactly what you are trying to do.
> It should not be a problem to relax this limitation, it just did not feel fair
> to demand that for initial version of passthrough fuse, before there was an
> actual use case. I am sure you will be able to lift that limitation if it stands
> in your way.
> 
> 

It would be nice to see that FUSE passthrough can be helpful in this
scenario as well.
Like Amir was mentioning, the stacking limitation of this first
passthrough implementation has been chosen super strict as a safety
measure, but nothing prevents us from relaxing it in the future as
stacking becomes mandatory for certain use cases and after we properly
analyze all the corner cases.

> >
> > I've tossed around:
> > 1. Mutable lowerdirs and having something like this:
> >
> > layer0 --> Writeable space
> > layer1 --> Real XFS filesystem
> > layer2 --> FUSE FS
> >
> > and if there is a "miss" on layer 1, it will then look it up on
> > layer 2 while layer 1 is being populated. Then the FUSE FS can block.
> 
> Interesting.
> How would you verify that mutating the lowerdir doesn't result in
> "undefined behavior"?
> It would be nice if for some images, you could fetch a "metacopy" image from
> some "meta" image repository, to use as layer1. It that a possibility
> for your use case?
> At least if the only mutation allowed on layer1 was a data copy up, it would
> be pretty easy to show that overlayfs behavior will be well defined.
> When FUSE knows that data in Real fs file has been populated, it can remove the
> metacopy xattr and invalidate the fuse dentry, causing ovl dentry
> invalidate and then
> re-lookup will constructs the ovl dentry without the FUSE layer.
> 
> > This is neat, but it requires the FUSE FS to always be up, and incurs
> > a userspace bounce on every miss.
> >
> 
> You may be able to shutdown the FUSE fs eventually. At the end of the
> population process, issue a "layer shutdown" ioctl to overlayfs, that will
> mark the layer as shutdown. ovl_revalidate() will invalidate any ovl dentry
> with a shut down layer in its lower stack and ovl_lookup()/ovl_path_next()
> will skip lower stack dentries in shut down layers.
> 
> When there are no more open files from fuse and no more ovl dentries
> with fuse layer in their lower stack, the fuse layer mnt refcount should
> drop to 2(?) and it should be possible to carefully release the root ovl
> dentry lower stack entry and finally the layer itself.
> A refcount on the layer will probably be to correct pattern to use.
> 
> > It also means things like metadata only copies don't work.
> >
> 
> Why?
> I can see there are some feature limitation due to FUSE having no UUID,
> but this should be solvable too.
> 
> > Does anyone have a suggestion of a mechanism to handle this? I've looked into
> > swapping out layers on the fly, and what it would take to add a mechanism like
> > userfaultfd to overlayfs, but I was wondering if anything like this was already
> > built, or if someone has thought it through more than me.
> >
> 
> I've seen many projects that try to do similar things but not using overlayfs:
> Android Incremental FS, ExtFUSE, libprojfs.
> 
> If I were to tackle this task, I would choose to enhance FUSE_PASSTHROUGH
> to be able to passthrough for more than just read/write, to the point
> that it could
> eventually satisfy the requirements of all those projects above,
> something that I
> have discussed with Alessio in the past.
> 
> When that happens, you might as well call passthrough FUSE "Userfaultfd for
> filesystems" if you wish ;-)
> 
> Thanks,
> Amir.

Thanks for advocating the use of FUSE passthrough! :)
Sargun, if read/write performance was your main concern, the current
version of FUSE passthrough should already make the trick. You can also
find a libfuse repository in the list that contains the minimal changes
to enable it in your fs.

My TODO list already has a bunch of further extensions, e.g. passthrough
for directory operations, but I'm currently blocked on the series to get
merged upstream. This is both because I would love the community to
start exploring FUSE passthrough and come out with additional feature
requests that would help me prioritize what comes next, and to avoid
accumulating too much tech debt: working on top of out-of-tree changes I
risk that all my FUSE passthrough extensions work will never come to
life. So, fingers crossed that I made everything right with this V12! :)

Thanks,
Alessio

