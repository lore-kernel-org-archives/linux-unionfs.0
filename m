Return-Path: <SRS0=SU5x=77=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199E8C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Jun 2020 21:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E25A7208B8
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Jun 2020 21:38:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sm6IJy7W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgFRVij (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 17:38:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51178 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725987AbgFRVij (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jun 2020 17:38:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592516318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i9UQqMWZUWsqX6fhm6e/WcSmEKxCfUrolCxgHUyG2R0=;
        b=Sm6IJy7Wo6MuFJzT7V9Cd20aUZW5AZoowXSN8tsbLQkC1ya+JtOcFE6Ix6bmV50SVJK2mM
        vIyR93VzrSVWp2CWSVeiOpH+8/yS4v95vFkUlQ9bmj4pK6kSBD513L1CKltoojJHUTbjoT
        5uoCW4V2N/AXDXR6FwovILvdmxMHuKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-SoMfKXSFPgKaK8DZT59SFQ-1; Thu, 18 Jun 2020 17:38:33 -0400
X-MC-Unique: SoMfKXSFPgKaK8DZT59SFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF09C107ACCD;
        Thu, 18 Jun 2020 21:38:32 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-20.rdu2.redhat.com [10.10.115.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 591BA5BAC0;
        Thu, 18 Jun 2020 21:38:32 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id BEC46222D7B; Thu, 18 Jun 2020 17:38:31 -0400 (EDT)
Date:   Thu, 18 Jun 2020 17:38:31 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [ANNOUNCE] unionmount-testsuite: master branch updated to 9c60a9c
Message-ID: <20200618213831.GF3814@redhat.com>
References: <20200529164058.4654-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529164058.4654-1-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 29, 2020 at 07:40:58PM +0300, Amir Goldstein wrote:
> Hi All,
> 
> The master branch on the unionmount-testsuite tree [1] has been updated.
> 
> Changes in this update:
> - Support user configurable underlying filesystem
> 
> So far, unionmount-testsuite used hardcoded paths for layers and
> mount point.  Using underlying filesystem other than tmpfs was possible,
> but not very easy to setup.
> 
> This update brings the ability for user to configure custom paths
> with a custom filesystem for the underlying layers.
> This is intended to be used for integration with xfstests [2].
> 
> Here is an excerpt from the README:
> ---
>   The following environment variables are supported:
> 
>   UNIONMOUNT_BASEDIR  - parent dir of all samefs layers (default: /base)

Hi Amir,

I am running these tests with.

UNIONMOUNT_BASEDIR="/mnt/foo/"

- ./run --ov runs fine. But when I try to run it again it complains
  that.

  rm: cannot remove '/mnt/overlayfs//m': Device or resource busy

So I have to first unmount /mnt/overlayfs/m/ and then run tests
again.

I think it will be nice if it can clear the environment by itself.

- I am running one the recent kernel (5.7.0+) and following errors
  out.

# ./run --ov --verify
Environment variables:
UNIONMOUNT_BASEDIR=/mnt/overlayfs/

***
*** ./run --ov --samefs --ts=0 open-plain
***
TEST open-plain.py:10: Open O_RDONLY
/mnt/overlayfs/m/a/foo100: not on union mount

Will spend more time to figure out what happened.

- I am planning to use these environment variables and run overlay over
  virtiofs tests. Can I do the same thing with xfstests overlay tests.
  In README.overlay I see that I need to specify two separate devices.
  Can I specify to directories (and not devices) to be used as TEST
  and SCRATCH and run overlay test.

Thanks
Vivek


> 
>   1) Path should be an existing directory whose content will be deleted.
>   2) Path is assumed to be on a different filesystem than base dir, so
>      --samefs setup is not supported.
> 
>   When user provides UNIONMOUNT_BASEDIR:
> 
>   1) Path should be an existing directory whose content will be deleted.
>   2) Upper layer and middle layers will be created under base dir.
>   3) If UNIONMOUNT_MNTPOINT is not provided, the overlay mount point will
>      be created under base dir.
>   4) If UNIONMOUNT_LOWERDIR is not provided, the lower layer dir will be
>      created under base dir.
>   5) If UNIONMOUNT_LOWERDIR is not provided, the test setup defaults to
>      --samefs (i.e. lower and upper layers are on the same base fs).
>      However, if --maxfs=<M> is specified, a tmpfs instance will be
>      mounted on the lower layer dir that was created under base dir.
> ---
> 
> Many thanks to Vivek for review and testing.
> 
> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/unionmount-testsuite
> [2] https://github.com/amir73il/xfstests/commits/unionmount
> 
> The head of the master branch is commit:
> 
> 9c60a9c Configure custom layers via environment variables
> 
> New commits:
> 
> Amir Goldstein (3):
>   Add command run --clean-up to cleanup old test mounts
>   Stop using bind mounts for --samefs
>   Configure custom layers via environment variables
> 
>  README           |  26 ++++++++++
>  mount_union.py   |  13 +----
>  run              |  32 +++++-------
>  set_up.py        | 127 +++++++++++++++++++++++++----------------------
>  settings.py      |  85 +++++++++++++++++++++++++------
>  unmount_union.py |  15 +++---
>  6 files changed, 187 insertions(+), 111 deletions(-)
> 
> -- 
> 2.17.1
> 

