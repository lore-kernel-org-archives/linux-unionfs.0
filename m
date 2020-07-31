Return-Path: <SRS0=/0gG=BK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449F4C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 14:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16EBF206DA
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 14:09:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kY9+dUSb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbgGaOJ3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 10:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730802AbgGaOJ3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jul 2020 10:09:29 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9BDC061574
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jul 2020 07:09:29 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z6so31818268iow.6
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jul 2020 07:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1T1iZGWWQ5cihTnF8yrV8kkGUg0qdNEwUOab0crO87U=;
        b=kY9+dUSbH7vvrnfvXxDeCFsid50+Gm5/0/n8+ryHGaGKOPF6nQOVGlBzmm5ga6ANgZ
         K+PF4ASS5W4d83kb7ia+l/T4tp5bGpWvlMgh8n9nskqkFMcLZEOe8wTnYo/MQ4mWDiL9
         GP+zee7uuhpkSlfITCO78ma8Lmrna5YIi/rDGyQ0JZ1h4e3on2+3kX0lxSDa0dYU2FrH
         sXhnSPxn1hXng2fOlGwdODAdtYiwW8feWZSCBpYBRst9JKG6Z9motNdRRqQ0fzI+puV9
         QF5K+qkQTcMTx99Txa0UhTtDlpHfXGA2IMp8h5WT8hKrF3w4MHRzOml26dKGtLlfGC9U
         otnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1T1iZGWWQ5cihTnF8yrV8kkGUg0qdNEwUOab0crO87U=;
        b=sSQ0LWXOtMHZpgvIt8NS+0B+5eOWzTTi8yOkUjq8Kdc2/M08HzegX/EQ8AG/BFw/6X
         EtDZ/NHssvgMiGNbDqRi7n88mZv2FRjD1T+2gE3C4c6sviwIM+gZFFbrZ9x74Llqwlaa
         Q739Oss+V0BPANlfxz0HSVzunQjLux6tZ9dCEKrdCS0vLu+LAevncfBscdknEa5JuWmA
         lp37Zi19mXEo+AQR6Mf77eNyMJ6WYqDWYAs6ajkf6xaULaIpvuwPB98u5lJW0w0KosbZ
         HxzMZwd+aD//gttpf2RO0VQsjtPFCKmkMGA/JPLoIRkAw3isL/mAfRaxqWIvQtVSHUll
         W1+g==
X-Gm-Message-State: AOAM530TIhTpFGL4Li83UYP007b78aL0a3WAJLwuRK3O6nFO/thgGsCH
        4V5CjRFDr55oP4oCU07OtburNp/F6GFD51whmy7XN5cH
X-Google-Smtp-Source: ABdhPJwK3G1lLJbiYfSYKvSHAEFPtyIWPQoQs++RcW5VMC7ZTs2u1FCKdCK/agwkWEfSn3LY/R//FnvdS2GBGLETVRk=
X-Received: by 2002:a02:7b1f:: with SMTP id q31mr5177104jac.81.1596204568665;
 Fri, 31 Jul 2020 07:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxhi63LPKdmkEJjnTEgy0VaX0qXML2Uz_258_B2iZcqd3w@mail.gmail.com>
 <20190709141302.GA19084@redhat.com> <CAOQ4uxjWc8WFRFS8GTpz8uE1AHrs6yGx2A3fZy-Sxfu7CCyKuw@mail.gmail.com>
 <20200731131244.GA189839@redhat.com>
In-Reply-To: <20200731131244.GA189839@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 31 Jul 2020 17:09:16 +0300
Message-ID: <CAOQ4uxivJgHTf-K=AjTcWPbOWNhxY8NGAt=t1XVqwOY-h5J+rg@mail.gmail.com>
Subject: Re: [RFC] Passing extra mount options to unionmount tests
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 31, 2020 at 4:13 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Jul 31, 2020 at 03:35:40PM +0300, Amir Goldstein wrote:
> > > >
> > > > If anyone is running unionmount-testsuite on regular basis
> > > > I would be happy to know which configurations are being tested,
> > > > because the test matrix grew considerably since I took over the project -
> > > > both Overlayfs config options and the testsuite config options.
> > >
> > > For me, I think I am most interested in configuration used by
> > > container runtimes (docker/podman). Docker seems to turn off
> > > redirects as of now. podman is turning on metacopy (hence redirect)
> > > by default now to see how do things go.
> > >
> > > So for me (redirect=on/off and metacopy=on/off) are important
> > > configurations as of now. Having said that, I think I should talk
> > > to container folks and encourage them to use "index" and "xino"
> > > as well to be more posix like fs.
> > >
> >
> > Hi Vivek,
> >
> > I remember you asked me about configuring extra mount options
> > for unionmount but couldn't find that conversation, so replying to this
> > related old discussion with my thoughts on the subject.
> >
> > Now that unionmount supports the environment variables:
> > UNIONMOUNT_{BASEDIR,LOWERDIR,MNTPOINT}
> >
> > And now that xfstests has helpers to convert xfstests env vars to
> > UNIONMOUNT_* env vars, one might ask: why won't we support
> > UNIONMOUNT_OPTIONS=$OVERLAY_MOUNT_OPTIONS
> >
> > So when you asked me a question along those lines, my answer was that
> > unionmount performs different validations depending on the test options,
> > so for example, the test option ./run --meta adds the mount option
> > "metacopy=on", but it also performs different validation tests, such as
> > upper file st_blocks == 0 after metadata change.
> >
> > Right, so I gave a reason for why supporting extra mount options is not
> > straight forward, but that doesn't mean that it is not possible.
> > unionmount test could very well parse the extra mount options passed
> > in env var and translate them to test config options.
>
> Hi Amir,
>
> I am not able to understand this point. Why an extra mount option
> needs to be translated into a "test config" option. If I pass
> "metacopy=on", that does not mean that I also want to run tests
> which verify st_blocks == 0 on upper. It just means that whatever
> tests I am running, are run with metacopy=on. All I want to make
> sure that tests I am running are not broken if run with metacopy=on.
>

I guess the confusion is what defines a "test".

A specific xfstests test script (e.g. overlay/060) defines:
- requirements (run or skip)
- setup and operations to execute
- expectations

So when you pass extra mount options it might:
- cause test not to meet requirements and be skipped
- affect the setup/operations
- usually it does not change the expectations

But you can also define some global options like
USE_KMEMLEAK, TEST_XFS_REPAIR_REBUILD, TEST_XFS_SCRUB
which affect the validations that are run after each test
in *addition* to the specific expectations encoded in the test script.

A specific unionmount test (e.g. tests/rename-pop-dir.py) defines only:
- operations to execute
- expected return value

But the test engine performs extra validations after *each* operation
in addition to verifying the expected return value.

So when I write "verify st_blocks == 0 on upper", this is not an expectation
that is explicitly written in any specific test.
The test engine records the state of objects before and after each filesystem
operation is executed to know for each object if it is expected to be lower,
metacopy,upper and then it runs some validations after each operation
(like upper st_blocks) to verify that the actual state of the object matches the
expected state.

The test run option --xdev only is similar to the xfstests requirement
and it skips a few dir rename tests and changes expected return
value in others.

But the test run options --verify, --meta, --xino, --verify, are global test
options which determine what sort of validations are performed after
each and every operation in all the operations of all of the test cases.

Those checks are implemented in context.py functions:
check_dev_ino(), check_copy_up(), check_layer()

Is my explanation more clear now?
It is clear why unionmount needs to parse mount options in order
to set the expectations from validators?

If that is clear, please review my proposal to see if I missed anything.

Thanks,
Amir.
