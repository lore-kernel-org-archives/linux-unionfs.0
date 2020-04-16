Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32185C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 07:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F52020771
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 07:10:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bonf9lxW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437819AbgDPHKt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437404AbgDPHKr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 03:10:47 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3448EC061A10
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 00:10:47 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t8so5961622ilj.3
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 00:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YOBifo5u7kcaRPmGEkqWCdmf5tJ1NPLP2cpCgmmqStM=;
        b=bonf9lxWYBWSVIf/90VBc0lEN3U76EVlCO2sHPUy4j0AoJxj5Ok77De+IH+DZPV4fx
         OZvVnZmWU7OdiCWOpbbP/FECyi65EoYJsupLI7ba6txW/S5/qmSLbBXM5pl6DQxiRZqj
         +cIwJhnGijKbtgJlFykHM8BQmgml1cukqT8Vez7u090x4wjZAJCza6F/5HVcKk8A0SI+
         CdabgH6H4DlDmPwGQQyUNG98aieeQPpJlsa9H4S3yfNosVTZtu3XNbxdUbYN4n81N33U
         Jsim0+qPulNFGsnTAMdFc3ICwKygNAWIb05riDM/zBi7BioVnI4D8ogYpYBjEDg7KLL6
         uHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YOBifo5u7kcaRPmGEkqWCdmf5tJ1NPLP2cpCgmmqStM=;
        b=OD9j9dQGUSU4PdUU8CceLYEN7cTgQmjBQa+MV38Cft0NEsVtYV16HThAp41wcBIgi7
         ZXAuA1XTTvZX4zdYELnKIjgHa8OWuVRtl08aMftHIuZwlRLY3RVt+6BBHJhUkJq2JLvr
         QF2z1k/q9rnUpfJEuZ5LORAVeJAmVvZliyRUgN6taqoKQfz3IusXubsxKplY2TTTjxp7
         PETKxR2XKcHvG9P91Qsh8HuccxiLmTdl0OUvWSumnjm4ZrwHYafQPcCO3MEjg5IKaTza
         yUX4SK2s/8Y5kuvSMPjOOtaWd/j/fUQMUUraIQOTcJJwWffb9hlfS5K+HcO18V/pIEY6
         ZGFw==
X-Gm-Message-State: AGi0PuZmQiTXFoWLfi7VFP/t6+/1XxBtMkwycJt9fvaNVxNHbd2MZUII
        FEAU8y8Ps1TgO2w1YXv8zqx+vC51YpITP0ulQUI=
X-Google-Smtp-Source: APiQypK21HFUzLMVcrT2NIu7ZWzqZm6afWb1UONuQGA0OLT3+/6b9NsvZ6SJ7+w2zbFym/ooNPlXmDhrQGxmHRUb5WU=
X-Received: by 2002:a05:6e02:68a:: with SMTP id o10mr9578188ils.72.1587021046596;
 Thu, 16 Apr 2020 00:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200415120134.28154-1-amir73il@gmail.com> <20200415120134.28154-3-amir73il@gmail.com>
 <20200415153032.GC239514@redhat.com> <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com>
In-Reply-To: <20200415194243.GE239514@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Apr 2020 10:10:35 +0300
Message-ID: <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 15, 2020 at 10:42 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Apr 15, 2020 at 07:27:43PM +0300, Amir Goldstein wrote:
> > On Wed, Apr 15, 2020 at 6:30 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Wed, Apr 15, 2020 at 03:01:34PM +0300, Amir Goldstein wrote:
> > > > The following environment variables are supported:
> > > >
> > > >  UNIONMOUNT_BASEDIR  - base dir for --samefs (default: /base)
> > > >  UNIONMOUNT_UPPERDIR - upper layer root path (default: /upper)
> > > >  UNIONMOUNT_LOWERDIR - lower layer root path (default: /lower)
> > > >  UNIONMOUNT_MNTPOINT - mount point for tests (default: /mnt)
> > > >
> > > > User provided paths for base/lower/upper should point at a pre-mounted
> > > > filesystem, whereas tmpfs instances will be created on default paths.
> > > >
> > > > This is going to be used for running unionmount tests from xfstests.
> > >
> > > Hi Amir,
> > >
> > > I don't understand this testsuite code. So I will ask.
> > >
> > > What's base dir?
> >
> > Before these changes, with option --samefs, tmpfs is mounted
> > at /base, overlay lowerdir is /base/lower and upperdir is /base/upper.
> > After these changes, /base can be substituted with any pre mounted
> > filesystem path.
>
> If I can specify lower and upper root, then why do I need to specify
> base directory. User can put lower, upper either on samefs or different
> fs as need be.
>
> IOW, either I need to specify base dir, so that lower and upper can
> be setup by testsuite automatically. Or I need to specify lower and
> upper and then base should not matter.
>
> What am I missing.
>

Not much, as it stands, with option --samefs, UNIONMOUNT_BASEDIR
is used and without --samefs UNIONMOUNT_LOWERDIR and
UNIONMOUNT_UPPERDIR used instead.

I agree that this a bit lame and non intuitive way to configure.
The reason for explicit --samefs option (vs. providing upper and lower
root from same fs) is, again, for the test sanity checks which differ
for is_samefs() case.

I think what I will do is I will get rid of UNIONMOUNT_UPPERDIR
because this name is a bit confusing. It is not the overlay upperdir,
it is the grandfather of upperdir/workdir. So I might as well call
this config UNIONMOUNT_BASEDIR and use it also as the parent
of lowerdir in --samefs tests.

The config UNIONMOUNT_LOWERDIR will remain, but it will only
be relevant to tests without --samefs.

IOW, you won't need the fstab bind mount trick and you won't need
to use the magic suffix "lower_layer" anymore. You could set:
  UNIONMOUNT_BASEDIR=/mnt/virtiofs

to run --ov --samefs --verify tests.

If you want to run test with virtio fs as upper (single or multi layers)
and lower as another fs, you could additionally set:
  UNIONMOUNT_LOWERDIR=/mnt/anotherfs

and run --ov --verify tests.

Thanks for the feedback!
Amir.
