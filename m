Return-Path: <SRS0=/0gG=BK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4042BC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 13:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A3C7206FA
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 13:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QGMC2z5E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgGaNM6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 09:12:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31192 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728379AbgGaNM6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jul 2020 09:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596201176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=66d1M6hrTy9SiiFipTdqGkv3Zs0wWt8fQw2i9Iihei4=;
        b=QGMC2z5EeArsJqcz5iaHroNugBlJ/ko1ksM1xXcfJalF+e1mX7LG3ROS3Sj+57NQ0Iiuw8
        XHjWD9Vg/yO4X0ZFjiwJqZDJ2rTrNi/5h3+UmtGVrA+5WS0E0vm+xG1S7jweNkggloz4oC
        q1uyemAGwl0fHjsM4kj5t3MAaOO/Fr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-hGVmpy_lMYCtWPhpL-ogXA-1; Fri, 31 Jul 2020 09:12:47 -0400
X-MC-Unique: hGVmpy_lMYCtWPhpL-ogXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFA9F100CD00;
        Fri, 31 Jul 2020 13:12:45 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-149.rdu2.redhat.com [10.10.115.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E188119728;
        Fri, 31 Jul 2020 13:12:44 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 740B9222F73; Fri, 31 Jul 2020 09:12:44 -0400 (EDT)
Date:   Fri, 31 Jul 2020 09:12:44 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [RFC] Passing extra mount options to unionmount tests
Message-ID: <20200731131244.GA189839@redhat.com>
References: <CAOQ4uxhi63LPKdmkEJjnTEgy0VaX0qXML2Uz_258_B2iZcqd3w@mail.gmail.com>
 <20190709141302.GA19084@redhat.com>
 <CAOQ4uxjWc8WFRFS8GTpz8uE1AHrs6yGx2A3fZy-Sxfu7CCyKuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjWc8WFRFS8GTpz8uE1AHrs6yGx2A3fZy-Sxfu7CCyKuw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 31, 2020 at 03:35:40PM +0300, Amir Goldstein wrote:
> > >
> > > If anyone is running unionmount-testsuite on regular basis
> > > I would be happy to know which configurations are being tested,
> > > because the test matrix grew considerably since I took over the project -
> > > both Overlayfs config options and the testsuite config options.
> >
> > For me, I think I am most interested in configuration used by
> > container runtimes (docker/podman). Docker seems to turn off
> > redirects as of now. podman is turning on metacopy (hence redirect)
> > by default now to see how do things go.
> >
> > So for me (redirect=on/off and metacopy=on/off) are important
> > configurations as of now. Having said that, I think I should talk
> > to container folks and encourage them to use "index" and "xino"
> > as well to be more posix like fs.
> >
> 
> Hi Vivek,
> 
> I remember you asked me about configuring extra mount options
> for unionmount but couldn't find that conversation, so replying to this
> related old discussion with my thoughts on the subject.
> 
> Now that unionmount supports the environment variables:
> UNIONMOUNT_{BASEDIR,LOWERDIR,MNTPOINT}
> 
> And now that xfstests has helpers to convert xfstests env vars to
> UNIONMOUNT_* env vars, one might ask: why won't we support
> UNIONMOUNT_OPTIONS=$OVERLAY_MOUNT_OPTIONS
> 
> So when you asked me a question along those lines, my answer was that
> unionmount performs different validations depending on the test options,
> so for example, the test option ./run --meta adds the mount option
> "metacopy=on", but it also performs different validation tests, such as
> upper file st_blocks == 0 after metadata change.
> 
> Right, so I gave a reason for why supporting extra mount options is not
> straight forward, but that doesn't mean that it is not possible.
> unionmount test could very well parse the extra mount options passed
> in env var and translate them to test config options.

Hi Amir,

I am not able to understand this point. Why an extra mount option
needs to be translated into a "test config" option. If I pass
"metacopy=on", that does not mean that I also want to run tests
which verify st_blocks == 0 on upper. It just means that whatever
tests I am running, are run with metacopy=on. All I want to make
sure that tests I am running are not broken if run with metacopy=on.

Thanks
Vivek

> As a matter of fact,
> unionmount already parses the following overlay module parameters
> and translates the following values to test config options:
> 
> 1) redirect_dir does not exist => --xdev (expect EXDEV on dir rename)
> 2) redirect_dir exists and no explicit --xdev => add redirect_dir=on
> 3) index=N and --verify => add index=on and check st_ino validations
> 4) metacopy=Y => check --meta validations (e.g. upper st_blocks)
> 5) xino_auto=Y => add xino=on and check --xino validations (e.g. uniform st_dev)
> 
> So apart from blindly adding the extra mount options to mount command,
> will also need to translate:
> 
> 6) redirect_dir=off => --xdev
>    (redirect_dir=on conflicts with --xdev)
> 7) index=off => overrides index=on added by --verify
>    (st_ino validations should still pass on tests without multi layers)
> 8) metacopy=on => --meta
>    (metacopy=off conflicts with --meta)
> 9) xino=auto/on => --xino
>    (xino=off conflicts with --xino)
> 
> At the moment, I have a patch to xfstests [1] that implements rule 8 in the
> xfstests _unionmount_testsuite_run helper, but I came to realize that would
> be wrong and that the correct way would be to implement conversion rules
> 6-9 in unionmount itself and then blindly assign in xfstest helper:
> UNIONMOUNT_OPTIONS=$OVL_BASE_MOUNT_OPTIONS
> 
> Does anyone spot any obvious flaws in this plan before I make those changes?
> 
> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/xfstests/commits/unionmount
> 

