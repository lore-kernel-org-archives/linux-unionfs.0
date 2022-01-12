Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99ABC433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Jan 2022 22:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiALWZx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 17:25:53 -0500
Received: from vulcan.kevinlocke.name ([107.191.43.88]:54870 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiALWZw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jan 2022 17:25:52 -0500
Received: from kevinolos.kevinlocke.name (2600-6c67-5000-3d1b-b28c-d903-f5f4-e11e.res6.spectrum.com [IPv6:2600:6c67:5000:3d1b:b28c:d903:f5f4:e11e])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 73C252A5C87B;
        Wed, 12 Jan 2022 22:25:50 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id A95F61300153; Wed, 12 Jan 2022 15:25:48 -0700 (MST)
Date:   Wed, 12 Jan 2022 15:25:48 -0700
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Christoph Fritz <chf.fritz@googlemail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix NULL pointer dereference
Message-ID: <Yd9VbP3ruJNQbJsA@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
References: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
 <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com>
 <Yd9A9g9nsjwmbZtm@kevinlocke.name>
 <61820434137bd1be48b58cb25fcd4366db26a794.camel@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61820434137bd1be48b58cb25fcd4366db26a794.camel@googlemail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 2022-01-12 at 22:06 +0100, Christoph Fritz wrote:
>>> These have been -ENOIOCTLCMD errors but got (falsely?) converted to
>>> -ENOTTY by the recently introduced commit 5b0a414d06c3 ("ovl: fix
>>> filattr copy-up failure"):
>> 
>> Which filesystem are you using for upper (and lower) in your mount?
> 
> 
> It's tmpfs.
> 
>> Presumably the upper doesn't support file attributes, if it returns
>> -ENOIOCTLCMD?
> 
> 
> Tmpfs does support file attributes.

Although tmpfs can support extended attributes (attr(1)/xattr(7)) with
CONFIG_TMPFS_XATTR, I'm not aware of support for traditional
attributes (chattr(1)).  I'm also not able to reproduce the error
message you mentioned with extended attributes.  With your patch[^1]
applied to 5.16, I ran the following:

    mkdir lower upwork overlay
    mount -t tmpfs - lower
    mount -t tmpfs - upwork
    mkdir upwork/upper upwork/work
    touch lower/file.txt
    setfacl -m 'u:0:rwx' lower/file.txt
    mount -t overlay -o "lowerdir=$PWD/lower,upperdir=$PWD/upwork/upper,workdir=$PWD/upwork/work" - overlay
    mv overlay/file.txt overlay/file2.txt
    getfattr -d -m '.*' overlay/file2.txt

This copied file.txt from lower to upper with the
system.posix_acl_access extended attribute and did not print any
messages from overlayfs to the kernel log.

Could you provide a minimal, reproducible example for the log messages
you mentioned observing?

Thanks,
Kevin

[^1]: https://lore.kernel.org/linux-unionfs/10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com/
