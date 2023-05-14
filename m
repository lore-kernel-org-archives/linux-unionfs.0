Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD6EC77B7F
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 May 2023 19:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjENTJH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 May 2023 15:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjENTJH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 May 2023 15:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AEF1730
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 12:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F2F960BFB
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 19:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE984C433D2;
        Sun, 14 May 2023 19:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684091344;
        bh=Moa9fzqHOwy6jH8EAfTeFjwksw/KMz/Y8unEaCjR2MA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jbseyD811cXZlf494ZhCf2hWPjsZIYOI0oCx8PP+fDBpU0U+GtT3zS+rW40X3SVfv
         v6D2snlC7g4XXF8h7C0IIoGszGWVFDmL5dY7MpOfDG1e8wYXfAQOj1QxDxmhDhnJLy
         ld+4fuKkTEprNSh8wodF2y6JLor8RjU/XSCj2Ydsi1hYEe97BonXQLfgLmW6oLolp3
         IuBo8RwQymsn158zP9VAmtZQ1nqgpk7wfMxSHXK8SWWJjrcP55jna7E0WoCzw5YFLS
         e+0fAG2zBwWvxdMw26+BnnXG40GN/85gtRzm+rT1y20JRpDUGo+Ad2OnKbupMlYMC7
         pt1YJZVipiKsQ==
Date:   Sun, 14 May 2023 12:09:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Subject: Re: [PATCH v2 0/6] ovl: Add support for fs-verity checking of
 lowerdata
Message-ID: <20230514190903.GC9528@sol.localdomain>
References: <cover.1683102959.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683102959.git.alexl@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Alexander,

On Wed, May 03, 2023 at 10:51:33AM +0200, Alexander Larsson wrote:
> This patchset adds support for using fs-verity to validate lowerdata
> files by specifying an overlay.verity xattr on the metacopy
> files.
> 
> This is primarily motivated by the Composefs usecase, where there will
> be a read-only EROFS layer that contains redirect into a base data
> layer which has fs-verity enabled on all files. However, it is also
> useful in general if you want to ensure that the lowerdata files
> matches the expected content over time.
> 
> This patch series is based on the lazy lowerdata patch series by Amir[1].
> 
> I have also added some tests for this feature to xfstests[2].
> 
> I'm also CC:ing the fsverity list and maintainers because there is one
> (tiny) fsverity change, and there may be interest in this usecase.
> 
> Changes since v1:
>  * Rebased on v2 lazy lowerdata series
>  * Dropped the "validate" mount option variant. We now only support
>    "off", "on" and "require", where "off" is the default.
>  * We now store the digest algorithm used in the overlay.verity xattr.
>  * Dropped ability to configure default verity options, as this could
>    cause problems moving layers between machines.
>  * We now properly resolve dependent mount options by automatically
>    enabling metacopy and redirect_dir if verity is on, or failing
>    if the specified options conflict.
>  * Streamlined and fixed the handling of creds in ovl_ensure_verity_loaded().
>  * Renamed new helpers from ovl_entry_path_ to ovl_e_path_
> 
> [1] https://lore.kernel.org/linux-unionfs/20230427130539.2798797-1-amir73il@gmail.com/T/#m3968bf64a31946e77bdba8e3d07688a34cf79982
> [2] https://github.com/alexlarsson/xfstests/commits/verity-tests
> 
> Alexander Larsson (6):
>   fsverity: Export fsverity_get_digest
>   ovl: Break out ovl_e_path_real() from ovl_i_path_real()
>   ovl: Break out ovl_e_path_lowerdata() from ovl_path_lowerdata()
>   ovl: Add framework for verity support
>   ovl: Validate verity xattr when resolving lowerdata
>   ovl: Handle verity during copy-up
> 
>  Documentation/filesystems/overlayfs.rst |  27 ++++
>  fs/overlayfs/copy_up.c                  |  31 +++++
>  fs/overlayfs/namei.c                    |  42 +++++-
>  fs/overlayfs/overlayfs.h                |  12 ++
>  fs/overlayfs/ovl_entry.h                |   3 +
>  fs/overlayfs/super.c                    |  74 ++++++++++-
>  fs/overlayfs/util.c                     | 165 ++++++++++++++++++++++--
>  fs/verity/measure.c                     |   1 +
>  8 files changed, 343 insertions(+), 12 deletions(-)

Thanks for presenting this topic at LSFMM!

I'm not an expert in overlayfs, but I've been working through this patchset.

One thing that seems to be missing, and has been tripping me up while reviewing
this patchset, is that the overlayfs documentation
(Documentation/filesystems/overlayfs.rst) is not properly up to date with the
use case that is intended here.

For example, the overlayfs documentation says "An overlay filesystem combines
two filesystems - an 'upper' filesystem and a 'lower' filesystem.".

Apparently, that is out of date.  I think a correct statement would be: An
overlay filesystem combines an optional upper directory with one or more lower
directories.

And as I understand it, the use case here actually involves two lower
directories and no upper directory.

There is also the "metacopy" feature, which the documentation describes in the
section "Metadata only copy up".  The documentation makes it sound like an
overlayfs internal optimization.

However, when this patchset introduces the fsverity support, it talks about
"metacopy files".  As I understand it, the user is expected to create a
read-only filesystem that contains these "metacopy files".  It doesn't seem to
be documented what these are, exactly, and how to create them.  I assume that
these are part of the implementation of "Metadata only copy up", but there seems
to be a gap where the documentation goes from describing the behavior of
"metadata only copy up", to expecting users of overlayfs to know what a
"metacopy file" is and how to create them.

I think that it would be easier to understand and review this feature if the
documentation was gotten up to date.

- Eric
