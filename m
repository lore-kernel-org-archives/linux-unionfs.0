Return-Path: <SRS0=fhJW=AU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E255AC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Jul 2020 14:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE1662073A
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Jul 2020 14:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cikU7yHs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgGIOOq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 10:14:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38497 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726371AbgGIOOq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Jul 2020 10:14:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594304084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PH23pZg9GGYiHcI40sWq9A0L0MZVz2Uie+G1Ouos670=;
        b=cikU7yHsymvZK8eO8+VC8oOXVxLWT4incbItX+1vVHzSHmbRUAN0fWF1485CZwKy3tV/xG
        AoXKFpOZ/3JXxq6jxaYFqz2FC1GTbZVIhLGN8yXj1qfvM5qksW6CQAuZxbBwscnfytZG3u
        UrznlrSWJKq9mfB/7fMp0IOE8qkJ9T4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-w2V0GcqAMMqVuVsHzVzLbA-1; Thu, 09 Jul 2020 10:14:40 -0400
X-MC-Unique: w2V0GcqAMMqVuVsHzVzLbA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA42A100CC84;
        Thu,  9 Jul 2020 14:14:39 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-114.rdu2.redhat.com [10.10.115.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E1FA797FE;
        Thu,  9 Jul 2020 14:14:39 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 1D8CB220689; Thu,  9 Jul 2020 10:14:39 -0400 (EDT)
Date:   Thu, 9 Jul 2020 10:14:39 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] overlayfs, doc: Do not allow lower layer recreation with
 redirect_dir enabled
Message-ID: <20200709141439.GD150543@redhat.com>
References: <20200709140220.GC150543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709140220.GC150543@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 09, 2020 at 10:02:20AM -0400, Vivek Goyal wrote:
> Currently we seem to support lower layer recreation and re-use with existing
> upper until and unless "index" or "metadata only copy up" feature is
> enabled.
> 
> If redirect_dir feature is enabled then re-creating/modifying lower layers
> will break things. For example.
> 
> - mkdir lower lower/foo upper work merged
> - touch lower/foo/foo-child
> - mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,redirect_dir=on none merged
> - mv merged/foo merged/bar
> - ls merged/bar/ (this should list foo-child)
> 
> - umount merged
> - mv lower/foo lower/baz
> - mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,redirect_dir=on none merged
> - ls merged/bar/  (Now foo-child has disappeared)
> 
> IOW, modifying lower layers did not crash overlay but it resulted in
> directory contents being lost and that can be unexpected. So don't
> support lower layer recreation/modification when redirect_dir is enabled
> at any point of time.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 660dbaf0b9b8..1d1a8da7fdbc 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -371,8 +371,8 @@ conflict with metacopy=on, and will result in an error.
>  [*] redirect_dir=follow only conflicts with metacopy=on if upperdir=... is
>  given.
>  
> -Sharing and copying layers
> ---------------------------
> +Sharing, copying and recreating lower layers
> +--------------------------------------------
>  
>  Lower layers may be shared among several overlay mounts and that is indeed
>  a very common practice.  An overlay mount may use the same lower layer
> @@ -388,8 +388,12 @@ though it will not result in a crash or deadlock.
>  
>  Mounting an overlay using an upper layer path, where the upper layer path
>  was previously used by another mounted overlay in combination with a
> -different lower layer path, is allowed, unless the "inodes index" feature
> -or "metadata only copy up" feature is enabled.
> +different lower layer path, is allowed, unless any of the following features
> +is enabled at any point of time.
> +
> +- inode index
> +- metadata only copy up
> +- redirect_dir

I probably should add "nfs_export" to the list as well. Though it is
implicitly there as enabling nfs export requires to enable index. But
saying it explicitly is even better.

Vivek

>  
>  With the "inodes index" feature, on the first time mount, an NFS file
>  handle of the lower layer root directory, along with the UUID of the lower
> -- 
> 2.25.4
> 

