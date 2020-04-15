Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E77CC3815B
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 16:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A439206F9
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 16:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPUiLgy4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415952AbgDOQ15 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 12:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1415949AbgDOQ1z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 12:27:55 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0948C061A0C
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 09:27:54 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c17so3890160ilk.6
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 09:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ISCYgE2lggAuUBAqmeFo1AEB9fGv8qsrtGu8Yi6ZiCk=;
        b=BPUiLgy4SyhWRxlIkODHVH21YGTWngt/pTcOMOTRd3dHK67UFM8Z8+tLwk1jzs0cQV
         IXtbNQz8NPx7flsMniizXVHQrrcXMMoZMf7Gcfv3/hXJAEGkBbpcncpqeEdPw4JjdHSj
         S5drxAeHz9p3IZFhzcWkLegV5B7x77XKEc3c96nPf3ZQmpF8kVXfjFvfTCXgbeDR8eMC
         RpA1RFO5/DTNYk5NiTw2sn72SgpxfAzkwXa93i7FdSKaY5exF19Wosozp+lsc2K7mdMm
         N6ls8WsW2WRciq403TtGGQDw6mzCbD+EwGfQ+m/fOo5u+MhUl5JT0hxP2ueDBxaNsSqH
         Mdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ISCYgE2lggAuUBAqmeFo1AEB9fGv8qsrtGu8Yi6ZiCk=;
        b=AdqoHz6agcfbvjikitXcGwXj1+MC2aJDtg5eaYeYMs9GACJYQ/31tErO1gNBZDQt3b
         TFdbGqm+tCnAKqwLnxQsl2CSn2j8F9RnkrP4aN404rBSCLr1QIcA43HW8S9sNaMzHKmT
         gOcpQlot+k3Nfl60vvwqjuhCV/PYbLAP4ienfdwdacd3d6ldFh/ZHgHM3ZypnrSg+mYq
         ND6vWkzo/2ewkPYR+izPo1sU4xALU43BxjOegDxMfTCpoY/OcbPEYYhqkM6H8qvM5k4D
         BrCuzmOtKrg1oeAiTkBDk8i/9XDjB1ol0AF0l2npdF1BxcBM/k3CYF7LWJ/19h6p1HcY
         xM8A==
X-Gm-Message-State: AGi0PubQA0cnfxST4aLoq7BPDz9QBCGQF1cv1WkjsZrR4vT1SXvFSP0m
        CMtMfZSvHMhLc+SSF/0aOQ9ss7MbiqxqA8tnoNqKlzzl
X-Google-Smtp-Source: APiQypKLqiSLTfg/gXwyTO4j49ce1ah2gmdQNRyezM+OXcDBHtBDkMajnee+6fUIn4v2JJS+jK0OlDHGcPPJJX+tSlo=
X-Received: by 2002:a92:7e86:: with SMTP id q6mr2033330ill.9.1586968074241;
 Wed, 15 Apr 2020 09:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200415120134.28154-1-amir73il@gmail.com> <20200415120134.28154-3-amir73il@gmail.com>
 <20200415153032.GC239514@redhat.com>
In-Reply-To: <20200415153032.GC239514@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 15 Apr 2020 19:27:43 +0300
Message-ID: <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
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

On Wed, Apr 15, 2020 at 6:30 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Apr 15, 2020 at 03:01:34PM +0300, Amir Goldstein wrote:
> > The following environment variables are supported:
> >
> >  UNIONMOUNT_BASEDIR  - base dir for --samefs (default: /base)
> >  UNIONMOUNT_UPPERDIR - upper layer root path (default: /upper)
> >  UNIONMOUNT_LOWERDIR - lower layer root path (default: /lower)
> >  UNIONMOUNT_MNTPOINT - mount point for tests (default: /mnt)
> >
> > User provided paths for base/lower/upper should point at a pre-mounted
> > filesystem, whereas tmpfs instances will be created on default paths.
> >
> > This is going to be used for running unionmount tests from xfstests.
>
> Hi Amir,
>
> I don't understand this testsuite code. So I will ask.
>
> What's base dir?

Before these changes, with option --samefs, tmpfs is mounted
at /base, overlay lowerdir is /base/lower and upperdir is /base/upper.
After these changes, /base can be substituted with any pre mounted
filesystem path.

>
> So these options will allow me to specify lower directory, upper directory

Almost.

They let you specify lower fs root and upper fs root.
Before these changes, tmpfs is mounted at /lower and this is used
as overlay lowerdir.
After these changes, /lower can be substituted with any pre mounted
filesystem path.

Situation for upperdir/workdir is a bit different (see below).

> and overlay mount point. User can specify these and testsuite will
> mount overlay accordingly?
>
> What about overlay mount options. Should there be one option for that too.

Maybe. Currently the overlay mount options are determined by the various
command line arguments, like --xino --meta --verify.
The reason that testsuite does not let you use any combination of mount
options is because the options (e.g. --meta) determine both how overlay is
mounted and also how verification is done (see for example the is_metacopy
case in check_copy_up()).

Do you have any requirement for specific overlay mount options you
would like to test?

>
> Assuming workdir is automatically determined.
>

Yes. Before these changes, tmpfs is mounted at /upper.
The directories /upper/0/u /upper/0/w are used as upperdir/workdir with
single layer.
With multiple layers (e.g. ov=2) more directories can be created, like
/upper/1/{u,w}.
After these changes, tmpfs /upper can be substituted with any pre
mounted filesystem path.

Hope this is clear now.
See example is how xfstests make use of those variable to use
the test and scratch partitions for lower and upper fs:
https://github.com/amir73il/xfstests/commit/a36f476a04c5af5100141c3ff9938d0c2f93018d#diff-7892ac2dd3f989038dfaa2e708ab12e2R386

Thanks,
Amir.
