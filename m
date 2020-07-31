Return-Path: <SRS0=/0gG=BK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419B0C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 18:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23CA321744
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 18:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HI4sCic4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbgGaSWF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 14:22:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387694AbgGaSWF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jul 2020 14:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596219723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bEwwzNCzGwAqvBD587lOaIF2a+xmIwmzTHpripvBqZE=;
        b=HI4sCic4FgASdvZr/SMnu0fp03TahY6XgAfai5LNpUK5LOXwg1kroLw4VFe9ToM+OQpCfy
        AcOFxUWfHiw+tdGHs9jbBysIIPjrrQ1cbvJ0xqEdodv2d+bQJ2Dt1mkEvmCZAcrxgOI7C7
        8FoLJZMIH1QSK3wnyedyv0otw13Mxqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-m8UszkmLMGC2fclGRq-66A-1; Fri, 31 Jul 2020 14:21:59 -0400
X-MC-Unique: m8UszkmLMGC2fclGRq-66A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C16518C63C9;
        Fri, 31 Jul 2020 18:21:58 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-149.rdu2.redhat.com [10.10.115.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F26545D992;
        Fri, 31 Jul 2020 18:21:57 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 7EF20222F73; Fri, 31 Jul 2020 14:21:57 -0400 (EDT)
Date:   Fri, 31 Jul 2020 14:21:57 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [RFC] Passing extra mount options to unionmount tests
Message-ID: <20200731182157.GD189839@redhat.com>
References: <CAOQ4uxhi63LPKdmkEJjnTEgy0VaX0qXML2Uz_258_B2iZcqd3w@mail.gmail.com>
 <20190709141302.GA19084@redhat.com>
 <CAOQ4uxjWc8WFRFS8GTpz8uE1AHrs6yGx2A3fZy-Sxfu7CCyKuw@mail.gmail.com>
 <20200731131244.GA189839@redhat.com>
 <CAOQ4uxivJgHTf-K=AjTcWPbOWNhxY8NGAt=t1XVqwOY-h5J+rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxivJgHTf-K=AjTcWPbOWNhxY8NGAt=t1XVqwOY-h5J+rg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 31, 2020 at 05:09:16PM +0300, Amir Goldstein wrote:
> On Fri, Jul 31, 2020 at 4:13 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Fri, Jul 31, 2020 at 03:35:40PM +0300, Amir Goldstein wrote:
> > > > >
> > > > > If anyone is running unionmount-testsuite on regular basis
> > > > > I would be happy to know which configurations are being tested,
> > > > > because the test matrix grew considerably since I took over the project -
> > > > > both Overlayfs config options and the testsuite config options.
> > > >
> > > > For me, I think I am most interested in configuration used by
> > > > container runtimes (docker/podman). Docker seems to turn off
> > > > redirects as of now. podman is turning on metacopy (hence redirect)
> > > > by default now to see how do things go.
> > > >
> > > > So for me (redirect=on/off and metacopy=on/off) are important
> > > > configurations as of now. Having said that, I think I should talk
> > > > to container folks and encourage them to use "index" and "xino"
> > > > as well to be more posix like fs.
> > > >
> > >
> > > Hi Vivek,
> > >
> > > I remember you asked me about configuring extra mount options
> > > for unionmount but couldn't find that conversation, so replying to this
> > > related old discussion with my thoughts on the subject.
> > >
> > > Now that unionmount supports the environment variables:
> > > UNIONMOUNT_{BASEDIR,LOWERDIR,MNTPOINT}
> > >
> > > And now that xfstests has helpers to convert xfstests env vars to
> > > UNIONMOUNT_* env vars, one might ask: why won't we support
> > > UNIONMOUNT_OPTIONS=$OVERLAY_MOUNT_OPTIONS
> > >
> > > So when you asked me a question along those lines, my answer was that
> > > unionmount performs different validations depending on the test options,
> > > so for example, the test option ./run --meta adds the mount option
> > > "metacopy=on", but it also performs different validation tests, such as
> > > upper file st_blocks == 0 after metadata change.
> > >
> > > Right, so I gave a reason for why supporting extra mount options is not
> > > straight forward, but that doesn't mean that it is not possible.
> > > unionmount test could very well parse the extra mount options passed
> > > in env var and translate them to test config options.
> >
> > Hi Amir,
> >
> > I am not able to understand this point. Why an extra mount option
> > needs to be translated into a "test config" option. If I pass
> > "metacopy=on", that does not mean that I also want to run tests
> > which verify st_blocks == 0 on upper. It just means that whatever
> > tests I am running, are run with metacopy=on. All I want to make
> > sure that tests I am running are not broken if run with metacopy=on.
> >
> 
> I guess the confusion is what defines a "test".
> 
> A specific xfstests test script (e.g. overlay/060) defines:
> - requirements (run or skip)
> - setup and operations to execute
> - expectations
> 
> So when you pass extra mount options it might:
> - cause test not to meet requirements and be skipped
> - affect the setup/operations
> - usually it does not change the expectations
> 
> But you can also define some global options like
> USE_KMEMLEAK, TEST_XFS_REPAIR_REBUILD, TEST_XFS_SCRUB
> which affect the validations that are run after each test
> in *addition* to the specific expectations encoded in the test script.
> 
> A specific unionmount test (e.g. tests/rename-pop-dir.py) defines only:
> - operations to execute
> - expected return value
> 
> But the test engine performs extra validations after *each* operation
> in addition to verifying the expected return value.
> 
> So when I write "verify st_blocks == 0 on upper", this is not an expectation
> that is explicitly written in any specific test.
> The test engine records the state of objects before and after each filesystem
> operation is executed to know for each object if it is expected to be lower,
> metacopy,upper and then it runs some validations after each operation
> (like upper st_blocks) to verify that the actual state of the object matches the
> expected state.
> 
> The test run option --xdev only is similar to the xfstests requirement
> and it skips a few dir rename tests and changes expected return
> value in others.
> 
> But the test run options --verify, --meta, --xino, --verify, are global test
> options which determine what sort of validations are performed after
> each and every operation in all the operations of all of the test cases.
> 
> Those checks are implemented in context.py functions:
> check_dev_ino(), check_copy_up(), check_layer()
> 
> Is my explanation more clear now?

Hi Amir,

Thanks for the explanation. I understand your perspective little
better now.

But why do we have to enable these st_blocks checks after the test if
user asked to be mounted with "metacopy=on". 

IOW, if user wants to run these additional st_blocks checks, that
should be drive by explicit option "--meta" to _unionmount_testsuite_run.

Enabling "--meta" implicitly probably does not hurt now given what
"--meta" is doing but some other option "--foo" might be doing much
more (including running additional tests) and mapping that becomes
very tricky and kind of unexpected.

So how about we keep it simple. That is we don't try to map mount
options to associated arguments to unionmount testsuite. We probably
just need to detect conflicts and then skip test? For example, if
I run "_unionmount_testsuite_run --ov --meta" and also specifcy
"metacopy=off", then its a conflict and probably need to either
skip this test or error out and point towards the conflict etc.

If I pass mount option "metacopy=on" I don't expect unionmount
testsuite to suddenly start verifying that on upper layer st_blocks==0.
That I will expect from a specific test or if I call
"_unionmount_testsuite_run --ov --meta". This is not necessarily
similar to generally xfs options you mentioned for additional
verification, because unionmount testsuite options are generic
and one can implement anything behind these options (and are not
limited to additional verification only).

I don't have too detailed understanding of design of both testsuites.
So all my thoughts are from a pure user perspective. 

Thanks
Vivek

> It is clear why unionmount needs to parse mount options in order
> to set the expectations from validators?
> 
> If that is clear, please review my proposal to see if I missed anything.
> 
> Thanks,
> Amir.
> 

