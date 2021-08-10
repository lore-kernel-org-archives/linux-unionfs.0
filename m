Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE785C432BE
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 04:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC0976054E
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 04:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbhHJER7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbhHJER4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Aug 2021 00:17:56 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA5CC061799
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Aug 2021 21:17:34 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id s184so30561253ios.2
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Aug 2021 21:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PgHpAyuAZbN1L4qmVVUZ7+MTki/Ibzlw0BJLM7fjlYk=;
        b=atSVJjZSU2+BtGkpsHWG4/ShZQLBPI/OqpNb6coCfWMK1UuJsXATiBGAMxP3Ejao0A
         zhjAkh5dFwtvJ+fSYfgZkD0dSMHsN+8sQjwmrOLVCoNu1c6ATO4nImGfDXiuWTcMV76I
         VNYqTehX9tNv+HKXS1P3pmVjv2lYxG07lwGWrK/WLAqKw8lKcrAuJqFRM+6bLcOzcJdq
         wKQsnU3kY/8vyRhvFJvwSZBWI62SBBw5q3TT8mibfzIAPRCW1V+ca0tNO6Wox7xBbflq
         +kfUJa1FMaWuRR8x/BnVnAfc8uX8r9LrYxPEV1Rm8i7M1cVE+p+k/rlXdgrdg14Rb7Tf
         fsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PgHpAyuAZbN1L4qmVVUZ7+MTki/Ibzlw0BJLM7fjlYk=;
        b=niujv4TSXUUKS2a1u7GVTCH+hF8PfmI2X3kml6GLQ/uxcFdKDZkGWy1qZ51UL2eZfB
         Myb4WtEwwpV4Ns30WR8yJ+fv8u1VAkIt4HEp58QWcDhv2wb7zaX7O7V2oE6KI4BNsIem
         8c3jougMud9RNwbNl/W+Z9zOaHETKNNzsyvU6pURMukVrnesfj1a0YUztbYeRahH3Gbt
         orB+ro5WQKRkKNU4dIwskFFWxf0Ol+f1ESuw2QXg21UZqY8HrqD9k0MRMqROiqnhpLKm
         c//PcMjcohngDIp10hIyvr8qWLHqGsHZFtH2gQflSIlMMQJwRbOXDbeCjuiyYBCQKz35
         xSsw==
X-Gm-Message-State: AOAM532Vth74ROsEmQN6fFJb7Tphxdw7VD43Z/TR91DQlB6yiZNozQQk
        GffCdAIfMdc7eCeSyhXZs73DdXp0cJNCrv+/jfk=
X-Google-Smtp-Source: ABdhPJxfy11yvzkfINESPKl4VSpQdkpcMg9+xemCWT2lnqQJRjmfck5yxyDnA3NkbeKu9tEIqfqHKZjOD98vlPxmZ98=
X-Received: by 2002:a6b:7f48:: with SMTP id m8mr83780ioq.5.1628569054314; Mon,
 09 Aug 2021 21:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
 <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
 <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com> <YRGfmx+xXVvERhhx@redhat.com>
In-Reply-To: <YRGfmx+xXVvERhhx@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 10 Aug 2021 07:17:23 +0300
Message-ID: <CAOQ4uxhih4z=0xtuN4X11DY1xdhzsaQRDrtwuWFP2bejc41dWA@mail.gmail.com>
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and metacopy?
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 10, 2021 at 12:35 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sat, Aug 07, 2021 at 07:37:00PM +0300, Amir Goldstein wrote:
> > On Sat, Aug 7, 2021 at 2:05 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Sat, Aug 7, 2021 at 1:17 PM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> > > >
> > > > Hi, all.
> > > >
> > > > As title said. I wonder to know the reason for overlayfs mount failure
> > > > with '-o nfs_export=on,metacopy=on'.
> > > >
> > > > I modified kernel to enable these two options 'on',  it looks like that
> > > > overlayfs can still work fine under nfs_v4.
> > > >
> > > > Besides, I can get no more information about the reason from source
> > > > code, maybe I missed something.
> > > >
> > >
> > > It's because ovl_obtain_alias() (decoding a disconnected non-dir file handle)
> > > does not know how to construct a metacopy overlayfs inode.
> > >
> > > Maybe Vivek will be able to point you to the discussion that lead to making
> > > the features mutually exclusive.
> > >
> > > I don't remember any other reason.
> > >
> >
> > I remembered some more details...
> >
> > I think the main complication discussed w.r.t decoding a metacopy
> > inode was for the case where ovl_inode_lowerdata() differs from
> > ovl_inode_lower().
> >
> > If we had a weaker variant of metacopy (e.g. metacopy=upper) that
> > only allows creating and following metacopy inodes in the upper layer,
> > it would have been simpler to implement ovl_obtain_alias().
> >
> > Specifically, when ofs->numlayer == 2 (single lower layer), there can
> > be no valid metacopy inodes in the lower layer, so that configuration
> > should also be rather easy to support.
>
> Hi Amir,
>
> /me does not understand well the notion of disconnected dentries and
>  how nfs export stuff works. So please bear with my stupid questions.

No stupid questions ;-)

Without getting into the hairy details of nfs export there are a few basic
things to consider:
- A file handle does not encode the path, only an inode identifier
- A non-directory inode may have multiple paths (hardlinks)
- Most filesystems do not store path information in inode on-disk for
  non-directory inode (the ".." entry stores the path for a directory)
- When filesystem is asked to decode a file handle and does not find the
  inode in question in inode cache nor a dentry in dcache, the only resort
  is to instantiate a "disconnected" dentry with unknown path
- Later "normal" lookup() by path that resolves to the same inode, does not
  make that "disconnected" dentry connected. Istead, lookup() instantiates
  another connected dentry "alias" to the same inode

All this has some implications when enabling nfs_export for overlayfs:
1. ovl_obtain_dentry() needs to be able to cope with a disconnected
    'real' dentry
2. Since ovl_obtain_dentry() cannot assume to know the path of the
    'real' dentry, it needs to know how to instantiate a disconnected
    overlayfs dentry
3. Other overlayfs code needs to be able to cope with a disconnected
    overlayfs dentry (for example, copy up only to index)

>
> I am wondering why a lower inode can't be metacopy inode. For the
> normal lookup case, we can lookup in all lower layers and figure out
> which is actual data inode and which inodes are metacopy inodes.
>
> For the case of disconnected dentry, we probably can't do lookup. So
> are calling underlying filesystem to decode. (Using origin?). If yes,
> will intermediate lower not have origin xattr which we can use
> to follow the complete lower chain and reconstruct all real lower
> dentries and use lower data dentry and latest lower meatacopy dentry
> (in the same way we do as for lookup).

We can do that. I did not say we cannot.
I just said it would be simpler if we can avoid this complication
and I listed the guidelines for the "simple" implementation.

But beyond the complexity, what is the benefit?
I was under the impression that container manager do not know how
to build images with metacopy, so what are the chances of actually
seeing metacopy in middle layers in the wild?

IOW, if we implemented metacopy=upper (only allow metacopy in
upper layer), would it be sufficient for the use cases that need to enable
nfs_export?

Thanks,
Amir.
