Return-Path: <SRS0=/0gG=BK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8681C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 20:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8ECB21744
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 20:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lOp83j2K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgGaUCr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgGaUCr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jul 2020 16:02:47 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0053CC061574
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jul 2020 13:02:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id j8so20478575ioe.9
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jul 2020 13:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x568hr/rE4QsoiHrGGryqTVDJW3tcAo6mlsDZL/yL8w=;
        b=lOp83j2KCUjMpvXlUKR3Dwv4ZgpJ7Ehca+javhmcfZBgory3d181QhWxpN4bRDt/uw
         /n8R2hEOEO4k4+LyjekuvMgLthIB/8T8/aIubrP6wWPD2quylP6+FPGMqYZXQhxUQKyJ
         iRTO1X3bejKbrNJ6FOBcaGbA7wcTacQmKMQCv/aCWlYJ7H5Uwm3DYKgEXqktL8Au25J6
         2aRnFSrNhdcHk6MyxFaLvAKn1WGnb7nG8S7o3dHzNJuJOFgb0nJPqKOFduevJUBGjY1a
         MKoUsDEwzXytgRVzfiWcfDCdOa7ngx2mnyunh+9M9INiqojY15PWSjk5IfsC7KSE5RAk
         6s2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x568hr/rE4QsoiHrGGryqTVDJW3tcAo6mlsDZL/yL8w=;
        b=N4dQRgMHBoidHynbrgPobH8ZQ2KHM+t2498CZWkdG895Ugte0lO4Qv2two7hl48iz9
         QYx/eZIwU0sUexCTFTe7g5nchcbi0VfZVYonq052DMl18B+5FW/FUBYtryY5Ex52TFYW
         87P4zJBzbttqxUcHw5XvPmp0JahjO0XJ1otXIcrZ63djc6R2ymTvqO1OZHGdVKs05m18
         Xo1XRB0DR6VJhcXEvqdxOfGtjynBfZ7HqJ/E+HTSp1vz6VK8f8dT3Sk+2kAa0qyRInCe
         9Sni2Kg/xtbSS51Mdsi5FkrmHEJgToHKJl4f2P+fiW8hoV2CM+/RxhwciBN7LDOGWzHz
         QZ0w==
X-Gm-Message-State: AOAM5322Qx0+b48YVf7TqAYW95BExjD7y5pDOQQdtnli0POaE958dQZu
        gQjf5kldjiwcOv4jVEgOH9f4dEsfvy/yR4U6Np3Drw==
X-Google-Smtp-Source: ABdhPJwle3BOveuolJVimdpneeDY7Z9trochNcpL6atPBzwDUXvil/klJEyUbj74ZDSEsi7Ebwc1zkZL+nOBqIp8/9w=
X-Received: by 2002:a5e:980f:: with SMTP id s15mr5212361ioj.5.1596225766236;
 Fri, 31 Jul 2020 13:02:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxhi63LPKdmkEJjnTEgy0VaX0qXML2Uz_258_B2iZcqd3w@mail.gmail.com>
 <20190709141302.GA19084@redhat.com> <CAOQ4uxjWc8WFRFS8GTpz8uE1AHrs6yGx2A3fZy-Sxfu7CCyKuw@mail.gmail.com>
 <20200731131244.GA189839@redhat.com> <CAOQ4uxivJgHTf-K=AjTcWPbOWNhxY8NGAt=t1XVqwOY-h5J+rg@mail.gmail.com>
 <20200731182157.GD189839@redhat.com>
In-Reply-To: <20200731182157.GD189839@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 31 Jul 2020 23:02:35 +0300
Message-ID: <CAOQ4uxg2pRHtVqwuGPMaddKa8DvyApc63q-gVA7Djzb3=1K_MQ@mail.gmail.com>
Subject: Re: [RFC] Passing extra mount options to unionmount tests
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 31, 2020 at 9:22 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Jul 31, 2020 at 05:09:16PM +0300, Amir Goldstein wrote:
> > On Fri, Jul 31, 2020 at 4:13 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Fri, Jul 31, 2020 at 03:35:40PM +0300, Amir Goldstein wrote:
> > > > > >
> > > > > > If anyone is running unionmount-testsuite on regular basis
> > > > > > I would be happy to know which configurations are being tested,
> > > > > > because the test matrix grew considerably since I took over the project -
> > > > > > both Overlayfs config options and the testsuite config options.
> > > > >
> > > > > For me, I think I am most interested in configuration used by
> > > > > container runtimes (docker/podman). Docker seems to turn off
> > > > > redirects as of now. podman is turning on metacopy (hence redirect)
> > > > > by default now to see how do things go.
> > > > >
> > > > > So for me (redirect=on/off and metacopy=on/off) are important
> > > > > configurations as of now. Having said that, I think I should talk
> > > > > to container folks and encourage them to use "index" and "xino"
> > > > > as well to be more posix like fs.
> > > > >
> > > >
> > > > Hi Vivek,
> > > >
> > > > I remember you asked me about configuring extra mount options
> > > > for unionmount but couldn't find that conversation, so replying to this
> > > > related old discussion with my thoughts on the subject.
> > > >
> > > > Now that unionmount supports the environment variables:
> > > > UNIONMOUNT_{BASEDIR,LOWERDIR,MNTPOINT}
> > > >
> > > > And now that xfstests has helpers to convert xfstests env vars to
> > > > UNIONMOUNT_* env vars, one might ask: why won't we support
> > > > UNIONMOUNT_OPTIONS=$OVERLAY_MOUNT_OPTIONS
> > > >
> > > > So when you asked me a question along those lines, my answer was that
> > > > unionmount performs different validations depending on the test options,
> > > > so for example, the test option ./run --meta adds the mount option
> > > > "metacopy=on", but it also performs different validation tests, such as
> > > > upper file st_blocks == 0 after metadata change.
> > > >
> > > > Right, so I gave a reason for why supporting extra mount options is not
> > > > straight forward, but that doesn't mean that it is not possible.
> > > > unionmount test could very well parse the extra mount options passed
> > > > in env var and translate them to test config options.
> > >
> > > Hi Amir,
> > >
> > > I am not able to understand this point. Why an extra mount option
> > > needs to be translated into a "test config" option. If I pass
> > > "metacopy=on", that does not mean that I also want to run tests
> > > which verify st_blocks == 0 on upper. It just means that whatever
> > > tests I am running, are run with metacopy=on. All I want to make
> > > sure that tests I am running are not broken if run with metacopy=on.
> > >
> >
> > I guess the confusion is what defines a "test".
> >
> > A specific xfstests test script (e.g. overlay/060) defines:
> > - requirements (run or skip)
> > - setup and operations to execute
> > - expectations
> >
> > So when you pass extra mount options it might:
> > - cause test not to meet requirements and be skipped
> > - affect the setup/operations
> > - usually it does not change the expectations
> >
> > But you can also define some global options like
> > USE_KMEMLEAK, TEST_XFS_REPAIR_REBUILD, TEST_XFS_SCRUB
> > which affect the validations that are run after each test
> > in *addition* to the specific expectations encoded in the test script.
> >
> > A specific unionmount test (e.g. tests/rename-pop-dir.py) defines only:
> > - operations to execute
> > - expected return value
> >
> > But the test engine performs extra validations after *each* operation
> > in addition to verifying the expected return value.
> >
> > So when I write "verify st_blocks == 0 on upper", this is not an expectation
> > that is explicitly written in any specific test.
> > The test engine records the state of objects before and after each filesystem
> > operation is executed to know for each object if it is expected to be lower,
> > metacopy,upper and then it runs some validations after each operation
> > (like upper st_blocks) to verify that the actual state of the object matches the
> > expected state.
> >
> > The test run option --xdev only is similar to the xfstests requirement
> > and it skips a few dir rename tests and changes expected return
> > value in others.
> >
> > But the test run options --verify, --meta, --xino, --verify, are global test
> > options which determine what sort of validations are performed after
> > each and every operation in all the operations of all of the test cases.
> >
> > Those checks are implemented in context.py functions:
> > check_dev_ino(), check_copy_up(), check_layer()
> >
> > Is my explanation more clear now?
>
> Hi Amir,
>
> Thanks for the explanation. I understand your perspective little
> better now.
>
> But why do we have to enable these st_blocks checks after the test if
> user asked to be mounted with "metacopy=on".
>
> IOW, if user wants to run these additional st_blocks checks, that
> should be drive by explicit option "--meta" to _unionmount_testsuite_run.
>
> Enabling "--meta" implicitly probably does not hurt now given what
> "--meta" is doing but some other option "--foo" might be doing much
> more (including running additional tests) and mapping that becomes
> very tricky and kind of unexpected.
>

Maybe I wasn't accurate in my explanation.

--verify is the only option that *adds* verifications.
I added it for backward compat because old kernels simply do not
pass those verifications (like const st_ino etc).
All the tests I added to xfstests use the --verify option because
want to test the upstream kernel and we want maximum test coverage.

--meta and --xino OTOH do not *add* verifications, they change the
validations that --verify does in subtle ways.

You will have to dive into the check_ functions for the details, they are
not pretty, but for example without --meta st_blocks is checked to be
positive after copy up of not empty file and with --meta it is checked to
be zero (which is actually wrong because xattr takes 1 block in xfs,
but let's not mix reality with theory for now).

Same goes for checks of st_dev and st_ino, they are always checked
for but expectations are different depending on xino and index.

IOW, if we do not parse the mount options to understand them and
just blindly set them, the verifications will likely fail.

Thanks,
Amir.
