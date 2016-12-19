From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] generic/396: test correct d_type value
Date: Mon, 19 Dec 2016 08:22:47 -0800
Message-ID: <20161219162247.GA12627@infradead.org>
References: <1482164108-19389-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753932AbcLSQWu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Dec 2016 11:22:50 -0500
Content-Disposition: inline
In-Reply-To: <1482164108-19389-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Dec 19, 2016 at 06:15:08PM +0200, Amir Goldstein wrote:
> Verify correct d_type values of dir enrties.
> 
> This test would fail for file systems with no d_type support,
> but I have no idea how to test d_type support in a generic way,
> without confusing a bug of d_type = DT_UNKNOWN with no support.

XFS v4 without the rare ftype feature is such a file system.

We'll need to detect it, and I think a large enough directory where
all entries but . and .. are DT_UNKNOWN should be a clear indicator.

If that's a bug it's clearly not distinguishable from a non-buggy fs :)
