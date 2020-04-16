Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76F4C2BB55
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 13:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B412A217D8
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 13:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R54H6mtG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730790AbgDPNuH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 09:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2441310AbgDPNt7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 09:49:59 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0836C061A0F
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 06:49:40 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 19so5198741ioz.10
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 06:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tYMZBvlzJhlq97mKpzxSM2Dt09vZh9dEpXio3jIs83k=;
        b=R54H6mtGdrgfsEB/9LZakf9PCSgjvdSbSkw+CXjyoRmMbWHPbcCQZpgUle1twA8SUo
         PL/GO/BdnXUGKJiLZKYBIWYi+uLGOLDZJXMQ2YPcpRHhkvHj7cF9QHqwsw5haiqUhb7F
         FOJw5Dlgg0KVVN5rGW9J7E2DgGD6j70QAyTTGkS+OYjUWQtpcHeC0J7gwICJ6hg5cke2
         HhoYYPktGJh2DNIfVxpyx4F2+iGU6JLATP0bXMIDYsUq8mcoNVzlvl4u5OHh+mCwIWX1
         eQszJLUI8Oi52fUg5C1OdJoTdytWAOKk1kUCE0evOCAtNhZtR3AGb6hSAJJFpfkF9f93
         TLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tYMZBvlzJhlq97mKpzxSM2Dt09vZh9dEpXio3jIs83k=;
        b=TwUlVFjPbtMacuwaKS7MFlcEakhZ8nbng4CRLN4Lot1/jYRzOWXMuXEIUlly7w42Va
         zhXdtXRw/tYn+o7qW01eVkBghMNCuyTEg86anOBqHJ2aTjNyvjzrJYyG2z/b7/YQaQe9
         xgVIQ7TUyQdCPH1vaPuuA2Ae0BK08j22js78hcVns+p8LMGKbhqktA1AkNJzh3Cz0BYD
         8h3W6WsvldL87Qn6dPOEfqtFKrBMYba46yqGJzgWTxvogx4iHMAmtdoPy5yagGNTBOkq
         Hb13AW/CY/t2PYoAeOSXh5oUTI78o4WeE6GmNIPTVtjdJQCRQNXmFenMNsEX5Kltj4lu
         zNGg==
X-Gm-Message-State: AGi0PuZxZXvMwH7pAtU2vcNu8hkuK1uRxO1WLS1SuAHLqQSiTPhzk7TH
        KLO6VrJ8olSolHf8HvUvOY819o2f68TPHB1HYkXUhOGW
X-Google-Smtp-Source: APiQypIMNg+gJyxuCBcshdocJW5RA+hncYSQ8vBpJnIOO2xqN4Pne0h5BvHZhcIgEnoI3rELr6iTIp0zaZSfnKz2ANk=
X-Received: by 2002:a6b:cd4a:: with SMTP id d71mr30987190iog.5.1587044980297;
 Thu, 16 Apr 2020 06:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200415120134.28154-1-amir73il@gmail.com> <20200415120134.28154-3-amir73il@gmail.com>
 <20200415153032.GC239514@redhat.com> <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com> <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
 <20200416125807.GB276932@redhat.com>
In-Reply-To: <20200416125807.GB276932@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Apr 2020 16:49:29 +0300
Message-ID: <CAOQ4uxi=mT2JYGSXro5YW8gTE5256cxauBddYe2HXM=ZfZ=+ZA@mail.gmail.com>
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

> > > IOW, either I need to specify base dir, so that lower and upper can
> > > be setup by testsuite automatically. Or I need to specify lower and
> > > upper and then base should not matter.
> > >
> > > What am I missing.
> > >
> >
> > Not much, as it stands, with option --samefs, UNIONMOUNT_BASEDIR
> > is used and without --samefs UNIONMOUNT_LOWERDIR and
> > UNIONMOUNT_UPPERDIR used instead.
> >
> > I agree that this a bit lame and non intuitive way to configure.
> > The reason for explicit --samefs option (vs. providing upper and lower
> > root from same fs) is, again, for the test sanity checks which differ
> > for is_samefs() case.
> >
> > I think what I will do is I will get rid of UNIONMOUNT_UPPERDIR
> > because this name is a bit confusing. It is not the overlay upperdir,
> > it is the grandfather of upperdir/workdir. So I might as well call
> > this config UNIONMOUNT_BASEDIR and use it also as the parent
> > of lowerdir in --samefs tests.
>
> How about calling upper/work root as UNIONMOUNT_UPPER_WORK_ROOT instead.
> That's more intuitive as oppsed to BASEDIR. But I understand that due
> to legacy reasons there must be many other assumptions in the code so
> it might not be trivial.
>

This naming might have made sense with existing meaning of
UNIONMOUNT_UPPERDIR, but the new idea is to throw that a way and have
UNIONMOUNT_BASEDIR as the base dir for lower/upper/work.
This is similar to OVL_BASE_TEST_DIR and OVL_BASE_SCRATCH_MNT
vars in xfstests.

> What will help though, that document these options well, so that
> those who don't read the code and still understand use different
> config options.
>

Sure, I added those to README, will try to elaborate.

> >
> > The config UNIONMOUNT_LOWERDIR will remain, but it will only
> > be relevant to tests without --samefs.
> >
> > IOW, you won't need the fstab bind mount trick and you won't need
> > to use the magic suffix "lower_layer" anymore. You could set:
> >   UNIONMOUNT_BASEDIR=/mnt/virtiofs
> >
> > to run --ov --samefs --verify tests.
>
> If I specify UNIONMOUNT_BASEDIR, then --samefs should be implied?
>

This might have made sense with the meaning of UNIONMOUNT_BASEDIR
as it is in current posting, but with intended change, I suppose an empty
UNIONMOUNT_LOWERDIR could mean --samefs.
When both --samefs and UNIONMOUNT_LOWERDIR are specified, I'll
throw a warning that UNIONMOUNT_LOWERDIR is ignored.

Thanks,
Amir.
