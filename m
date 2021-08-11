Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2B1C4338F
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Aug 2021 06:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F136056C
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Aug 2021 06:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhHKGvq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 02:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbhHKGvo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Aug 2021 02:51:44 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD10C061765
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Aug 2021 23:51:21 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id a4so1727658ilj.12
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Aug 2021 23:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7s8eijux9RiT9EoX5/dJ8Mv2zx7Hr/jDfPy7Er+RCd0=;
        b=SZGsUe1fSPYvuxuO0Rzh0N6nAjeoEOjVR5neHHl7qIejg+S6EH0LUY/isBvrhBeMX0
         n3NmCwSkRbNy6ptYg0ccUHLvit85cPVw9PTeK/y3t4KsiEIaB0gEmS8YvaX6wkhMLh3z
         WOwxAbaOH/b6Y6q8h1xUIp8qe8Hyyw2jddg7RAvO1Yd2oFToFjgCqOj8Wyq6zKINYiIf
         u09lVsFIc+PoqZ/5zJYgqOxlbIH4Va7niVZTnBX/0k2rRwPaE+goFHp2T0Qv18dIEHxh
         8pMsXpBuJf3MYE4RPWuyQWUk0X6HWNw8M89LpNDXPkou1NBfgk7YrtLKUMBxOyvNQcCW
         yjRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7s8eijux9RiT9EoX5/dJ8Mv2zx7Hr/jDfPy7Er+RCd0=;
        b=OMVhS11sVaftn1tvaWZF8esoeG2cpjLe3/6cZ5yilo4mg5F3nATVz8HG1w3OBSVY8f
         j6Wwz/QUqukX0ZQfQo5BiV4MqkICwypg3kOcmFBtVgI3TUE7rPPm3TDGI0j3xdQ/M7ln
         f2hHsgHcLzDpoHnA+AvHB3cDfCcLPKR+Cvav3rKuP9nuxi8QDi4jGWd1Us+xnBl1z5Z2
         hahToysrotxSUJ94/gpm4ADoqPhoHXRe1jait3klwc00ONMGNMSarUp4i19k/0w207u5
         d6U3IlfAmqJARCMyM2iMpwlF6V9iAlMTbSAMZFWN64rHTc+Kakj4Wj6waOZtXVjWmbAa
         H/VQ==
X-Gm-Message-State: AOAM533ocToHubBPfsxwFKIyCEctuQRdhybhWfKjpcI+xkpf73HmruLx
        p9ge+qOktimkpTSSxv8/HikJED24TJta0iRtCQU=
X-Google-Smtp-Source: ABdhPJxTei/55V8/d1w7H+OX4I5inLtrkxabtBuIZ9z7tsv+/aSJdUVm5AKnQdUy7+qQnl70VO/gIg/ZIOd0efa2SGQ=
X-Received: by 2002:a92:c94f:: with SMTP id i15mr214854ilq.72.1628664680459;
 Tue, 10 Aug 2021 23:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
 <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
 <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com>
 <YRGfmx+xXVvERhhx@redhat.com> <CAOQ4uxhih4z=0xtuN4X11DY1xdhzsaQRDrtwuWFP2bejc41dWA@mail.gmail.com>
 <YRLYJ4uXLNR7NSmi@redhat.com>
In-Reply-To: <YRLYJ4uXLNR7NSmi@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 11 Aug 2021 09:51:09 +0300
Message-ID: <CAOQ4uxiQwzxhg4oTxREG8ucTY+zG_zDd3isKnZcCAHoL-3TJhg@mail.gmail.com>
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and metacopy?
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Nalin Dahyabhai <nalin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 10, 2021 at 10:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Aug 10, 2021 at 07:17:23AM +0300, Amir Goldstein wrote:
> > On Tue, Aug 10, 2021 at 12:35 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Sat, Aug 07, 2021 at 07:37:00PM +0300, Amir Goldstein wrote:
> > > > On Sat, Aug 7, 2021 at 2:05 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Sat, Aug 7, 2021 at 1:17 PM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> > > > > >
> > > > > > Hi, all.
> > > > > >
> > > > > > As title said. I wonder to know the reason for overlayfs mount failure
> > > > > > with '-o nfs_export=on,metacopy=on'.
> > > > > >
> > > > > > I modified kernel to enable these two options 'on',  it looks like that
> > > > > > overlayfs can still work fine under nfs_v4.
> > > > > >
> > > > > > Besides, I can get no more information about the reason from source
> > > > > > code, maybe I missed something.
> > > > > >
> > > > >
> > > > > It's because ovl_obtain_alias() (decoding a disconnected non-dir file handle)
> > > > > does not know how to construct a metacopy overlayfs inode.
> > > > >
> > > > > Maybe Vivek will be able to point you to the discussion that lead to making
> > > > > the features mutually exclusive.
> > > > >
> > > > > I don't remember any other reason.
> > > > >
> > > >
> > > > I remembered some more details...
> > > >
> > > > I think the main complication discussed w.r.t decoding a metacopy
> > > > inode was for the case where ovl_inode_lowerdata() differs from
> > > > ovl_inode_lower().
> > > >
> > > > If we had a weaker variant of metacopy (e.g. metacopy=upper) that
> > > > only allows creating and following metacopy inodes in the upper layer,
> > > > it would have been simpler to implement ovl_obtain_alias().
> > > >
> > > > Specifically, when ofs->numlayer == 2 (single lower layer), there can
> > > > be no valid metacopy inodes in the lower layer, so that configuration
> > > > should also be rather easy to support.
> > >
> > > Hi Amir,
> > >
> > > /me does not understand well the notion of disconnected dentries and
> > >  how nfs export stuff works. So please bear with my stupid questions.
> >
> > No stupid questions ;-)
> >
> > Without getting into the hairy details of nfs export there are a few basic
> > things to consider:
> > - A file handle does not encode the path, only an inode identifier
> > - A non-directory inode may have multiple paths (hardlinks)
> > - Most filesystems do not store path information in inode on-disk for
> >   non-directory inode (the ".." entry stores the path for a directory)
> > - When filesystem is asked to decode a file handle and does not find the
> >   inode in question in inode cache nor a dentry in dcache, the only resort
> >   is to instantiate a "disconnected" dentry with unknown path
> > - Later "normal" lookup() by path that resolves to the same inode, does not
> >   make that "disconnected" dentry connected. Istead, lookup() instantiates
> >   another connected dentry "alias" to the same inode
> >
> > All this has some implications when enabling nfs_export for overlayfs:
> > 1. ovl_obtain_dentry() needs to be able to cope with a disconnected
> >     'real' dentry
> > 2. Since ovl_obtain_dentry() cannot assume to know the path of the
> >     'real' dentry, it needs to know how to instantiate a disconnected
> >     overlayfs dentry
> > 3. Other overlayfs code needs to be able to cope with a disconnected
> >     overlayfs dentry (for example, copy up only to index)
>
> Hi Amir,
>
> Thanks for giving a summary. It helps a lot.
>
> >
> > >
> > > I am wondering why a lower inode can't be metacopy inode. For the
> > > normal lookup case, we can lookup in all lower layers and figure out
> > > which is actual data inode and which inodes are metacopy inodes.
> > >
> > > For the case of disconnected dentry, we probably can't do lookup. So
> > > are calling underlying filesystem to decode. (Using origin?). If yes,
> > > will intermediate lower not have origin xattr which we can use
> > > to follow the complete lower chain and reconstruct all real lower
> > > dentries and use lower data dentry and latest lower meatacopy dentry
> > > (in the same way we do as for lookup).
> >
> > We can do that. I did not say we cannot.
> > I just said it would be simpler if we can avoid this complication
> > and I listed the guidelines for the "simple" implementation.
> >
> > But beyond the complexity, what is the benefit?
> > I was under the impression that container manager do not know how
> > to build images with metacopy, so what are the chances of actually
> > seeing metacopy in middle layers in the wild?
>
> Sure, we don't put metacopy inodes into portable images. But I thougt
> this could be part of a lower directory on same system. For example,
> docker devicemapper driver used to take an image and explode that
> on a thin volume. Then it will take a snaphost, modify some files
> and prefix that intermediate state with "-init". And then containers
> will use this "-init" as base for container rootfs and take snapshot
> of this.
>
> I am not sure if container managers are doing this for overlayfs
> or not on same system. But I will not be surprised if somebody
> decides to do that. That's is change some metadata in image
> (which triggers metacopy) and then use upper layer as lower layer
> for container rootfs.
>
> [ CC Dan Walsh and Nalin Dahyabhai ]
>
> Dan, Nalin, I think now metacopy feature is being used in podman and
> container/storage. Do we ever create lower layers in such a way that
> metacopy inodes can be present in lower layers?
>
> >
> > IOW, if we implemented metacopy=upper (only allow metacopy in
> > upper layer), would it be sufficient for the use cases that need to enable
> > nfs_export?
>
> IMHO, it will be good if we don't add one more variation to metacopy
> option. Even if container managers will find it hard to ensure that
> there are no metacopy inodes in any of the lower layers. And will
> find it difficult to use this option.
>
> IIRC, while adding metacopy option, you had mentioned that it is possible
> that intermediate layers have metacopy inodes. So I changed implementation
> to take care of it. :-) And now you are the one suggesting not allowing
> metacopy inodes in lower layers with nfs_export. :-)
>

Maybe. It wouldn't be the first time ;-)
IIRC the idea to lookup metacopy by path+redirect was Miklos' not mine.
I was thinking in terms of following by origin back then.

The eventual code in ovl_lookup() follows upper by origin and all layers
by path+redirect and only checks for agreement of origin and redirect from
upper layer.

Implementing "follow metacopy in middle layers by origin" in ovl_obtain_alias()
is possible and even not too complicated, but it would be inconsistent
with ovl_lookup() and if somebody mangaled with lower layers (i.e. rename
lower file), decode file handle can result in a different inode than the encoded
one.

In that case we have several options:
1. Whatever - documentation already claims that modifying lower layer
    after using index/metacopy results in undefined behavior
2. Fortify ovl_lookup() - also follow origin from middle layers and check
    for agreement with follow by path+redirect

> If given a choice, I would prefer that we support metacopy inodes
> in lower layers as well with nfs_export and not create a new option
> metacopy=upper.
>

Certainly. I agree with that POV. We just need to understand the
consequences.

I personally have no problem with the "Whatever" option above.
And the "Fortify" option isn't that complex either.

I just thought that if Zhihao Cheng wanted to start with minimal
testable implementation, that limiting nfs_export+metacopy to a single
lower layer, may be an easier start.

Overlayfs nfs_export is quite likely being used in OpenWrt and IIUC,
OpenWrt uses a single (squashfs) lower layer.

Therefore, enabling metacopy for the single lower layer case may be
valuable to some actual users and not only as a stepping stone before a
complete solution.

Thanks,
Amir.
