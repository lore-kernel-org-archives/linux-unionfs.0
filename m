From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/8] xfs: use uuid_copy() helper to abstract uuid_t
Date: Thu, 4 May 2017 15:31:04 +0200
Message-ID: <20170504133104.GC17222@lst.de>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com> <1493904383-2187-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49701 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751297AbdEDNbG (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 09:31:06 -0400
Content-Disposition: inline
In-Reply-To: <1493904383-2187-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
