Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955E6C77B7D
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 May 2023 19:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjENTQx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 May 2023 15:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjENTQw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 May 2023 15:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31E7E57
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 12:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4952C61074
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 19:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C1BC433D2;
        Sun, 14 May 2023 19:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684091809;
        bh=xekNHIVkx1XnFZFF0wdjeAuf0afkw6rlprkgLb7fia4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVhO9Mc6Wcs+XVWF/sgsAKDi+AjdxRe7ZOc+zY2GahapFlYgps3mC5YjftwjmxQKs
         TIQkPFljS6++avLHkH5IrYakR5bkjp9axATkD++/Qog4oEY0/ExYoNsGCXk8/5TAs4
         trey514EOdxeykmop7bAys7BNgRtWCP514lAkV6Epbz4OJDhv1vZKUbaf4nfPD5cQn
         aW7nEPkGk182NrI9V+tcLLU41FJVFgh9K1cNLYSn/EN3ALxnKWUm9xlVqoMtUYCR+5
         CdFG6VUYaZTKe+IJ9FKXg4cGN80e7LCX1rzIO5MpJv9MvNRkuK19YFcAqSMc78G0db
         ZsvS0uXkF9bKw==
Date:   Sun, 14 May 2023 12:16:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving
 lowerdata
Message-ID: <20230514191647.GD9528@sol.localdomain>
References: <cover.1683102959.git.alexl@redhat.com>
 <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 03, 2023 at 10:51:38AM +0200, Alexander Larsson wrote:
> When resolving lowerdata (lazily or non-lazily) we check the
> overlay.verity xattr on the metadata inode, and if set verify that the
> source lowerdata inode matches it (according to the verity options
> enabled).

Keep in mind that the lifetime of an inode's fsverity digest is from when it is
first opened to when the inode is evicted from the inode cache.

If the inode gets evicted from cache and re-instantiated, it could have been
arbitrarily changed.

Given that, does this verification happen in the right place?  I would have
expected it to happen whenever the file is opened, but it seems you do it when
the dentry is looked up instead.  Maybe that works too, but I'd appreciate an
explanation.

- Eric
