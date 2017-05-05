From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmpfs: generate random sb->s_uuid
Date: Fri, 5 May 2017 03:01:26 -0700
Message-ID: <20170505100126.GA20759@infradead.org>
References: <1493977468-21143-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38253 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdEEKBa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 May 2017 06:01:30 -0400
Content-Disposition: inline
In-Reply-To: <1493977468-21143-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

On Fri, May 05, 2017 at 12:44:28PM +0300, Amir Goldstein wrote:
> This is used by overlayfs to encode intrasystem unique file handles.

I think generate_random_uuid is the wrong interface to spread.
The right one would be uuid_be_gen, although I'll still need
to audit why one uses get_random_bytes and the other prandom_bytes.
