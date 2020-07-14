Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FDEC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83111222B7
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:05:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oi4yAFMk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgGNOFq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgGNOFp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 10:05:45 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9CFC061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:05:45 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so17378166iof.12
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zCoazQPEzyDpDrKhrsXayOiKdosZzfmlPXMHSXbiSU4=;
        b=Oi4yAFMkkZh/+ASFU0tgediMoy6DDmxhyn3CaBBy8kmlz58s+Drihza+EaLr5jjmER
         dyMv4V0f5oPWxG+73Y+CdQ8QfU7pp+XdOHMRg1IJx0iAAS89zNtX6Oh62GwG98Kiuj7m
         9O1R9let/q+SIO2VGlgSmYl/9o3mYDUeoZDx8UjkPBRPSM2n4YlKLEyp//q+rMSJsgcG
         3Hl5YYIfgUb5gj3JHeKI2xXbX7WTk2XAU1wTSzzsyB/iVM43lFT7LyhyREN42fOdzrbf
         BE3ZgNTF1z4WnTo0LFdnNMEW+Ngb3NTjJvg2Qf7o7dWBEeJDch5HYgYuu3cAnOKO0oPf
         5MIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zCoazQPEzyDpDrKhrsXayOiKdosZzfmlPXMHSXbiSU4=;
        b=cU2vmQCHX713oeeW3ZHoiDJSMdL5GqP7rZjrJpFXf8NvIealogC1sIJGirpw0vcja0
         YoeRRo3GVZRud/Hh3YOiKaxRaJPaFNjpmlN3Sz1erJJOzdnOASUYKGoxJjLTue5C/WKk
         PLoc77glh6euAUSnucPHmFROu/tG1MJVerBIQuvFYjq4azFOYbjyfPW39GgN/vDwSXJW
         g0aODYw8IQM1dsH0ZQNBirRGJSlAU9V9ibeVZNVA2y4MJtpFETYOLwDM1lH5YHb8APPC
         eg0pGA3Pl/htTs68RQPuGGVEAobqU87gL4HWgxgShXq8WrW0f41b3+fjk04FRT4YADlm
         h4Ig==
X-Gm-Message-State: AOAM531+JqvCJi0AaLzWEGGQQLA9BQArhvCNbwM3U/CO2lCYARYHcpx/
        8hXVjqcZclLnJ0dgZnTsAuFjghtG4g8exMDfwTo=
X-Google-Smtp-Source: ABdhPJx/TJxocCL5oAss2lXtxDeIipEUroFKXymxB65ofDLemrddZbSIX7jaB9NReOnZMlc1UWeH2KL7oK0qHCoh1z0=
X-Received: by 2002:a6b:f012:: with SMTP id w18mr99112ioc.5.1594735544949;
 Tue, 14 Jul 2020 07:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200713105732.2886-1-amir73il@gmail.com> <20200713105732.2886-2-amir73il@gmail.com>
 <20200713192517.GA286591@redhat.com> <CAOQ4uxiXWH2RtXdLXRJY-pcZt=zFK-urhcTSQYNbPpmMjFCJdw@mail.gmail.com>
 <20200714134135.GC324688@redhat.com>
In-Reply-To: <20200714134135.GC324688@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 17:05:33 +0300
Message-ID: <CAOQ4uxgGV4v+8_ziFZ0_qd9J8e=a8mzyHWcxDSE5quQ3+Wh41A@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] ovl: invalidate dentry with deleted real dir
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 4:41 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jul 14, 2020 at 06:28:41AM +0300, Amir Goldstein wrote:
> > On Mon, Jul 13, 2020 at 10:25 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Mon, Jul 13, 2020 at 01:57:31PM +0300, Amir Goldstein wrote:
> > > > Changes to underlying layers while overlay in mounted result in
> > > > undefined behavior.  Therefore, we can change the behavior to
> > > > invalidate the overlay dentry on dcache lookup if one of the
> > > > underlying dentries was deleted since the dentry was composed.
> > > >
> > > > Negative underlying dentries are not expected in overlay upper and
> > > > lower dentries.  If they are found it is probably dcache lookup racing
> > > > with an overlay unlink, before d_drop() was called on the overlay dentry.
> > > > IS_DEADDIR directories may be caused by underlying rmdir, so invalidate
> > > > overlay dentry on dcache lookup if we find those.
> > >
> > > Can you elaborate a bit more on this race. Doesn't inode_lock_nested(dir)
> > > protect against that. I see that both vfs_rmdir() and vfs_unlink()
> > > happen with parent directory inode mutex held exclusively. And IIUC,
> > > that should mean no further lookup()/->revalidate() must be in progress
> > > on that dentry? I might very well be wrong, hence asking for more
> > > details.
> > >
> >
> > lookup_fast() looks in dcache without dir inode lock.
> > d_revalidate() is called to check if the found cached dentry is valid.
>
> Got it.
>
> >
> > For example, ovl_remove_upper() can make an upper dentry negative
> > or upper dir inode S_DEAD (i.e. vfs_rmdir) just before calling d_drop()
> > to prevent overlay dentry from being found in fast cache lookup.
> >
> > Unless I am missing something, that leaves a small window where
> > lookup_fast() can return an overlay dentry with negative/S_DEAD
> > upper dentry, which was not caused by illegitimate underlying fs
> > changes, so we must gracefully invalidate the dcache lookup
> > (return 0 from revalidate) in order to fallback to fs lookup.
>
> So what's the side affect of this? I mean one even you make this change,
> it is possible that on a cpu parallel unlink is going on and right
> after d_revalidate() finishes, upper is marked negative (or directory
> S_DEAD).

No parallelism required.
The side effect is to reduce the attack/fuzzing vector for creating
bad things by deleting/renaming lower dentries.

>
> So this change will not plug the hole. It will just narrow it a bit?

Yes, but it has nothing to do with races it has only to do with
use cases (see blow).

>
> /me is failing to see complete picture that what's the problem at
> macro level and how this patch fixes it.
>

Today, if a user deletes/renames underlying lower that leaves
the overlayfs dentry in a vulnerable state.
I do not have a reproducer to OOPS the kernel with that, but
syzbot has created some crashes of similar nature in the past.

The fact is that all we can say about this scenario is:
"If the underlying filesystem is changed, the behavior of the overlay
 is undefined, though it will not result in a crash or deadlock."
and that second part cannot be proven to be true.

With the set of these two patches, a whole class of attacks is
pruned, because every attack that needs to get the vulnerable
denry via lookup will not get it. Attacks that use a fd to access
a vulnerable dentry may still work.

The confusing part about racing with ovl_unlink()/ovl_rmdir()
is not really important. It explains that an overlay dentry in the
middle of ovl_rmdir() (after vfs_rmdir() and before d_drop()) can
be found by parallel dcache lookup and "appear" like an underlying
change (upper was removed under the overlay).

I only mentioned that because we must not return -ESTALE in
that case, but if we remove the -ESTALE conversion, nothing bad will
happen. dcache lookup will get 0 from ovl_revalidate on that dentry
and re-do the lookup, which is exactly what would have happened
if lookup took place a few ms later after ovl_rmdir() called d_drop().

Thanks,
Amir.
