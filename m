Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2DBC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Jan 2021 13:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979A822B37
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Jan 2021 13:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbhAYNTN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 08:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbhAYNSV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Jan 2021 08:18:21 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A936FC0613D6;
        Mon, 25 Jan 2021 05:17:33 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id h11so26267774ioh.11;
        Mon, 25 Jan 2021 05:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Te8hcmHBuaN7ZbAcxRO0Lcgi/Ips+3kxncyarZEndFs=;
        b=IqNHfZbC4G44w0vEWP2dqXv6Yc0rbE/ySWKfjPopiR/2yPK0qL4ElfPKGl8x2+PPr+
         FQw5HNIrOu+E/pLj72owRbSAjX+vIuo+BAin6Dzejc722BdgV6f+RWJHpf7UtitGIWXY
         Y/v96bnAHweNhOENgbhaGTJT6Bc/lS88tACzvlv3Od40dsYBkIzcELH6fYAI0wZse7kJ
         ymMr1GIAUcKQhdNVh4w8q+xlbCLL6DKcCgTz/PsY3OjK+BwBejQd1D6LF0wvSov3CygT
         ld3LtuKYyBFVEImiN7KSQC6TqYhLGGTk5eET0fR17xRIPZAnI6MuscFVFz9u9GmHH2MX
         Wu4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Te8hcmHBuaN7ZbAcxRO0Lcgi/Ips+3kxncyarZEndFs=;
        b=nyauNzo0+/06f7O1tM5/ZnQgTkbXhCn42MH0MNPeOp6lmzw10FxLA1bRSK6CwiICdi
         j/lwoccgU39rrDWCRjhATnUp9FqSHkjZ+mTwGWw+W2e8x9fRcSMRo6Oriz4c2mNan/zz
         rhArWe5MFUpI6GtXf59IaTiHtfqKnxWqJXAT9ZWvYKE+V038of6k/pCoFDP08/vaHxTc
         nKM4YQ3HMZNnvPkzuBhQIYsoXAnRnijykn342f9F9XWcMROYAd6PcGAEEmXXVLbj/etn
         BvTAxg9ZQEwpjsa0dk+B93MODmUxr2Ap4LDIRcB4YTgucsw0xk+op3ULrd5oGSzIqRuL
         CJPw==
X-Gm-Message-State: AOAM532NY9xFbi2/AXcss/MAsATx3YHUaw4RQMX3Zej8S3pU78LdxOpu
        RXJlWC6r2NH0OTHQEEj5yZei2wJtjF+jEN3X3qI45PU2I94=
X-Google-Smtp-Source: ABdhPJzjmauC/RmydA48mzXwi9jBiCZbg9/HWjjYNhXUXQqBL9Jm0JpNq6akNJqtCuySCELz+OpdFEzp5ansr+XVO2A=
X-Received: by 2002:a6b:6f08:: with SMTP id k8mr347134ioc.186.1611580653045;
 Mon, 25 Jan 2021 05:17:33 -0800 (PST)
MIME-Version: 1.0
References: <20210116165619.494265-1-amir73il@gmail.com> <20210116165619.494265-4-amir73il@gmail.com>
 <20210124151411.GC2350@desktop> <CAOQ4uxj8xx7izTV8Sp3FH_Pgv_S0gvCKZtCmfRnDGfo318d86Q@mail.gmail.com>
 <20210125124629.GF58500@e18g06458.et15sqa>
In-Reply-To: <20210125124629.GF58500@e18g06458.et15sqa>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 25 Jan 2021 15:17:22 +0200
Message-ID: <CAOQ4uxgkdtd-Bh-y2urrXSQ6OVYe=ZgiUiELQwYsMPuroPiU8g@mail.gmail.com>
Subject: Re: [PATCH 3/4] src/t_immutable: Allow setting flags on existing files
To:     Eryu Guan <eguan@linux.alibaba.com>
Cc:     Eryu Guan <guan@eryu.me>, Eryu Guan <guaneryu@gmail.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jan 25, 2021 at 2:46 PM Eryu Guan <eguan@linux.alibaba.com> wrote:
>
> On Sun, Jan 24, 2021 at 05:32:15PM +0200, Amir Goldstein wrote:
> > On Sun, Jan 24, 2021 at 5:14 PM Eryu Guan <guan@eryu.me> wrote:
> > >
> [snap]
> > > >
> > > >       if (create) {
> > > >         ret = create_test_area(argv[argc-1]);
> > > > -       if (ret || !runtest) {
> > > > +       if (ret || allow_existing) {
> > >
> > > With this change, compiler warns about 'runtest' is set but not used,
> > > and 'allow_existing' now indicates '!runtest' implicitly, which seems
> > > subtle. I think it's better to keep 'runtest' as the indicator to
> > > actually run the test?
> > >
> >
> > Sure, I removed it by mistake.
>
> Then this is the only place that needs update. I can fix it on commit,
> no need to resend then.
>

Excellent.

Now, about that kernel deadlock mentioned in is commented out line in
test overlay/075. The fix for that is in overlayfs-next:

147ec02b8705 - ovl: avoid deadlock on directory ioctl

But I am not so happy about adding a test that crashes stable/old kernels.
If you like I can post another test that is "dangerous" just for the deadlock
but after the fix is merged to master and 5.10.y so at least people who tests
the latest kernels will not crash.

Let me know your preference.

Thanks,
Amir.
