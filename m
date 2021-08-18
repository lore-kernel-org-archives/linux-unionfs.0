Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6B0C4320E
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 14:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F936610D2
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 14:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbhHRO1B (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 10:27:01 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:55064 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238621AbhHRO1A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Aug 2021 10:27:00 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGMWH-00DlOr-Vq; Wed, 18 Aug 2021 14:26:18 +0000
Date:   Wed, 18 Aug 2021 14:26:17 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v2 0/2] allow overlayfs to do RCU lookups
Message-ID: <YR0YiSP3DliPCPWF@zeniv-ca.linux.org.uk>
References: <20210818133400.830078-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818133400.830078-1-mszeredi@redhat.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 18, 2021 at 03:33:58PM +0200, Miklos Szeredi wrote:
> I'd really like to fix this in some form, but not getting any response
> [1][2][3].
> 
> Al, Linus, can you please comment?
> 
> I'm happy to take this through the overlayfs tree, just need an ACK for the
> VFS API change.

Looks reasonable enough; I'm not too happy about yet another place LOOKUP_...
details get tangled into, though.  Do we want it to be more than just a
bool rcu?
